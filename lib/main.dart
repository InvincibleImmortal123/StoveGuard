import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);// Connects Flutter to Firebase which is database being used currently
  runApp(const MaterialApp(home: VoltageScreen()));
}

class VoltageScreen extends StatefulWidget {
  const VoltageScreen({super.key});
  @override
  State<VoltageScreen> createState() => _VoltageScreenState();
}

class _VoltageScreenState extends State<VoltageScreen> {
  String displayVoltage = "Tap to fetch";
  String displayStatus = "N/A";
  String displayTime="Tap to fetch";

  // Function to read your specific JSON path
  void getVoltage() async {//Gets voltage from database then displays data based on the voltage
    DatabaseReference ref = FirebaseDatabase.instance.ref("VoltageRecord/voltage");
    final snapshot = await ref.get();
    DatabaseReference refonoff = FirebaseDatabase.instance.ref("VoltageRecord/status");
    final onoff = await refonoff.get();
    DatabaseReference refTime = FirebaseDatabase.instance.ref("VoltageRecord/timestamp");
    final Time = await refTime.get();

    if (snapshot.exists) {
      setState(() {
        displayVoltage = "${snapshot.value} V";
        displayStatus = "${onoff.value}";
        displayTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(int.parse("${Time.value}")));
        print("Time:${Time.value}");
        if(displayStatus=="1"){
          displayStatus="ON";
        }
        else{
          displayStatus="OFF";
        }
      });
    } else {
      setState(() {
        displayVoltage = "No data found";
        displayStatus = "No data found";
        displayTime = "No data found";
      });
    }
  }

  @override
  Widget build(BuildContext context) {//Specific interface of the app
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Soft gray background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              // 1. Top Title Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: const Center(
                  child: Text("StoveGuard",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                ),
              ),

              const SizedBox(height: 30),

              // 2. Circular Info Cards Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleInfo("Last Updated:", displayTime, Icons.access_time),
                  _buildCircleInfo("Current Voltage:", displayVoltage, Icons.bolt, isVoltage: true),
                ],
              ),

              const SizedBox(height: 35),

              // 3. Status Display (Gradient Box)
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient:  LinearGradient(
                    colors: displayStatus == "ON"
                        ? [const Color(0xFFFFA751), const Color(0xFFFF512F)] // Keep Orange/Red for ON
                        : [const Color(0xFF66BB6A), const Color(0xFF43A047)], // Green scheme for OFF
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 15, offset: Offset(0, 8))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Text(displayStatus, style: TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(width: 15),
                    Icon(Icons.local_fire_department, size: 70, color: Colors.white),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text("Status:", style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 15),

              // 4. Update Button (Gradient Pill)
              Container(
                width: 220,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(colors: [Color(0xFFFB923C), Color(0xFFF87171)]),
                ),
                child: ElevatedButton(
                  onPressed: getVoltage, // Trigger on click
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Update Data  ", style: TextStyle(fontSize: 18, color: Colors.white)),
                      Icon(Icons.arrow_upward, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // 5. Bottom Stove Image
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset('assets/Stove.png',width: double.infinity,height:150,fit: BoxFit.cover),
                    const SizedBox(height:25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build the circles
  Widget _buildCircleInfo(String label, String value, IconData icon, {bool isVoltage = false}) {
    // Split the date and time if it's the time circle
    List<String> parts = value.split(' ');
    String datePart = parts.isNotEmpty ? parts[0] : value;
    String timePart = parts.length > 1 ? parts[1] : "";

    return Container(
      width: 155,
      height: 155,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 17, color: Colors.grey)),
          const SizedBox(height: 5),

          if (!isVoltage) ...[
            // THIS IS THE 2x2 GRID (Two Rows)
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(datePart, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(timePart, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ] else ...[
            // THIS KEEPS YOUR ORIGINAL VOLTAGE STYLE
            Text(value,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700)),
            if (isVoltage) Icon(icon, color: Colors.blue.shade400, size: 35),
          ],
        ],
      ),
    );
  }
}