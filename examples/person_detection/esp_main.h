// Copyright 2020-2021 Espressif Systems (Shanghai) PTE LTD
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// choice CAMERA_MODULE
#define CONFIG_CAMERA_MODULE_WROVER_KIT true
//#define CONFIG_CAMERA_MODULE_ESP_EYE true
//#define CONFIG_CAMERA_MODULE_ESP_S2_KALUGA true
//#define CONFIG_CAMERA_MODULE_ESP_S3_EYE true
//#define CONFIG_CAMERA_MODULE_ESP32_CAM_BOARD true
//#define CONFIG_CAMERA_MODULE_M5STACK_PSRAM true
//#define CONFIG_CAMERA_MODULE_M5STACK_WIDE true
//#define CONFIG_CAMERA_MODULE_AI_THINKER true
//#define CONFIG_CAMERA_MODULE_CUSTOM true

// Enable this to do inference on embedded images
#define CLI_ONLY_INFERENCE 1

// Enable this to get cpu stats
#define COLLECT_CPU_STATS 1

#if !defined(CLI_ONLY_INFERENCE)
// Enable this for display
#define DISPLAY_SUPPORT 1
#endif

#ifdef __cplusplus
extern "C" {
#endif
extern void run_inference(void *ptr);
#ifdef __cplusplus
}
#endif
