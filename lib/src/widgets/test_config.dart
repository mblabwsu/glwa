// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/themes/glwa_theme.dart';

class TestConfig extends StatefulWidget {
  const TestConfig({super.key});

  @override
  State<TestConfig> createState() => _TestConfig();
}

class _TestConfig extends State<TestConfig> {
  bool deviceConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Test'),
        backgroundColor: glwaTheme.secondaryHeaderColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),

            // if a device is connected, show which device is connected
            if (deviceConnected)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),

                // add actual bluetooth device later
                child: Center(
                    child: Text(
                  'Connected to Raspberry Pi Zero',
                  style: TextStyle(fontSize: 17),
                )),
              ),

            // if no device connected, show that no device is connected
            if (!deviceConnected)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: const Center(
                    child: Text(
                  'No device connected!',
                  style: TextStyle(color: Colors.red, fontSize: 17),
                )),
              ),

            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                // add open/close bay communication to pi here

                const snackBar =
                    SnackBar(content: Text('Opening/Closing bay...'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    color: glwaTheme.secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: const Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black))),
                child: const Center(
                  child: Text(
                    'Open/Close Bay',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                // add start test communication to pi here

                const snackBar = SnackBar(content: Text('Starting test...'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    color: glwaTheme.secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: const Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black))),
                child: const Center(
                  child: Text(
                    'Start Test',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
