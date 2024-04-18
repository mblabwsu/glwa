import "package:flutter/material.dart";
import "package:microbial_source_tracking/src/themes/glwa_theme.dart";

/*
  HowToConfigure displays the instructions on how to configure a device for
  the purposes of the application.
*/

class HowToConfigure extends StatelessWidget {
  const HowToConfigure({super.key});

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
                  'How to Configure a Device',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'After you have connected your device, you will be able to configure your device on the configurations page.',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'Click on your device and a new page should open up. On this new page, there will be configurable options for the testing process.',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'The following items and their settings will be configurable: \n\u2022 LED \n\u2022 Heating pad \n\u2022 Incubation time',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
