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

#include "command_responder.h"

#include <M5Stack.h>

void InitResponder() {
  M5.begin();
  M5.Lcd.fillScreen(BLACK);
  M5.Lcd.setTextSize(2);
  M5.Lcd.setCursor(0, 0);
  M5.Lcd.setTextColor(YELLOW);
  M5.Lcd.printf("Micro Speech\n");
  M5.Lcd.setTextColor(WHITE, BLACK);
}

namespace {
enum {
  COMMAND_SILENCE,
  COMMAND_UNKNOWN,
  COMMAND_YES,
  COMMAND_NO,

  COMMAND_MAX
};
uint8_t scoreList[COMMAND_MAX];
uint8_t lastCommand;
int8_t lastCommandTime;
}

void RespondToCommand(tflite::ErrorReporter* error_reporter,
                      int32_t current_time, const char* found_command,
                      uint8_t score, bool is_new_command) {
  static int32_t last_timestamp = 0;

  // Score List Update
  uint8_t command = COMMAND_SILENCE;
  memset(scoreList, 0, sizeof(scoreList));
  if (strcmp(found_command, "silence") == 0) {
    command = COMMAND_SILENCE;
  } else   if (strcmp(found_command, "unknown") == 0) {
    command = COMMAND_UNKNOWN;
  } else   if (strcmp(found_command, "yes") == 0) {
    command = COMMAND_YES;
  } else   if (strcmp(found_command, "no") == 0) {
    command = COMMAND_NO;
  }
  scoreList[command] = score;

  // New Command
  if (is_new_command) {
    lastCommand = command;
    lastCommandTime = 3;
  }

  Serial.printf("current_time(%d) found_command(%s) score(%d) is_new_command(%d)\n", current_time, found_command, score, is_new_command);
  M5.Lcd.setCursor(0, 16);

  if (lastCommand == COMMAND_SILENCE && 0 < lastCommandTime) {
    M5.Lcd.setTextColor(RED, BLACK);
  } else {
    M5.Lcd.setTextColor(WHITE, BLACK);
  }
  M5.Lcd.printf("Silence : %3d\n", scoreList[COMMAND_SILENCE]);

  if (lastCommand == COMMAND_UNKNOWN && 0 < lastCommandTime) {
    M5.Lcd.setTextColor(RED, BLACK);
  } else {
    M5.Lcd.setTextColor(WHITE, BLACK);
  }
  M5.Lcd.printf("Unknown : %3d\n", scoreList[COMMAND_UNKNOWN]);

  if (lastCommand == COMMAND_YES && 0 < lastCommandTime) {
    M5.Lcd.setTextColor(RED, BLACK);
  } else {
    M5.Lcd.setTextColor(WHITE, BLACK);
  }
  M5.Lcd.printf("Yes     : %3d\n", scoreList[COMMAND_YES]);

  if (lastCommand == COMMAND_NO && 0 < lastCommandTime) {
    M5.Lcd.setTextColor(RED, BLACK);
  } else {
    M5.Lcd.setTextColor(WHITE, BLACK);
  }
  M5.Lcd.printf("No      : %3d\n", scoreList[COMMAND_NO]);
  if (0 < lastCommandTime) {
    lastCommandTime--;
  }
}

void drawWave(int16_t value) {
  static int drawX = 320;

  static int min = -1000;
  static int max = 1000;

  if (value < min) {
    value = min;
  }
  if (max < value) {
    value = max;
  }

  int drawY = map(value, min, max, 84, 240);

  M5.Lcd.drawPixel(drawX, drawY, WHITE);
  drawX++;
  if (320 <= drawX) {
    drawX = 0;
    M5.Lcd.fillRect(0, 84, 320, 240-84, BLUE);
  }
}

void drawInput(uint8_t *uint8) {
  for (int y = 0; y < 49; y++) {
    for (int x = 0; x < 40; x++) {
      int pos = y * 40 + x;
      int drawX = 160 + y * 3;
      int drawY = 80 - x * 2;
      int color = (uint8[pos]>>2) << 5;
      M5.Lcd.fillRect(drawX, drawY, 3, 2, color);
    }
  }
}
