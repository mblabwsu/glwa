import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:microbial_source_tracking/src/themes/glwa_theme.dart';

/* 
  HistoryPageView organizes a specific image's information on a new page.
*/

class HistoryPageView extends StatelessWidget {
  final QueryDocumentSnapshot doc;

  const HistoryPageView({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    // Image's metadata is stored in variables
    String imageName = doc['title'];
    String imageURL = doc['imageURL'];
    String uploaderEmail = doc["uploader's email"];
    String uploaderFirstName = doc["uploader's first name"];
    String uploaderLastName = doc["uploader's last name"];
    String uploadTime =
        DateFormat('HH:mm').format(doc['uploadedDate'].toDate());
    double latitude = doc['latitude'];
    double longitude = doc['longitude'];

    return Scaffold(
        appBar: AppBar(title: Text(imageName)),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(8.0),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 275,
                    child: Center(
                        child: Image.network(
                      imageURL,
                      loadingBuilder: ((context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const Center(
                            // If the image is still loading, display a circular
                            // progress indicator
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                    )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        // Metadata organized into individual cards
                        buildMetadataCard(
                            title: 'Coordinates',
                            value: '($latitude, $longitude)'),
                        buildMetadataCard(
                            title: 'Upload time', value: uploadTime),
                        buildMetadataCard(
                            title: 'Uploader email', value: uploaderEmail),
                        buildMetadataCard(
                            title: 'Uploader name',
                            value: '$uploaderFirstName $uploaderLastName'),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }

  // Creates a container that holds given metadata fields
  Widget buildMetadataCard({required String title, required String value}) {
    return Container(
      decoration: BoxDecoration(
          color: glwaTheme.secondaryHeaderColor,
          borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ]),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
