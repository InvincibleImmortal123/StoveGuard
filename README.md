# StoveGuard 🍳

StoveGuard is an IoT-based non-invasive smart monitoring system designed to track the real-time operational status of an electric stove using non-contact electromagnetic induction sensors and a mobile application.

---

## 📌 Project Overview

It is common to leave home and worry whether the stove was left on. StoveGuard solves this problem by safely detecting whether an electric stove is running and displaying its real-time state (ON or OFF) on a smartphone app—without modifying any existing electrical wiring or risking camera degradation from heat, oil, or smoke.

---

## ⚙️ How It Works

1. **Current Sensing**: A non-contact clamp current transformer detects the AC current drawn by the stove via electromagnetic induction.
2. **Signal Conditioning**: A voltage divider scales down the sensor's 0–5V DC analog output to 0–3.3V DC to match the ADC input limits of the ESP32 microcontroller.
3. **Data Transmission**: The ESP32 reads the scaled voltage, applies a conversion formula, and uploads the real-time status payload over Wi-Fi to a Google Firebase Realtime Database.
4. **Mobile Monitoring**: A cross-platform Flutter application fetches data from Firebase and presents an immediate ON / OFF status indicator to the user.

---

## 🛠️ Hardware & Components

* **Microcontroller**: ESP32
* **Current Sensor**: QNCTK3-16 non-contact clamp sensor (0–5V DC output, rated for up to 40A / 9.6 kW @ 240V)
* **Voltage Divider**: 15 kΩ and 10 kΩ resistor network (reduces 5V -> ~3.3V)
* **Target Appliance**: Standard 240V split-phase electric range (tested on Whirlpool 9.6 kW)

---

## 🧪 Hardware Testing & Calibration

| Stove Usage | Sensor Output Voltage |
| :--- | :--- |
| **OFF** | ~0 V |
| **1 Burner** | 0.81 V |
| **2 Burners** | 1.74 V |
| **3 Burners** | 3.37 V |
| **Multiple Burners + Oven** | 4.80 V |

---

## 📂 Project Structure

```text
StoveGuard/
├── firmware/              # ESP32 C++ firmware code
│   └── src/
│       └── main.cpp       # ADC read, conversion formula, and Firebase connection
├── mobile_app/            # Flutter cross-platform mobile application
│   ├── lib/
│   │   └── main.dart      # Real-time state UI & Firebase integration
│   └── pubspec.yaml
├── circuit/               # Schematics and voltage divider design specs
├── .gitignore
└── README.md
