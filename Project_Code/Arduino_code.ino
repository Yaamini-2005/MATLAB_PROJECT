const int sensorPin = A0; // Pin connected to the sensor
void setup() {
  Serial.begin(9600);
}
void loop() {
  int sensorValue = analogRead(sensorPin);
  float temperature = (sensorValue * 5.0 / 1023.0) * 100; // For LM35
  Serial.println(temperature);
  delay(1000); // Delay in milliseconds
}
