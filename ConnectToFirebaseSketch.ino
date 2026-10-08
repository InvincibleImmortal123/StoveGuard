#include <WiFi.h>
#include <FirebaseESP32.h> // Matching your installed library name
#include <NTPClient.h>
#include <WiFiUdp.h>

// 1. WiFi Credentials
#define WIFI_SSID "smartman"
#define WIFI_PASSWORD "myteacher321"

// 2. Firebase Credentials
#define FIREBASE_HOST "stoveonofftest-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "ZEBu3vtsqcS1fZeNGXtYnL43zgWKAgxSlhFX4bBa" 

// Define Firebase objects
FirebaseData firebaseData;

const int analogPin = A7; // ESP32 Pin for voltage reading
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
void setup() {
  Serial.begin(115200);

  // Connect to WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println("\nConnected!");

  // Initialize Firebase
  config.host = FIREBASE_HOST;
config.signer.tokens.legacy_token = FIREBASE_AUTH;
Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  int rawValue = analogRead(analogPin);
  float voltage = rawValue * (3.3 / 4095.0)*5.0/3.0;

  String statusValue = (voltage >= 0.3) ? "1" : "0";

  FirebaseJson json;
  json.set("voltage", voltage);
  json.set("status", statusValue);
  json.set("timestamp/.sv", "timestamp");
  
  // Use a FIXED path name instead of a push or a counter.
  // This will overwrite the same key every 5 seconds.
  if (Firebase.setJSON(fbdo, "/VoltageRecord", json)) {
    Serial.println("Database Updated (Overwritten)");
    Serial.print("Current Voltage: "); Serial.println(voltage);
  } else {
    Serial.println("Error: " + fbdo.errorReason());
  }

  delay(3000); 
}