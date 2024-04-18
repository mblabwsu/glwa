import "package:flutter/material.dart";
import "package:microbial_source_tracking/src/themes/glwa_theme.dart";

/*
  HowToStartTest displays the instructions on how to start a test.
*/

class HowToStartTest extends StatelessWidget {
  const HowToStartTest({super.key});

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
                  'How to Start a Test',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'Navigate to the action page by clicking on the plus (+) button in the middle of the navigation bar.',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'On the action page, there are two main options: Open/Close Bay and Start Test. If you need to open or close the bay before starting the test, press the Open/Close Bay button. To begin the testing process, simply press the Start Test button.',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'The configurations that were defined for the test will be sent to the Raspberry Pi and the application will communicate to the Raspberry Pi to start the testing process.',
                style: TextStyle(fontSize: 17),
              ),
            )
          ],
        ),
      ),
    );
  }
}
