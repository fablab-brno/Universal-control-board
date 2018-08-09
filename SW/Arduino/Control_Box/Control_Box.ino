// Control Box
// Coded by Luboš Moravec 
/*

  ----------------
  | 16 |  2 |  3 |
  ----L3---L1---
  | 15 | 4  |  5 |
  ----L2---L0-----
  | 14 | 11 | 12 |
*/

#include <Adafruit_NeoPixel.h>

const int button[9] = {16, 2, 3, 15, 4, 5, 14, 11, 12};
bool buttonState[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
bool lastButtonState[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};

#define neopixelPin 6 // Digital IO pin connected to the NeoPixels.
#define pixelNumber 4 // number of Neopixels

unsigned long lastDebounceTime[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
unsigned long debounceDelay = 50;
unsigned long printDelay = 0;

// RGB
int screen = 0;
bool moveUp = 1;
int brightness = 0;

// Parameter 1 = number of pixels in strip,  neopixel stick has 8
// Parameter 2 = pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_RGB     Pixels are wired for RGB bitstream
//   NEO_GRB     Pixels are wired for GRB bitstream, correct for neopixel stick
//   NEO_KHZ400  400 KHz bitstream (e.g. FLORA pixels)
//   NEO_KHZ800  800 KHz bitstream (e.g. High Density LED strip), correct for neopixel stick
Adafruit_NeoPixel neopixels = Adafruit_NeoPixel(pixelNumber, neopixelPin, NEO_GRB + NEO_KHZ800);

void setup() {
  // start communication with Serial monitor
  Serial.begin (115200);
  // start communication with LEDs
  neopixels.begin();
  // initialize all pixels to 'off'
  neopixels.show();
  // initialize the pushbutton pin as an input:
  for (int i = 0; i < 9; i++) {
    pinMode(button[i], INPUT);
  }
  //establishContact();  // send a byte to establish contact until Processing responds
}

void loop() {
  if ((buttonState[0] == 0) && (buttonState[1] == 0) && (buttonState[2] == 0) && (buttonState[3] == 0) &&
  (buttonState[5] == 0) && (buttonState[6] == 0) && (buttonState[7] == 0) && (buttonState[8] == 0)){
    // breathing LEDs
    if (millis() - printDelay > 5) {
      if (brightness == 0) {
        moveUp = 1;
      }
      if (brightness == 200) {
        moveUp = 0;
      }
      if (moveUp == 1) {
        brightness += 1;
      }
      else {
        brightness -= 1;
      }
      colorWipe(colorGet(1), 1);
      printDelay = millis();
    }
  }
  // detect buttons
  for (int j = 0; j < 9; j++) {
    buttonDetect(j);
  }
  delay(1);
}

bool buttonDetect(int num) {
  // read the state of the switch into a local variable:
  bool readB = digitalRead(button[num]);
  // If the switch changed, due to noise or pressing:
  if (readB != lastButtonState[num]) {
    // reset the debouncing timer
    lastDebounceTime[num] = millis();
  }
  if ((millis() - lastDebounceTime[num]) > debounceDelay) {
    // middle button
    if (num == 4) {
      if (readB != buttonState[num]) {
        buttonState[num] = readB;
        if (buttonState[num] == HIGH) {
          screen += 1;
          if (screen > 4) screen = 0;
          Serial.write(screen);
          Serial.write(num);
          Serial.write(1);
        }
      }
    }
    // other buttons
    else {
      // if the button state has changed:
      if (readB != buttonState[num]) {
        Serial.write(screen);
        Serial.write(num);
        buttonState[num] = readB;
        if (buttonState[num] == HIGH) {
          Serial.write(1);
        }
        else {
          Serial.write(0);
        }
      }
      if (buttonState[0] == 1) {
        neopixels.setPixelColor(0, 0);
        neopixels.setPixelColor(1, 0);
        neopixels.setPixelColor(2, 0);
        neopixels.setPixelColor(3, colorGet(0));
        neopixels.show();
      }
      if (buttonState[1] == 1) {
        neopixels.setPixelColor(0, 0);
        neopixels.setPixelColor(1, colorGet(0));
        neopixels.setPixelColor(2, 0);
        neopixels.setPixelColor(3, colorGet(0));
        neopixels.show();
      }
      if (buttonState[2] == 1) {
        neopixels.setPixelColor(0, 0);
        neopixels.setPixelColor(1, colorGet(0));
        neopixels.setPixelColor(2, 0);
        neopixels.setPixelColor(3, 0);
        neopixels.show();
      }
      if (buttonState[3] == 1) {
        neopixels.setPixelColor(0, 0);
        neopixels.setPixelColor(1, 0);
        neopixels.setPixelColor(2, colorGet(0));
        neopixels.setPixelColor(3, colorGet(0));
        neopixels.show();
      }
      if (buttonState[5] == 1) {
        neopixels.setPixelColor(0, colorGet(0));
        neopixels.setPixelColor(1, colorGet(0));
        neopixels.setPixelColor(2, 0);
        neopixels.setPixelColor(3, 0);
        neopixels.show();
      }
      if (buttonState[6] == 1) {
        neopixels.setPixelColor(0, 0);
        neopixels.setPixelColor(1, 0);
        neopixels.setPixelColor(2, colorGet(0));
        neopixels.setPixelColor(3, 0);
        neopixels.show();
      }
      if (buttonState[7] == 1) {
        neopixels.setPixelColor(0, colorGet(0));
        neopixels.setPixelColor(1, 0);
        neopixels.setPixelColor(2, colorGet(0));
        neopixels.setPixelColor(3, 0);
        neopixels.show();
      }
      if (buttonState[8] == 1) {
        neopixels.setPixelColor(0, colorGet(0));
        neopixels.setPixelColor(1, 0);
        neopixels.setPixelColor(2, 0);
        neopixels.setPixelColor(3, 0);
        neopixels.show();
      }
    }
  }
  // save the reading. Next time through the loop, it'll be the lastButtonState:
  lastButtonState[num] = readB;
  delay(1);
}
// Fill the dots one after the other with a color
void colorWipe(uint32_t c, uint8_t wait) {
  for (uint16_t i = 0; i < neopixels.numPixels(); i++) {
    neopixels.setPixelColor(i, c);
    neopixels.show();
    delay(wait);
  }
}

uint32_t colorGet(bool bright) {
  uint32_t ledColor;
  if (bright == 1) {
    switch (screen) {
      case 0: ledColor = neopixels.Color(brightness / 4, brightness / 4, brightness / 4); // Black/off
        break;
      case 1: ledColor = neopixels.Color(brightness, 0, 0);  // Red
        break;
      case 2: ledColor = neopixels.Color(0, brightness, 0);  // Green
        break;
      case 3: ledColor = neopixels.Color(0, 0, brightness);  // Blue
        break;
      case 4: ledColor = neopixels.Color(brightness, brightness, brightness); // White
        break;
    }
  }
  else {
    switch (screen) {
      case 0: ledColor = neopixels.Color(225 / 4, 225 / 4, 225 / 4); // Black/off
        break;
      case 1: ledColor = neopixels.Color(225, 0, 0);  // Red
        break;
      case 2: ledColor = neopixels.Color(0, 225, 0);  // Green
        break;
      case 3: ledColor = neopixels.Color(0, 0, 225);  // Blue
        break;
      case 4: ledColor = neopixels.Color(225, 225, 225); // White
        break;
    }
  }
  return ledColor;
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.write('A');   // send a capital A
    delay(300);
  }
}
