int scale = 3;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
}

void loop() {
  // Get raw accelerometer data for each axis
  int rawX1 = analogRead(A3);
  int rawY1 = analogRead(A4);
  int rawZ1 = analogRead(A5);
  Serial.print(rawX1);
  Serial.println(" ");

//  float scaledX, scaledY, scaledZ; // Scaled values for each axis
//  scaledX = map(rawX, 0, 1023, -scale, scale);
//  Serial.print("X: "); Serial.print(scaledX); Serial.println(" g");
   // delay(10);

}
