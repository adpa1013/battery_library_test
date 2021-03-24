import 'package:flutter/material.dart';
import 'dart:async';

import 'package:battery_library/battery_library.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _batteryLevel = -1;
  int _batteryState = -1;

  @override
  void initState() {
    super.initState();
    updateBatteryLevel();
    updateBatteryState();
  }

  Future<void> updateBatteryLevel() async {
    int batteryLevel;
    try {
      batteryLevel = await BatteryLibrary.batteryLevel;
    } on Exception {
      batteryLevel = -1;
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

    Future<void> updateBatteryState() async {
    int batteryState;
    try {
      batteryState = await BatteryLibrary.batteryState;
    } on Exception {
      batteryState = -1;
    }

    setState(() {
      _batteryState = batteryState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Power left: $_batteryLevel'),
            ),
            Center(
              child: Text('Battery State: $_batteryState'),
            ),
          ],
        ),
      ),
    );
  }
}
