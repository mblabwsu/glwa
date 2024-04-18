import "package:flutter/material.dart";
import "package:microbial_source_tracking/src/themes/glwa_theme.dart";

/*
  HowToBluetooth displays the instructions on how to connect to a Bluetooth
  device.
*/

class HowToBluetooth extends StatelessWidget {
  const HowToBluetooth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: glwaTheme.secondaryHeaderColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'How to Connect a Bluetooth Device',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'To begin connecting to a Bluetooth device, make sure both the device that this application is running on and the device that you will be connecting to have their Bluetooth settings on.',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: RichText(
                  text: const TextSpan(children: [
                TextSpan(
                    text:
                        'Once Bluetooth is functional on both devices, go to the configurations (',
                    style: TextStyle(color: Colors.black, fontSize: 17)),
                WidgetSpan(child: Icon(Icons.build_circle_outlined)),
                TextSpan(
                    text: ') page from the navigation bar.',
                    style: TextStyle(color: Colors.black, fontSize: 17))
              ])),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'Bluetooth devices will be available as a list on the configurations page. Find your device within the presented list and tap on it to connect.',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'Your device should now be connected to this application!',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
