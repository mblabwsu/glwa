// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unnecessary_string_interpolations, sized_box_for_whitespace, avoid_print

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:microbial_source_tracking/src/history/history_page_view.dart';
import 'package:permission_handler/permission_handler.dart';

// This file handles all the code for the history page, where files can be uploaded and viewed.

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final db = FirebaseFirestore.instance; // Cloud firestore instance!
  List<String> cachedUserOptions =
      []; // this will store initialized filtering options
  List<String> cachedLakeOptions = [];

  PlatformFile? pickedFile;

  @override
  void initState() {
    super.initState();
    fetchUserOptions(); // this will initialize filtering options when the app first launches, so it doesnt read from the Database every time the user tries to filter
    fetchLakeOptions();
  }

  Future selectFile() async {
    final result = await FilePicker.platform
        .pickFiles(); // for selecting a file from local storage
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File Selected!'),
        ),
      );
    });
  }

  double uploadProgress =
      0.0; // upload progress for the progress bar, which increases in correlation to bytes transfered to the database

  Future uploadFile() async {
    bool serviceEnabled;
    LocationPermission
        permission; // permissions for accessing device location for android/ios. to record latitude/longitutde metadata

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print('location disabled');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select a file first.'),
        ),
      );
    }

    if (pickedFile != null) {
      final path = 'images/${pickedFile!.name}';
      final file = File(pickedFile!.path!);

      String? waterSource = await getWaterSource();

      if (waterSource != null) {
        final ref = FirebaseStorage.instance.ref().child(path);

        setState(() {
          uploadProgress = 0.0;
        });

        final task = ref.putFile(file);

        task.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            uploadProgress = snapshot.bytesTransferred /
                snapshot.totalBytes; // progress bar for uploading file
          });
        });

        await task; //must wait for firebase storage upload to complete first before grabbing downloadURL for cloud firestore document field

        String currentUserEmail =
            FirebaseAuth.instance.currentUser?.email ?? "";

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUserEmail)
            .get(); // finds the user document corresponding to the currently-logged-in user
        DocumentSnapshot currentUserInfo = querySnapshot.docs.first;

        String uploadedDate = DateFormat('MM-dd-yyyy').format(actualDate);

        var userLocation = await Geolocator.getCurrentPosition();

        final image = <String, dynamic>{
          // uploaded document and its fields
          "title": '$waterSource $uploadedDate',
          "uploadedDate": FieldValue.serverTimestamp(),
          "imageURL": await ref.getDownloadURL(),
          "lake": waterSource,
          "uploader's email": currentUserEmail,
          "uploader's first name": currentUserInfo['firstname'],
          "uploader's last name": currentUserInfo['lastname'],
          "latitude": userLocation.latitude,
          "longitude": userLocation.longitude,
        };

        await db.collection("images").add(image).then((DocumentReference doc) {
          print('DocumentSnapshot added with ID: ${doc.id}');

          setState(() {
            pickedFile = null;
            uploadProgress = 0.0;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File Uploaded!'),
            ),
          );
        });
      }

      print(Geolocator.getCurrentPosition());
    }
  }

  Future getWaterSource() async {
    // function for getting the water source AKA lake name from the user. needed bc GPS will provide latitude/longitude but not actual lake name.
    TextEditingController waterSourceController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sample Retrieved From: '),
          content: TextField(
            controller: waterSourceController,
            decoration: InputDecoration(hintText: 'Water Source'),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Done'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Uploading File...'),
                    ),
                  );

                  Navigator.pop(context, waterSourceController.text);
                }),
          ],
        );
      },
    );
  }

  Future showFile(QueryDocumentSnapshot doc) async {
    String imageName = doc['title'];
    String imageURL = doc['imageURL'];
    String uploaderEmail = doc["uploader's email"];
    String uploaderFirstName = doc["uploader's first name"];
    String uploaderLastName = doc["uploader's last name"];
    String uploadTime =
        DateFormat('HH:mm').format(doc['uploadedDate'].toDate());
    double latitude = doc['latitude'];
    double longitude = doc['longitude'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Container(
                padding: const EdgeInsets.all(8.0),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(imageURL),
                    SizedBox(height: 10),
                    Text('$imageName'),
                    Text('Latitude: $latitude'),
                    Text('Longitude: $longitude'),
                    Text('Upload Time: $uploadTime'),
                    Text('Uploader\'s Email: $uploaderEmail'),
                    Text('Uploader\'s First Name: $uploaderFirstName'),
                    Text('Uploader\'s Last Name: $uploaderLastName')
                  ],
                )));
      },
    );
  }

  Future showSelectedFile() async {
    // shows selected file for preview before user decides to upload it to make sure its the right file
    if (pickedFile != null) {
      File file = File(pickedFile!.path!);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Image.file(file),
          );
        },
      );
    }
  }

  List<String> selectedLakes =
      []; // these variables hold the user's selected filtering options
  List<String> selectedUsers = [];

  Future fetchUserOptions() async {
    // see comment on Line 32
    if (cachedUserOptions.isEmpty) {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('email')
          .get();
      cachedUserOptions = userQuery.docs
          .map((doc) => (doc['email'] as String?) ?? "")
          .toSet()
          .toList();
    }
  }

  Future fetchLakeOptions() async {
    if (cachedLakeOptions.isEmpty) {
      QuerySnapshot lakeQuery = await FirebaseFirestore.instance
          .collection('images')
          .orderBy('lake')
          .get();
      cachedLakeOptions = lakeQuery.docs
          .map((doc) => (doc['lake'] as String?) ?? "")
          .toSet()
          .toList();
    }
  }

  Future openUserOptions() async {
    // opens checklist of all the Users registered to the app so the user can filter the data by Username of Uploader
    await fetchUserOptions();

    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(false); // Close the dialog on tap outside
          },
          child: SimpleDialog(
            title: Text('Select Users'),
            children: [
              SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      children: cachedUserOptions.map((user) {
                        return CheckboxListTile(
                          title: Text(user),
                          value: selectedUsers.contains(user),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                selectedUsers.add(user);
                              } else {
                                selectedUsers.remove(user);
                              }
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text('Done'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      setState(() {
                        selectedLakes = [];
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (result != null && result) {
      print('Selected Users: $selectedUsers');
    }
  }

  Future openLakeOptions() async {
    // opens checklist of all the Locations registered to the app so the user can filter the data by Location
    await fetchLakeOptions();

    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(false); // Close the dialog on tap outside
          },
          child: SimpleDialog(
            title: Text('Select Location'),
            children: [
              SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      children: cachedLakeOptions.map((lake) {
                        return CheckboxListTile(
                          title: Text(lake),
                          value: selectedLakes.contains(lake),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                selectedLakes.add(lake);
                              } else {
                                selectedLakes.remove(lake);
                              }
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text('Done'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      setState(() {
                        selectedUsers = [];
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (result != null && result) {
      print('Selected Lakes: $selectedLakes');
    }
  }

  DateTime currentDate = DateTime
      .now(); // using DateTime class to grab current date, which can be modified in the DatePicker below for filtering purposes
  DateTime actualDate = DateTime.now();

  bool showAllDates =
      true; // changes based on whether a date is selected or not for data filtering

  Stream<QuerySnapshot> getDocumentStream() {
    // StreamBuilder (located lower in this file) listens to Stream (this function). Stream changes the documents viewable on the user's feed based on their selected filters.
    DateTime start =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    DateTime end = start.add(Duration(days: 1));

    Query collectionQuery = FirebaseFirestore.instance.collection('images');

    if (!showAllDates) {
      collectionQuery = collectionQuery
          .where('uploadedDate', isGreaterThanOrEqualTo: start)
          .where('uploadedDate', isLessThan: end); // Handles date filtering
    }

    if (selectedLakes.isNotEmpty) {
      collectionQuery = collectionQuery.where('lake',
          whereIn: selectedLakes); // handles location filtering
    }

    if (selectedUsers.isNotEmpty) {
      collectionQuery = collectionQuery.where('uploader\'s email',
          whereIn: selectedUsers); // handles User filtering
    }

    collectionQuery = collectionQuery.orderBy('uploadedDate', descending: true);

    return collectionQuery.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      selectFile();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.cloud_upload),
                        SizedBox(width: 9),
                        Text('Select File',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      uploadFile();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.cloud_upload),
                        SizedBox(width: 9),
                        Text('Upload File',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              pickedFile != null
                  ? (uploadProgress > 0.0
                      ? LinearProgressIndicator(
                          value: uploadProgress,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Card(
                            child: ListTile(
                              title: Text(
                                'Selected file: ${pickedFile!.name}',
                                textAlign: TextAlign.center,
                              ),
                              onTap: showSelectedFile,
                            ),
                          ),
                        ))
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Card(
                        child: ListTile(
                          title: Text(
                            'Selected file appears here',
                            style: TextStyle(fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        TextButton(
                          child: const Row(children: [
                            Text("Date ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Icon(Icons.date_range),
                          ]),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              // Selecting Date filtering option opens up calendar to pick date
                              context: context,
                              initialDate: currentDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                currentDate = pickedDate;
                                showAllDates = false;
                              });
                            } else {
                              setState(() {
                                showAllDates = true;
                              });
                            }
                          },
                        ),
                        TextButton(
                            child: const Row(children: [
                              Text("Location",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Icon(Icons.location_on),
                            ]),
                            onPressed: () {
                              openLakeOptions();
                            }),
                        TextButton(
                            child: const Row(children: [
                              Text("User",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Icon(Icons.person),
                            ]),
                            onPressed: () {
                              openUserOptions();
                            }),
                      ],
                    ),
                  ),
                  TextButton(
                    child: Text(
                        'Reset'), //Restting filters sets everything back to default
                    onPressed: () {
                      setState(() {
                        showAllDates = true;
                        selectedLakes = [];
                        selectedUsers = [];
                      });
                    },
                  ),
                ],
              ),
              Text(
                  showAllDates
                      ? 'All History'
                      : 'History From: ${DateFormat('MM-dd-yyyy').format(currentDate)}',
                  style: TextStyle(fontSize: 18)),
              StreamBuilder<QuerySnapshot>(
                stream: getDocumentStream(),
                builder: (context, snapshot) {
                  List<QueryDocumentSnapshot> documents =
                      snapshot.data?.docs ?? [];

                  if (documents.isEmpty) {
                    return Text('No files found with current filters.');
                  }

                  return Column(
                    children: documents.map((doc) {
                      String imageName = doc['title'];
                      String documentID =
                          doc.id; // reference in case of deleting
                      String imageURL =
                          doc['imageURL']; // reference in case of deleting

                      TextEditingController textEditingController =
                          TextEditingController();

                      return Dismissible(
                        // Swipe-to-Delete: Each item can be swiped to delete it
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(
                                    'Are you sure you want to delete this file?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) async {
                          await db
                              .collection("images")
                              .doc(documentID)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('File Deleted'),
                            ),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          child: const ListTile(
                            leading: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text('$imageName'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => HistoryPageView(
                                          doc:
                                              doc)))); // routes to another page to display the selected file's information
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    TextEditingController
                                        textEditingController =
                                        TextEditingController();

                                    String oldTitle = doc[
                                        'title']; // Changing the 'lake' field and title of a document/file, in case of an error or typo.
                                    String datePart = "";
                                    bool foundDatePart = false;

                                    for (int i = 0; i < oldTitle.length; i++) {
                                      if (oldTitle[i]
                                          .contains(RegExp(r'[0-9]'))) {
                                        // Since the title of each file is "Lake Name MM-DD-YYYY", a concatenation of 2 strings (lake string and date string), but only the Lake string needs to be edited,
                                        foundDatePart =
                                            true; // due to the original date needing to stay the same, this iterates the string until a numerical value is reached, after which the date portion of the title is saved and combined with the user-inputted new lake/location name.
                                      }

                                      if (foundDatePart) {
                                        datePart += oldTitle[i];
                                      }
                                    }

                                    return AlertDialog(
                                      title: Text(
                                          'Edit sample location:'), // user input for editing file location
                                      content: TextField(
                                        controller: textEditingController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter new water source.',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Save'),
                                          onPressed: () async {
                                            String newLocation =
                                                textEditingController.text;
                                            if (newLocation.isNotEmpty) {
                                              Navigator.of(context).pop();

                                              String newTitle =
                                                  '$newLocation $datePart';

                                              await db
                                                  .collection("images")
                                                  .doc(doc.id)
                                                  .update({
                                                'lake': newLocation,
                                                'title': newTitle,
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Sample source and file name updated!'),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Please enter a valid sample source.'),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// search bar: search by date, location, and person who took the data. Nothing else is needed
