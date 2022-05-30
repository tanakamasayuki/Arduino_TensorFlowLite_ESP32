# TensorFlowLite_ESP32

https://www.tensorflow.org/lite/microcontrollers/overview

https://github.com/espressif/tflite-micro-esp-examples

## Overview

This library runs TensorFlow machine learning models on microcontrollers, allowing you to build AI/ML applications powered by deep learning and neural networks. 

With the included examples, you can recognize speech, detect people using a camera, and recognise "magic wand" gestures using an accelerometer.

The examples work best with the M5StickC(ESP32) board, which has a microphone and accelerometer.

## Examples

### hello_world

Outputs sine waves to serial outputs and build-in LEDs.

### micro_speech

This is a sample of speech recognition.
The audio_provider and command_responder must be modified according to the environment in which they are used.

### person_detection

It is a person detection using a camera.
The image_provider and detection_responder must be modified according to the environment in which they are used.

## OldExamples

This is a sample for older versions. It will not work as it is.

### magic_wand

This is gesture recognition using acceleration.
The accelerometer_handler and output_handler must be modified according to the environment in which they are used.

### magic_wand_*

A sketch customized to look like a specific board.

- M5StickC
- M5StackFire

### micro_speech_*

A sketch customized to look like a specific board.

- ESP-EYE
- M5StickC
- M5StackFire
- ATOM Echo

### person_detection_ESP32-Camera

It is a person detection using a camera.
This is a sample of using the ESP32 camera driver. Please configure the device you want to use in config.h.

#### Output sample
```
================================================
==========================+=====================
==================++-+++++++++=**--++++++++++++=
===++++++++++++++++HH#-------=HH*-++++++++++++++
+++++++++++++++---+HHH------+HH#-----#H+++++++++
++++++++++++++-----HHH+---- HHHH----HHH-++++++++
++++++++++++-------HHHH----HHH* ---HHH*-++++++++
++++++++++---------HHHH ---***=---=*HH---+++++++
++++++++++---------H***=  +***---H*H* ----++++++
++++++++++--------- ****=-***H  ***H+------+++++
++++++HHHH*+------- *************** -----#H#-+++
+++++++ ###HH------**H**********H* --+HHHHHH*+=+
+++++++++M##HH----+H*HHHHHHHHHHHHHHH#H#HHHHH*+=+
+++++++++++#HHHHH=HHHHHHH#H#HHHHHHHH#H####H##+=+
+++++++++++ HHHHHHHHHHHH####H##HH#HH=+++++++++=+
++++++++*=+++#####################HH**********=+
=++++++##M*++ ######H#############H-++++++++++++
===++++#H*=M=++M#################H+++++++++++===
======+++==M++++*###############H +++++++++++===
======H*MHMH=+++++##############++++++++++++====
==============+++=*###########H++++====*++==+==H
==================###########H++++-+============
*================+##########H###H=*+======*==+=*
H**==============###########*===-HH+===+======**
Person score:89 No person score:226
```

```
=======================+++======================
====================+=+++++++++=================
=================++++++++==++-----++++++++++++++
=+++++++++++++++------*H*H#H#H=+----++++++++++++
++++++++++++++------*H#HH##HHH*H-------+++++++++
+++++++++++-------- ##HHHHHHH*H##-------++++++++
++++++++++---------H#*H#HHHH#H*#H --------++++++
+++++++++---------- #*HHH***H**+H ---------+++++
+++++++++---------- H=***==***=++----------+++++
+++++++++-----------==*******==*-------------+++
+++++++++----------- -*HH**H*==       --------++
+++++++++------------H********     --HHHHHHH*+=+
+++++++++------+=+++=*HHHHH**+#H*H=--#HHHHHHH+=+
++++++++++=+========H##HH##HHH#H***--M#HHHH##+=+
++++++++=*H#**======*HH#HHHH###H*H*H**++++++++=+
+++++++=HHHHH**=====*HH#HHH*#HHH*HHHHHH******==+
++++++HHHHH##******=*HHH#H*HHHHHHH#*###H++++++++
=++++HHH####*#H*******H##H#HHHHHH##MH##HH+++++==
===+HH#H##MMH**HH****HH#H#H##H##HHH*#H#H#H++++==
==*HH#####MM#HHH*HHH####HHHH#####HHHH##*##=++===
=HHH######MM##H#HH###MH*HH##H#####HHM##H##H=+==H
==+M####MMM########M=H###HH#######H#MMH#####====
====###MMM########H########MH##H###MMM######H+=*
===##H#MMM#####H###M#HHHHHHH####HH#MMMMM####H-**
Person score:251 No person score:42
```


### person_detection_*

A sketch customized to look like a specific board.

- M5CameraModelB
- T-CameraV05

## How to make this library
```
cd scripts
bash ./sync_from_tflite_micro.sh
```

## special thanks

- https://www.tensorflow.org/lite/microcontrollers/overview
- Arduino_TensorFlowLite librarie
- https://github.com/adafruit/Adafruit_TFLite
- https://github.com/boochow/TFLite_Micro_MagicWand_M5Stack
- https://github.com/boochow/TFLite_Micro_MicroSpeech_M5Stack/tree/m5stickc
