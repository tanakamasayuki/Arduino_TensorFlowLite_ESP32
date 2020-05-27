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

#include <M5StickC.h>

void InitResponder() {
  M5.begin();
  M5.Lcd.fillScreen(BLACK);
#if USE_AVATAR
  avatar.init();
  avatar.setExpression(Expression::Sleepy);
#else
  M5.Lcd.setRotation(3);
  M5.Lcd.setTextColor(YELLOW);
  M5.Lcd.setTextSize(2);
#endif
}

#if USE_AVATAR
void UpdateFace(const char* found_command) {
  Expression exp = Expression::Sleepy;

  if (strcmp(found_command, "yes") == 0) {
    exp = Expression::Happy;
    avatar.setSpeechText("Yes!");
  } else if (strcmp(found_command, "no") == 0) {
    exp = Expression::Sad;
    avatar.setSpeechText("No!");
  } else if (strcmp(found_command, "unknown") == 0) {
    exp = Expression::Doubt;
    avatar.setSpeechText("?");
  } else if (strcmp(found_command, "silence") == 0) {
    exp = Expression::Sleepy;
    avatar.setSpeechText("zzz...");
  } else if (strcmp(found_command, "") == 0) {
    exp = Expression::Neutral;
    avatar.setSpeechText("");
  }
  avatar.setExpression(exp);
}

#else

void DrawParallelogram(int sx, int sy, int ex, int ey, int t, int c) {
//      ___ex,ey
//     /  /
//    /  /
//   /__/sx+t,sy
// sx,sy
  M5.Lcd.fillTriangle(sx  , sy, sx+t, sy, ex-t, ey, c);
  M5.Lcd.fillTriangle(sx+t, sy, ex-t, ey, ex,   ey, c);
}

void DrawYes(int x, int y, int w, int h, int t, int c) {
  int cw = w / 3;
  int hh = h / 2;
  int ex = x + w;
  int ey = y + h;
  // Y
  DrawParallelogram(x,          y,    x+(cw+t)/2, y+hh, t, c);
  DrawParallelogram(x+(cw-t)/2, y+hh, x+cw,       y,    t, c);
  M5.Lcd.fillRect(x+(cw-t)/2, y+hh, t, hh, c);
  // E
  x += cw;
  M5.Lcd.fillRect(x,   y,        t,        h, c);
  M5.Lcd.fillRect(x+t, y,        cw-t,     t, c);
  M5.Lcd.fillRect(x+t, y+hh-t/2, cw-t*1.5, t, c);
  M5.Lcd.fillRect(x+t, y+h-t,    cw-t,     t, c);
  // S
  x += cw;
  DrawParallelogram(x,      y+hh*0.75,  x+cw/2, y,         t, c);
  DrawParallelogram(ex-t,   ey-hh*0.75, x+t,    y+hh*0.75,  t, c);
  DrawParallelogram(x+cw/2, ey,         ex,     ey-hh*0.75, t, c);
  M5.Lcd.fillRect(x+cw/2, y, (cw-t)/2, t, c);
  M5.Lcd.fillRect(x+t, ey-t, cw/2,     t, c);
}

void DrawNo(int x, int y, int w, int h, int t, int c) {
  int cw = w * 0.9 / 2;
  int sp = w * 0.1;
  // N
  M5.Lcd.fillRect(x,      y, t, h, c);
  M5.Lcd.fillRect(x+cw-t, y, t, h, c);
  DrawParallelogram(x, y, x+cw, y+h, t, c);
  // O
  x += (cw + sp);
  M5.Lcd.fillEllipse(x+cw/2, y+h/2, cw/2, h/2, c);
  M5.Lcd.fillEllipse(x+cw/2, y+h/2, cw/2-t, h/2-t, BLACK);
}

void UpdateText(const char* found_command) {
  if (strcmp(found_command, "yes") == 0) {
    DrawYes(30, 0, 100, 80, 10, GREEN);
  } else if (strcmp(found_command, "no") == 0) {
    DrawNo(30, 0, 100, 80, 10, RED);
  } else if (strcmp(found_command, "unknown") == 0) {
    M5.Lcd.setCursor(30, 32);
    M5.Lcd.println("UNKNOWN");
  } else if (strcmp(found_command, "silence") == 0) {
    M5.Lcd.setCursor(0, 32);
    M5.Lcd.println("Heard nothing");
  } else if (strcmp(found_command, "") == 0) {
    M5.Lcd.fillScreen(BLACK);
  }
}

#endif

void RespondToCommand(tflite::ErrorReporter* error_reporter,
                      int32_t current_time, const char* found_command,
                      uint8_t score, bool is_new_command) {
  static int32_t last_timestamp = 0;

  if (is_new_command) { 
    error_reporter->Report("Heard %s (%d) @%dms", found_command, score,
                           current_time);
    last_timestamp = current_time;
#if USE_AVATAR
    UpdateFace(found_command);
#else
    M5.Lcd.fillScreen(BLACK);
    UpdateText(found_command);
#endif
  } else {
    if ((current_time - last_timestamp) > 2000) {
#if USE_AVATAR
      UpdateFace("");
#else
      UpdateText("");
#endif
    }
  }
}
