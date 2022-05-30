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

#include "accelerometer_handler.h"
#include <M5StickC.h>

int begin_index = 0;

float save_data[600] = {0.0};
bool pending_initial_data = true;
long last_sample_millis = 0;

TfLiteStatus SetupAccelerometer(tflite::ErrorReporter* error_reporter) {
  M5.IMU.Init();
  error_reporter->Report("IMU Init");

  return kTfLiteOk;
}

static bool UpdateData() {
  bool new_data = false;
  if ((millis() - last_sample_millis) < 40) {
    return false;
  }
  last_sample_millis = millis();

  float accX = 0.0F;
  float accY = 0.0F;
  float accZ = 0.0F;
  M5.IMU.getAccelData(&accX, &accY, &accZ);

  save_data[begin_index++] = 1000 * accZ;
  save_data[begin_index++] = 1000 * accX;
  save_data[begin_index++] = 1000 * accY;

  if (begin_index >= 600) {
    begin_index = 0;
  }
  new_data = true;

  return new_data;
}

bool ReadAccelerometer(tflite::ErrorReporter* error_reporter, float* input,
                       int length, bool reset_buffer) {
  if (reset_buffer) {
    memset(save_data, 0, 600 * sizeof(float));
    begin_index = 0;
    pending_initial_data = true;
  }

  if (!UpdateData()) {
    return false;
  }

  if (pending_initial_data && begin_index >= 200) {
    pending_initial_data = false;
  }

  if (pending_initial_data) {
    return false;
  }

  for (int i = 0; i < length; ++i) {
    int ring_array_index = begin_index + i - length;
    if (ring_array_index < 0) {
      ring_array_index += 600;
    }
    input[i] = save_data[ring_array_index];
  }
  return true;
}
