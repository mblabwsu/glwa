// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/widgets/bluetooth_connection_controller.dart';
import 'package:microbial_source_tracking/src/widgets/wifi_connection_controller.dart';
import '../themes/glwa_theme.dart';


/*
Here is the configuration page for the applications connection to the IoT device running 
on a raspberry pi. This is the UI portion of it, the page will direct the user to either 
Wi-Fi or Bluetooth configurations. Here the user will decided whether they are going to
use one or the other.
*/





class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _Configview();
}

class _Configview extends State<ConfigView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => BluetoothConnect())
                  )
                );
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
                    'Bluetooth Connection',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => WifiConnect(title: ' ',))
                  )
                );
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
                    'Wi-Fi Connection',
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
