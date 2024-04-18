import "package:flutter/material.dart";
import "package:microbial_source_tracking/src/themes/glwa_theme.dart";

/*
  HowToFiles displays the instructions on how to select and upload a file
  from the device's local storage to the database.
*/

class HowToFiles extends StatelessWidget {
  const HowToFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: glwaTheme.secondaryHeaderColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'How to Select and Upload a File',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'Once the image has been pulled from the Raspberry Pi, it will be stored locally on your device.',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: RichText(
                  text: const TextSpan(children: [
                TextSpan(
                    text:
                        'To upload the image to the database, click on the folder icon (',
                    style: TextStyle(fontSize: 17, color: Colors.black)),
                WidgetSpan(child: Icon(Icons.folder_outlined)),
                TextSpan(
                    text:
                        ') on the navigation bar. This opens up the history page, where you can view all the uploaded files.',
                    style: TextStyle(fontSize: 17, color: Colors.black))
              ])),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'There are two main buttons on the history page: Select File and Upload File. First, you will need to select a file from your device using the Select File. Your device\'s local files will be accessed and you will be able to select a file.',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'Once selected, you will be prompted to rename the image. The selected file will appear on the history page. To upload this file, press the Upload File button.',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: const Text(
                'The image will be uploaded to the database and it will appear in a list of images on the history page.',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
