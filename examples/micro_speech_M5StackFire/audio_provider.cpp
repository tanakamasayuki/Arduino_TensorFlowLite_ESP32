/* Copyright 2019 The TensorFlow Authors. All Rights Reserved.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  ==============================================================================*/

#include "audio_provider.h"
#include "micro_model_settings.h"
#include <Arduino.h>
#include <M5Stack.h>
#include <driver/i2s.h>

#define BACKLIGHT         32

#define I2S_NUM           I2S_NUM_0           // 0 or 1
#define I2S_SAMPLE_RATE   16000
#define ADC_INPUT         ADC1_GPIO34_CHANNEL // ADC CHANNEL
#define ADC_UNIT          ADC_UNIT_1          // ADC1 or ADC2

#define BUFFER_SIZE       512

void CaptureSamples();
extern QueueHandle_t xQueueAudioWave;

namespace {
bool g_is_audio_initialized = false;
// An internal buffer able to fit 16x our sample size
constexpr int kAudioCaptureBufferSize = BUFFER_SIZE * 16;
int16_t g_audio_capture_buffer[kAudioCaptureBufferSize];
// A buffer that holds our output
int16_t g_audio_output_buffer[kMaxAudioSampleSize];
// Mark as volatile so we can check in a while loop to see if
// any samples have arrived yet.
volatile int32_t g_latest_audio_timestamp = 0;
// Our callback buffer for collecting a chunk of data
volatile int16_t recording_buffer[BUFFER_SIZE];
}  // namespace

void InitI2S()
{
  i2s_config_t i2s_config = {
    .mode                 = (i2s_mode_t)(I2S_MODE_MASTER | I2S_MODE_RX | I2S_MODE_ADC_BUILT_IN),
    .sample_rate          = I2S_SAMPLE_RATE,
    .bits_per_sample      = I2S_BITS_PER_SAMPLE_16BIT,
    .channel_format       = I2S_CHANNEL_FMT_ALL_LEFT,
    .communication_format = I2S_COMM_FORMAT_I2S_MSB,
    .intr_alloc_flags     = ESP_INTR_FLAG_LEVEL1,
    .dma_buf_count        = 4,
    .dma_buf_len          = 512,
    .use_apll             = false,
    .tx_desc_auto_clear   = false,
    .fixed_mclk = 0
  };

  i2s_driver_install(I2S_NUM, &i2s_config, 0, NULL);
  i2s_set_adc_mode(ADC_UNIT_1, ADC_INPUT);
  i2s_set_clk(I2S_NUM, I2S_SAMPLE_RATE, I2S_BITS_PER_SAMPLE_16BIT, I2S_CHANNEL_MONO);
  i2s_adc_enable(I2S_NUM);
}

void AudioRecordingTask(void *pvParameters) {
  static uint16_t audio_idx = 0;
  size_t bytes_read;
  uint16_t i2s_data;
  int16_t sample;

  while (1) {

    if (audio_idx >= BUFFER_SIZE) {
      xQueueSend(xQueueAudioWave, &sample, 0);
      CaptureSamples();
      audio_idx = 0;
    }

    i2s_read(I2S_NUM_0, &i2s_data, 2, &bytes_read, portMAX_DELAY );

    if (bytes_read > 0) {
      sample = (0xfff - (i2s_data & 0xfff)) - 0x800;
      recording_buffer[audio_idx] = sample;
      audio_idx++;
    }
  }
}

void CaptureSamples() {
  // This is how many bytes of new data we have each time this is called
  const int number_of_samples = BUFFER_SIZE;
  // Calculate what timestamp the last audio sample represents
  const int32_t time_in_ms =
    g_latest_audio_timestamp +
    (number_of_samples / (kAudioSampleFrequency / 1000));
  // Determine the index, in the history of all samples, of the last sample
  const int32_t start_sample_offset =
    g_latest_audio_timestamp * (kAudioSampleFrequency / 1000);
  // Determine the index of this sample in our ring buffer
  const int capture_index = start_sample_offset % kAudioCaptureBufferSize;
  // Read the data to the correct place in our buffer, note 2 bytes per buffer entry
  memcpy(g_audio_capture_buffer + capture_index, (void *)recording_buffer, BUFFER_SIZE * 2);
  // This is how we let the outside world know that new audio data has arrived.
  g_latest_audio_timestamp = time_in_ms;

  //int peak = (max_audio - min_audio);
  //Serial.printf("peak-to-peak:  %6d\n", peak);
}

TfLiteStatus InitAudioRecording(tflite::ErrorReporter* error_reporter) {
  delay(10);

  pinMode( BACKLIGHT, OUTPUT );
  digitalWrite( BACKLIGHT, HIGH ); // This gives the least noise
  ledcDetachPin(25);

  InitI2S();

  xTaskCreatePinnedToCore(AudioRecordingTask, "AudioRecordingTask", 2048, NULL, 10, NULL, 0);

  // Block until we have our first audio sample
  while (!g_latest_audio_timestamp) {
    delay(1);
  }

  return kTfLiteOk;
}

TfLiteStatus GetAudioSamples(tflite::ErrorReporter* error_reporter,
                             int start_ms, int duration_ms,
                             int* audio_samples_size, int16_t** audio_samples) {
  // Set everything up to start receiving audio
  if (!g_is_audio_initialized) {
    TfLiteStatus init_status = InitAudioRecording(error_reporter);
    if (init_status != kTfLiteOk) {
      return init_status;
    }
    g_is_audio_initialized = true;
  }
  // This next part should only be called when the main thread notices that the
  // latest audio sample data timestamp has changed, so that there's new data
  // in the capture ring buffer. The ring buffer will eventually wrap around and
  // overwrite the data, but the assumption is that the main thread is checking
  // often enough and the buffer is large enough that this call will be made
  // before that happens.

  // Determine the index, in the history of all samples, of the first
  // sample we want
  const int start_offset = start_ms * (kAudioSampleFrequency / 1000);
  // Determine how many samples we want in total
  const int duration_sample_count =
    duration_ms * (kAudioSampleFrequency / 1000);
  for (int i = 0; i < duration_sample_count; ++i) {
    // For each sample, transform its index in the history of all samples into
    // its index in g_audio_capture_buffer
    const int capture_index = (start_offset + i) % kAudioCaptureBufferSize;
    // Write the sample to the output buffer
    g_audio_output_buffer[i] = g_audio_capture_buffer[capture_index];
  }

  // Set pointers to provide access to the audio
  *audio_samples_size = kMaxAudioSampleSize;
  *audio_samples = g_audio_output_buffer;

  return kTfLiteOk;
}

int32_t LatestAudioTimestamp() {
  return g_latest_audio_timestamp;
}
