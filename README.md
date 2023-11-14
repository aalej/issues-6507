# Repro for tools issue 6507

Description: Realtime Database connection is lost when app is disconnected from WiFi and reconnected back again

### Versions

firebase-tools: v12.8.1<br>
firebase_core: ^2.22.0<br>
firebase_database: ^10.3.4<br>

### Steps to reproduce issue

1. Run `firebase emulators:start --import emulator-data`
1. Open an Android emulator or a real Android device
   - If running on an real Android device, in `main.dart` change `10.0.2.2` to your local IP
1. On a separate terminal run `flutter run -d <device_id>`
   - Run `flutter devices` to get a list of devices and device ids
1. Go to "http://localhost:4000/database/aalej-gh-tools-6507-default-rtdb/data"
1. Modify the value of `info/conncted` and/or `users/12345/name`
   - Value changes should reflect on the Android device
1. Disconnect internet
   - Turn WiFi off and Mobile data off on the Android device/emulator
   - (Optional) Try changing value on RTDB emulator. Changes should not reflect
1. Reconnect internet
   - Turn WiFi on and Mobile data on
1. Modify the value of `info/conncted` and/or `users/12345/name`
   - Value changes are no longer being reflected on Android device

### Notes

Issue is not reproducible when connecting to an actual Firebase project.
After reconnecting to the internet, the new data from RTDB will be read.
