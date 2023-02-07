#!/usr/bin/env bash
set -e -x

rm -rf TensorFlowLite_ESP32_tmp
mkdir TensorFlowLite_ESP32_tmp
cd TensorFlowLite_ESP32_tmp

echo "\n\nclone https://github.com/espressif/tflite-micro-esp-examples"
git clone --depth 1 --single-branch "https://github.com/espressif/tflite-micro-esp-examples"


echo "\n\nremove tests"
find ./ -name 'test' | xargs rm -rfv

echo "\n\nrename cc to cpp"
find ./ -depth -name "*.cc" -exec sh -c 'mv "$1" "${1%.cc}.cpp"' _ {} \;


echo "\n\nmv and rm flatbuffers"
mv tflite-micro-esp-examples/components/tflite-lib/third_party/flatbuffers/include/flatbuffers/* tflite-micro-esp-examples/components/tflite-lib/third_party/flatbuffers
rm -rfv tflite-micro-esp-examples/components/tflite-lib/third_party/flatbuffers/include

echo "\n\nflatbuffers"
find ./ -name '*.h' -type f | xargs sed -i 's/\"flatbuffers/\"third_party\/flatbuffers/g'
find ./ -name '*.cpp' -type f | xargs sed -i 's/\"flatbuffers/\"third_party\/flatbuffers/g'

echo "\n\nutility"
find ./ -name '*.h' -type f | xargs sed -i 's/utility\.h/utility/g'


echo "\n\nkiss_fft"
find ./ -name '*.h' -type f | xargs sed -i 's/\"kiss_fft/\"third_party\/kissfft\/kiss_fft/g'
find ./ -name '*.cpp' -type f | xargs sed -i 's/\"kiss_fft/\"third_party\/kissfft\/kiss_fft/g'

find ./ -name '*.h' -type f | xargs sed -i 's/\"kiss_fft/\"third_party\/kissfft\/kiss_fft/g'
find ./ -name '*.cpp' -type f | xargs sed -i 's/\"kiss_fft/\"third_party\/kissfft\/kiss_fft/g'

find ./ -name '*.h' -type f | xargs sed -i 's/\"tools\/kiss_fftr\.h\"/\"third_party\/kissfft\/tools\/kiss_fftr\.h\"/g'
find ./ -name '*.cpp' -type f | xargs sed -i 's/\"tools\/kiss_fftr\.h\"/\"third_party\/kissfft\/tools\/kiss_fftr\.h\"/g'

find ./ -name '*.h' -type f | xargs sed -i 's/\"tools\/kiss_fftr\.c\"/\"third_party\/kissfft\/tools\/kiss_fftr\.c\"/g'
find ./ -name '*.cpp' -type f | xargs sed -i 's/\"tools\/kiss_fftr\.c\"/\"third_party\/kissfft\/tools\/kiss_fftr\.c\"/g'

find ./ -name '*.c' -type f | xargs sed -i 's/\"_kiss_fft_guts\.h\"/\"third_party\/kissfft\/_kiss_fft_guts\.h\"/g'


echo "\n\nfixedpoint"
find ./ -name '*.h' -type f | xargs sed -i 's/\"fixedpoint/\"third_party\/gemmlowp\/fixedpoint/g'
find ./ -name '*.cpp' -type f | xargs sed -i 's/\"fixedpoint/\"third_party\/gemmlowp\/fixedpoint/g'

echo "\n\nruy"
find ./ -name '*.h' -type f | xargs sed -i 's/\"ruy/\"third_party\/ruy\/ruy/g'

echo "\n\nscreen_driver"
find ./ -name '*.h' -type f | xargs sed -i 's/screen_driver\.h/screen\/screen_driver\.h/g'
find ./ -name '*.c' -type f | xargs sed -i 's/screen_driver\.h/screen\/screen_driver\.h/g'

find ./ -name '*.h' -type f | xargs sed -i 's/scr_interface_driver\.h/screen\/interface_driver\/scr_interface_driver\.h/g'
find ./ -name '*.c' -type f | xargs sed -i 's/scr_interface_driver\.h/screen\/interface_driver\/scr_interface_driver\.h/g'

find ./ -name '*.h' -type f | xargs sed -i 's/i2s_lcd_driver\.h/bus\/include\/i2s_lcd_driver\.h/g'
find ./ -name '*.c' -type f | xargs sed -i 's/i2s_lcd_driver\.h/bus\/include\/i2s_lcd_driver\.h/g'

find ./ -name '*.h' -type f | xargs sed -i 's/i2c_bus\.h/bus\/include\/i2c_bus\.h/g'
find ./ -name '*.c' -type f | xargs sed -i 's/i2c_bus\.h/bus\/include\/i2c_bus\.h/g'

find ./ -name '*.h' -type f | xargs sed -i 's/spi_bus\.h/bus\/include\/spi_bus\.h/g'
find ./ -name '*.c' -type f | xargs sed -i 's/spi_bus\.h/bus\/include\/spi_bus\.h/g'

find ./ -name '*.c' -type f | xargs sed -i 's/screen_utility\.h/screen\/screen_utility\/screen_utility\.h/g'
find ./ -name '*.c' -type f | xargs sed -i 's/interface_drv_def\.h/screen\/screen_utility\/screen_utility\.h/g'

echo "\n\nesp-nn"
# Remove all esp-nn cpp files in order to avoid the Error: "no matching function for call to 'MaxPoolingEvalQuantized(TfLiteContext*&, TfLiteNode*&, TfLitePoolParams*&, const tflite::OpDataPooling*&, const TfLiteEvalTensor*&, TfLiteEvalTensor*&)'",
rm -rfv tflite-micro-esp-examples/components/tflite-lib/tensorflow/lite/micro/kernels/esp_nn/*.cpp


echo "\n\nbus"
sed -i -e "1i #define CONFIG_I2C_BUS_DYNAMIC_CONFIG y" tflite-micro-esp-examples/components/bus/i2c_bus.c
sed -i -e "2i #define CONFIG_I2C_MS_TO_WAIT 200" tflite-micro-esp-examples/components/bus/i2c_bus.c

echo "\n\nscreen"
sed -i -e "1i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_ILI9341 y" tflite-micro-esp-examples/components/screen/screen_driver.c
sed -i -e "2i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_ILI9486 y" tflite-micro-esp-examples/components/screen/screen_driver.c
sed -i -e "3i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_ILI9488 y" tflite-micro-esp-examples/components/screen/screen_driver.c
sed -i -e "4i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_ILI9806 y" tflite-micro-esp-examples/components/screen/screen_driver.c
sed -i -e "5i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_NT35510 y" tflite-micro-esp-examples/components/screen/screen_driver.c
sed -i -e "6i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_RM68120 y" tflite-micro-esp-examples/components/screen/screen_driver.c
sed -i -e "7i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_SSD1306 y" tflite-micro-esp-examples/components/screen/screen_driver.c
sed -i -e "8i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_SSD1307 y" tflite-micro-esp-examples/components/screen/screen_driver.c
sed -i -e "9i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_SSD1322 y" tflite-micro-esp-examples/components/screen/screen_driver.c
sed -i -e "10i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_SSD1351 y" tflite-micro-esp-examples/components/screen/screen_driver.c
sed -i -e "11i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_SSD1963 y" tflite-micro-esp-examples/components/screen/screen_driver.c
sed -i -e "12i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_ST7789 y" tflite-micro-esp-examples/components/screen/screen_driver.c
sed -i -e "13i #define CONFIG_LCD_DRIVER_SCREEN_CONTROLLER_ST7796 y" tflite-micro-esp-examples/components/screen/screen_driver.c

echo "\n\nsrc"
mkdir src
cp -r tflite-micro-esp-examples/components/tflite-lib/tensorflow src/
cp -r tflite-micro-esp-examples/components/tflite-lib/third_party src/
cp -r tflite-micro-esp-examples/components/screen src/
cp -r tflite-micro-esp-examples/components/bus src/

echo "/* Copyright 2019 The TensorFlow Authors. All Rights Reserved.
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

#include <utility>" > src/utility.h

echo "/* Copyright 2019 The TensorFlow Authors. All Rights Reserved.
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
" > src/TensorFlowLite_ESP32.h


echo "adapt and copy examples/hello_world"
mv tflite-micro-esp-examples/examples/hello_world/main/* tflite-micro-esp-examples/examples/hello_world
rm -rfv tflite-micro-esp-examples/examples/hello_world/main
rm -rfv tflite-micro-esp-examples/examples/hello_world/main.cpp
rm -rfv tflite-micro-esp-examples/examples/hello_world/*.txt
rm -rfv tflite-micro-esp-examples/examples/hello_world/sdkconfig.defaults
mv tflite-micro-esp-examples/examples/hello_world/main_functions.cpp tflite-micro-esp-examples/examples/hello_world/hello_world.ino
echo "" > tflite-micro-esp-examples/examples/hello_world/main_functions.h
sed -i -e "1i #include <TensorFlowLite_ESP32.h>" tflite-micro-esp-examples/examples/hello_world/hello_world.ino

mkdir examples
cp -r tflite-micro-esp-examples/examples/hello_world examples/
cp tflite-micro-esp-examples/LICENSE .
rm -rfv tflite-micro-esp-examples

echo "Finish!"



