rm -rfv work
mkdir work
cd work

# get
git clone --depth 1 --single-branch "https://github.com/espressif/tflite-micro-esp-examples"

# del
find ./ -name 'test' | xargs rm -rfv

# rename
#rename -v 's/\.cc/\.cpp/' *.cc
#rename -v 's/\.cc/\.cpp/' */*.cc
#rename -v 's/\.cc/\.cpp/' */*/*.cc
#rename -v 's/\.cc/\.cpp/' */*/*/*.cc
#rename -v 's/\.cc/\.cpp/' */*/*/*/*.cc
#rename -v 's/\.cc/\.cpp/' */*/*/*/*/*.cc
#rename -v 's/\.cc/\.cpp/' */*/*/*/*/*/*.cc
#rename -v 's/\.cc/\.cpp/' */*/*/*/*/*/*/*.cc
#rename -v 's/\.cc/\.cpp/' */*/*/*/*/*/*/*/*.cc
#rename -v 's/\.cc/\.cpp/' */*/*/*/*/*/*/*/*/*.cc
#rename -v 's/\.cc/\.cpp/' */*/*/*/*/*/*/*/*/*/*.cc
rename -v .cc .cpp *.cc
rename -v .cc .cpp */*.cc
rename -v .cc .cpp */*/*.cc
rename -v .cc .cpp */*/*/*.cc
rename -v .cc .cpp */*/*/*/*.cc
rename -v .cc .cpp */*/*/*/*/*.cc
rename -v .cc .cpp */*/*/*/*/*/*.cc
rename -v .cc .cpp */*/*/*/*/*/*/*.cc
rename -v .cc .cpp */*/*/*/*/*/*/*/*.cc
rename -v .cc .cpp */*/*/*/*/*/*/*/*/*.cc
rename -v .cc .cpp */*/*/*/*/*/*/*/*/*/*.cc

# flatbuffers
mv tflite-micro-esp-examples/components/tflite-lib/third_party/flatbuffers/include/flatbuffers/* tflite-micro-esp-examples/components/tflite-lib/third_party/flatbuffers
rm -rfv tflite-micro-esp-examples/components/tflite-lib/third_party/flatbuffers/include

# sed
echo "flatbuffers"
find ./ -name '*.h' -type f | xargs sed -i 's/\"flatbuffers/\"third_party\/flatbuffers/g'
find ./ -name '*.cpp' -type f | xargs sed -i 's/\"flatbuffers/\"third_party\/flatbuffers/g'

echo "utility"
find ./ -name '*.h' -type f | xargs sed -i 's/utility\.h/utility/g'

echo "kiss_fft"
find ./ -name '*.h' -type f | xargs sed -i 's/\"kiss_fft/\"third_party\/kissfft\/kiss_fft/g'
find ./ -name '*.cpp' -type f | xargs sed -i 's/\"kiss_fft/\"third_party\/kissfft\/kiss_fft/g'

find ./ -name '*.h' -type f | xargs sed -i 's/\"kiss_fft/\"third_party\/kissfft\/kiss_fft/g'
find ./ -name '*.cpp' -type f | xargs sed -i 's/\"kiss_fft/\"third_party\/kissfft\/kiss_fft/g'

find ./ -name '*.h' -type f | xargs sed -i 's/\"tools\/kiss_fftr\.h\"/\"third_party\/kissfft\/tools\/kiss_fftr\.h\"/g'
find ./ -name '*.cpp' -type f | xargs sed -i 's/\"tools\/kiss_fftr\.h\"/\"third_party\/kissfft\/tools\/kiss_fftr\.h\"/g'

find ./ -name '*.h' -type f | xargs sed -i 's/\"tools\/kiss_fftr\.c\"/\"third_party\/kissfft\/tools\/kiss_fftr\.c\"/g'
find ./ -name '*.cpp' -type f | xargs sed -i 's/\"tools\/kiss_fftr\.c\"/\"third_party\/kissfft\/tools\/kiss_fftr\.c\"/g'

find ./ -name '*.c' -type f | xargs sed -i 's/\"_kiss_fft_guts\.h\"/\"third_party\/kissfft\/_kiss_fft_guts\.h\"/g'

echo "fixedpoint"
find ./ -name '*.h' -type f | xargs sed -i 's/\"fixedpoint/\"third_party\/gemmlowp\/fixedpoint/g'
find ./ -name '*.cpp' -type f | xargs sed -i 's/\"fixedpoint/\"third_party\/gemmlowp\/fixedpoint/g'

echo "ruy"
find ./ -name '*.h' -type f | xargs sed -i 's/\"ruy/\"third_party\/ruy\/ruy/g'

echo "screen_driver"
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

# ESP-NN https://github.com/espressif/esp-nn
rm -rfv tflite-micro-esp-examples/components/tflite-lib/tensorflow/lite/micro/kernels/esp_nn/*.cpp

# bus
sed -i -e "1i #define CONFIG_I2C_BUS_DYNAMIC_CONFIG y" tflite-micro-esp-examples/components/bus/i2c_bus.c
sed -i -e "2i #define CONFIG_I2C_MS_TO_WAIT 200" tflite-micro-esp-examples/components/bus/i2c_bus.c

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

# examples/hello_world
mv tflite-micro-esp-examples/examples/hello_world/main/* tflite-micro-esp-examples/examples/hello_world
rm -rfv tflite-micro-esp-examples/examples/hello_world/main
rm -rfv tflite-micro-esp-examples/examples/hello_world/main.cpp
rm -rfv tflite-micro-esp-examples/examples/hello_world/*.txt
rm -rfv tflite-micro-esp-examples/examples/hello_world/sdkconfig.defaults
mv tflite-micro-esp-examples/examples/hello_world/main_functions.cpp tflite-micro-esp-examples/examples/hello_world/hello_world.ino
echo "" >tflite-micro-esp-examples/examples/hello_world/main_functions.h
sed -i -e "1i #include <TensorFlowLite_ESP32.h>" tflite-micro-esp-examples/examples/hello_world/hello_world.ino

# examples/micro_speech
mv tflite-micro-esp-examples/examples/micro_speech/main/* tflite-micro-esp-examples/examples/micro_speech
rm -rfv tflite-micro-esp-examples/examples/micro_speech/main
rm -rfv tflite-micro-esp-examples/examples/micro_speech/main.cpp
rm -rfv tflite-micro-esp-examples/examples/micro_speech/*.txt
rm -rfv tflite-micro-esp-examples/examples/micro_speech/sdkconfig.defaults
mv tflite-micro-esp-examples/examples/micro_speech/main_functions.cpp tflite-micro-esp-examples/examples/micro_speech/micro_speech.ino
echo "" >tflite-micro-esp-examples/examples/micro_speech/main_functions.h
sed -i -e "1i #include <TensorFlowLite_ESP32.h>" tflite-micro-esp-examples/examples/micro_speech/micro_speech.ino

# examples/person_detection
mv tflite-micro-esp-examples/examples/person_detection/main/* tflite-micro-esp-examples/examples/person_detection
rm -rfv tflite-micro-esp-examples/examples/person_detection/main
rm -rfv tflite-micro-esp-examples/examples/person_detection/main.cpp
rm -rfv tflite-micro-esp-examples/examples/person_detection/*.txt
rm -rfv tflite-micro-esp-examples/examples/person_detection/sdkconfig.defaults
rm -rfv tflite-micro-esp-examples/examples/person_detection/sdkconfig.defaults.*
rm -rfv tflite-micro-esp-examples/examples/person_detection/Kconfig.projbuild
rm -rfv tflite-micro-esp-examples/examples/person_detection/*.csv
mv tflite-micro-esp-examples/examples/person_detection/main_functions.cpp tflite-micro-esp-examples/examples/person_detection/person_detection.ino
echo "" >tflite-micro-esp-examples/examples/person_detection/main_functions.h
sed -i -e "1i #include <TensorFlowLite_ESP32.h>" tflite-micro-esp-examples/examples/person_detection/person_detection.ino

sed -i -e "15i // choice CAMERA_MODULE" tflite-micro-esp-examples/examples/person_detection/esp_main.h
sed -i -e "16i #define CONFIG_CAMERA_MODULE_WROVER_KIT true" tflite-micro-esp-examples/examples/person_detection/esp_main.h
sed -i -e "17i //#define CONFIG_CAMERA_MODULE_ESP_EYE true" tflite-micro-esp-examples/examples/person_detection/esp_main.h
sed -i -e "18i //#define CONFIG_CAMERA_MODULE_ESP_S2_KALUGA true" tflite-micro-esp-examples/examples/person_detection/esp_main.h
sed -i -e "19i //#define CONFIG_CAMERA_MODULE_ESP_S3_EYE true" tflite-micro-esp-examples/examples/person_detection/esp_main.h
sed -i -e "20i //#define CONFIG_CAMERA_MODULE_ESP32_CAM_BOARD true" tflite-micro-esp-examples/examples/person_detection/esp_main.h
sed -i -e "21i //#define CONFIG_CAMERA_MODULE_M5STACK_PSRAM true" tflite-micro-esp-examples/examples/person_detection/esp_main.h
sed -i -e "22i //#define CONFIG_CAMERA_MODULE_M5STACK_WIDE true" tflite-micro-esp-examples/examples/person_detection/esp_main.h
sed -i -e "23i //#define CONFIG_CAMERA_MODULE_AI_THINKER true" tflite-micro-esp-examples/examples/person_detection/esp_main.h
sed -i -e "24i //#define CONFIG_CAMERA_MODULE_CUSTOM true" tflite-micro-esp-examples/examples/person_detection/esp_main.h
sed -i -e '25i \\' tflite-micro-esp-examples/examples/person_detection/esp_main.h

# src
rm -rfv ../../src/tensorflow
rm -rfv ../../src/third_party
rm -rfv ../../src/screen
rm -rfv ../../src/bus
cp -r tflite-micro-esp-examples/components/tflite-lib/tensorflow ../../src/
cp -r tflite-micro-esp-examples/components/tflite-lib/third_party ../../src/
cp -r tflite-micro-esp-examples/components/screen ../../src/
cp -r tflite-micro-esp-examples/components/bus ../../src/

# examples
rm -rfv ../../examples/hello_world
rm -rfv ../../examples/micro_speech
rm -rfv ../../examples/person_detection
cp -r tflite-micro-esp-examples/examples/hello_world ../../examples/
cp -r tflite-micro-esp-examples/examples/micro_speech ../../examples/
cp -r tflite-micro-esp-examples/examples/person_detection ../../examples/

cd ..
rm -rfv work
