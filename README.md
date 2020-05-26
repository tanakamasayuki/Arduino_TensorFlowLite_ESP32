# TensorFlowLite_ESP32

https://www.tensorflow.org/lite/microcontrollers/overview

## Overview

This library runs TensorFlow machine learning models on microcontrollers, allowing you to build AI/ML applications powered by deep learning and neural networks. 

With the included examples, you can recognize speech, detect people using a camera, and recognise "magic wand" gestures using an accelerometer.

The examples work best with the M5StickC(ESP32) board, which has a microphone and accelerometer.

## Examples

### hello_world

Outputs sine waves to serial outputs and build-in LEDs.

### magic_wand

This is gesture recognition using acceleration.
The accelerometer_handler and output_handler must be modified according to the environment in which they are used.

### magic_wand_M5StickC
This is gesture recognition using acceleration.
This is a sample that acquires acceleration from the IMU(MPU6886) of M5StickC.

## How to make this library
```
wget https://github.com/tensorflow/tensorflow/archive/v2.1.1.tar.gz
tar zxvf v2.1.1.tar.gz
cd tensorflow-2.1.1
make -f tensorflow/lite/experimental/micro/tools/make/Makefile TARGET=esp generate_micro_speech_esp_project
```

This is the base file.

- Renamed *.cc to *.cpp
- Edit the include path
- And, Minor corrections

## special thanks

- https://www.tensorflow.org/lite/microcontrollers/overview
- Arduino_TensorFlowLite libraries
- https://github.com/boochow/TFLite_Micro_MagicWand_M5Stack
