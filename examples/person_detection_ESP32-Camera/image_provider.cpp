
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
#include "image_provider.h"

#include <cstdlib>
#include <cstring>
#include <iostream>

#include "app_camera_esp.h"
#include "esp_camera.h"
#include "esp_log.h"
#include "esp_spi_flash.h"
#include "esp_system.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#define TF_LITE_REPORT_ERROR(reporter, ...) \
  do {                                      \
    reporter->Report(__VA_ARGS__);          \
  } while (false)

camera_fb_t* fb = NULL;
static const char* TAG = "app_camera";

// Get the camera module ready
TfLiteStatus InitCamera(tflite::ErrorReporter* error_reporter) {
  int ret = app_camera_init();
  if (ret != 0) {
    TF_LITE_REPORT_ERROR(error_reporter, "Camera init failed\n");
    return kTfLiteError;
  }
  TF_LITE_REPORT_ERROR(error_reporter, "Camera Initialized\n");
  return kTfLiteOk;
}

extern "C" int capture_image() {
  fb = esp_camera_fb_get();
  if (!fb) {
    ESP_LOGE(TAG, "Camera capture failed");
    return -1;
  }
  return 0;
}
// Begin the capture and wait for it to finish
TfLiteStatus PerformCapture(tflite::ErrorReporter* error_reporter,
                            uint8_t* image_data) {
  /* 2. Get one image with camera */
  int ret = capture_image();
  if (ret != 0) {
    return kTfLiteError;
  }
  if (fb->width == 96 && fb->height == 96) {
    memcpy(image_data, fb->buf, fb->len);
  } else {
    // Trimming Image
    int post = 0;
    int startx = (fb->width - 96) / 2;
    int starty = (fb->height - 96) / 2;
    for (int y = 0; y < 96; y++) {
      for (int x = 0; x < 96; x++) {
        int getPos = (starty + y) * fb->width + startx + x;
        image_data[post] = fb->buf[getPos];
        post++;
      }
    }
  }
  esp_camera_fb_return(fb);

  // Debug Out
  TF_LITE_REPORT_ERROR(error_reporter, "");
  char str[128];
  for (int y = 0; y < 96; y += 4) {
    int pos = 0;
    memset(str, 0, sizeof(str));
    for (int x = 0; x < 96; x += 2) {
      int getPos = y * 96 + x;
      int color = image_data[getPos];

      if (color > 224) {
        str[pos] = ' ';
      } else if (color > 192) {
        str[pos] = '-';
      } else if (color > 160) {
        str[pos] = '+';
      } else if (color > 128) {
        str[pos] = '=';
      } else if (color > 96) {
        str[pos] = '*';
      } else if (color > 64) {
        str[pos] = 'H';
      } else if (color > 32) {
        str[pos] = '#';
      } else {
        str[pos] = 'M';
      }

      pos++;
    }
    TF_LITE_REPORT_ERROR(error_reporter, str);
  }

  /* here the esp camera can give you grayscale image directly */
  return kTfLiteOk;
}

// Get an image from the camera module
TfLiteStatus GetImage(tflite::ErrorReporter* error_reporter, int image_width,
                      int image_height, int channels, uint8_t* image_data) {
  static bool g_is_camera_initialized = false;
  if (!g_is_camera_initialized) {
    TfLiteStatus init_status = InitCamera(error_reporter);
    if (init_status != kTfLiteOk) {
      TF_LITE_REPORT_ERROR(error_reporter, "InitCamera failed\n");
      return init_status;
    }
    g_is_camera_initialized = true;
  }
  /* Camera Captures Image of size 96 x 96  which is of the format grayscale
     thus, no need to crop or process further , directly send it to tf */
  TfLiteStatus capture_status = PerformCapture(error_reporter, image_data);
  if (capture_status != kTfLiteOk) {
    TF_LITE_REPORT_ERROR(error_reporter, "PerformCapture failed\n");
    return capture_status;
  }
  return kTfLiteOk;
}
