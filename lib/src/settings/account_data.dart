// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/*
  AccountData organizes the user's account data and allows the user to
  edit their account data.
*/

class AccountData extends StatefulWidget {
  const AccountData({super.key});

  @override
  State<AccountData> createState() => _AccountDataState();
}

class _AccountDataState extends State<AccountData> {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController newValue = TextEditingController();
  bool saveDisabled = true;

  @override
  void dispose() {
    newValue.dispose();
    super.dispose();
  }

  void clearText() {
    newValue.clear();
  }

  // Update user's data based on a specific field
  Future<void> updateUser(String field) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({field: newValue.text.trim()})
        .then((value) => print('user updated'))
        .catchError((error) => print('failed to update user: $error'));
  }

  // Update user's email
  Future<void> updateEmail() async {
    try {
      String password = newValue.text.trim();

      // Reauthenticate user credentials to change email
      AuthCredential credential =
          EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);

      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Change email'),
          content: TextFormField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter new email'),
            controller: newValue,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Please enter an email";
              }
              if (!EmailValidator.validate(newValue.text.trim())) {
                return "Please enter a valid email";
              }
              return null;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => {clearText(), Navigator.pop(context)},
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => {
                if (EmailValidator.validate(newValue.text.trim()))
                  {
                    user
                        .verifyBeforeUpdateEmail(newValue.text.trim())
                        .then((value) => print('user email updated'))
                        .catchError(
                            (error) => print('failed to update user: $error')),
                    updateUser('email'),
                  },
                if (!EmailValidator.validate(newValue.text.trim()))
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Could not update user information: invalid email'),
                      ),
                    )
                  },
                clearText(),
                Navigator.pop(context)
              },
              child: const Text('Save'),
            )
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      );
    } catch (e) {
      print('error during reauthentication: $e');
      // setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password is incorrect!'),
        ),
      );
    }
  }

  // Update user's password
  Future<void> updatePassword() async {
    try {
      String password = newValue.text.trim();

      // Reauthenticate user credentials to change password
      AuthCredential credential =
          EmailAuthProvider.credential(email: user.email!, password: password);

      await user.reauthenticateWithCredential(credential);

      TextEditingController newPass = TextEditingController();

      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Change password'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter new password'),
            controller: newPass,
          ),
          actions: [
            TextButton(
              onPressed: () => {clearText(), Navigator.pop(context)},
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => {
                user
                    .updatePassword(newPass.text.trim())
                    .then((value) => print('user password updated'))
                    .catchError(
                        (error) => print('failed to update user: $error')),
                clearText(),
                Navigator.pop(context)
              },
              child: const Text('Save'),
            )
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      );
    } catch (e) {
      print('error during reauthentication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password is incorrect!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Account Data')),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  // User email organized into an individual card
                  buildAccountDataCard(
                      title: 'Email',
                      value: userData['email'] ?? '',
                      onEditPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Change email'),
                              content: TextFormField(
                                autofocus: true,
                                decoration: const InputDecoration(
                                    hintText: 'Enter current password'),
                                controller: newValue,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please enter your current password";
                                  }
                                  return null;
                                },
                                obscureText: true,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      {clearText(), Navigator.pop(context)},
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    if (newValue.text.trim().isNotEmpty)
                                      {updateEmail(), clearText()},
                                    Navigator.pop(context)
                                  },
                                  child: const Text('OK'),
                                )
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          )),

                  // User first name organized into an individual card
                  buildAccountDataCard(
                      title: 'First name',
                      value: userData['firstname'] ?? '',
                      onEditPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Change first name'),
                              content: TextFormField(
                                autofocus: true,
                                decoration: const InputDecoration(
                                    hintText: 'Enter new name'),
                                controller: newValue,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please enter a name";
                                  }
                                  return null;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      {clearText(), Navigator.pop(context)},
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    if (newValue.text.trim().isNotEmpty)
                                      {updateUser('firstname'), clearText()},
                                    Navigator.pop(context),
                                  },
                                  child: const Text('Save'),
                                )
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          )),

                  // User last name organized into an individual card
                  buildAccountDataCard(
                      title: 'Last name',
                      value: userData['lastname'] ?? '',
                      onEditPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Change last name'),
                              content: TextFormField(
                                autofocus: true,
                                decoration: const InputDecoration(
                                    hintText: 'Enter new name'),
                                controller: newValue,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please enter a name";
                                  }
                                  return null;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      {clearText(), Navigator.pop(context)},
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    if (newValue.text.trim().isNotEmpty)
                                      {updateUser('lastname'), clearText()},
                                    Navigator.pop(context),
                                  },
                                  child: const Text('Save'),
                                )
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          )),

                  // Password organized into an individual card
                  buildAccountDataCard(
                      title: 'Password',
                      value: '********',
                      onEditPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Change password'),
                              content: TextFormField(
                                autofocus: true,
                                decoration: const InputDecoration(
                                    hintText: 'Enter current password'),
                                controller: newValue,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please enter your current password";
                                  }
                                  return null;
                                },
                                obscureText: true,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      {clearText(), Navigator.pop(context)},
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    if (newValue.text.trim().isNotEmpty)
                                      {updatePassword(), clearText()},
                                    Navigator.pop(context)
                                  },
                                  child: const Text('OK'),
                                )
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          )),
                ],
              );
            } else if (snapshot.data == null) {
              return const Center(
                child: Text('No data available'),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ));
  }

  // buildAccountDataCard creates a container that holds given metadata fields
  // and edit functionality
  Widget buildAccountDataCard(
      {required String title,
      required String value,
      required VoidCallback onEditPressed}) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 228, 228, 228),
          borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
                onPressed: onEditPressed,
                icon: const Icon(Icons.settings, color: Colors.grey))
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
