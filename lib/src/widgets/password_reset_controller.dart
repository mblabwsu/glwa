// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*This file handles changing the user's password by clicking "Forgot password?"
  on the login screen.*/
class PasswordReset extends StatefulWidget {
  const PasswordReset({
    super.key,
  });
  @override
  State<PasswordReset> createState() => PasswordResetState();
}

class PasswordResetState extends State<PasswordReset> {
  TextEditingController userEmail = TextEditingController();

  Future forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      alertMessage(7);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

/*alertMessage returns a message based on the users inputs in the form of an issue
  issue starts at 6 as a continuation from alertMessage from account_creation_controller-
  the methods do not interact, I just prefered the consistency for continuing from 5.
  
  6: Email field has been filled
  7: Email field has not been filled correctly (missing . and/or @)*/
  Future<void> alertMessage(int issue) async {
    String issueTitle = " ";
    String issueContent = " ";
    String textForButton = "Return";

    switch (issue) {
      case 6:
        issueTitle = "Password reset email sent";
        issueContent =
            "If ${userEmail.text} exists within our database, a password reset link will appear in your inbox.";
        textForButton = "OK";
      case 7:
        issueTitle = "No email provided";
        issueContent = "Please enter a valid email address";
        textForButton = "Return";
    }

    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, //the "textForButton" value must be pressed to close the alert
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(issueTitle, style: const TextStyle(fontSize: 25)),
          content: Text(issueContent, style: const TextStyle(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // if (issue == 6) {
                //   Navigator.of(context).pop();
                // } else {
                //   Navigator.of(context).pop(); //return the user to the forgot password page as they failed to fill in the email field
                // }
                Navigator.of(context).pop();
              },
              child: Text(textForButton, style: const TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        //Enter in their First Name (required)------------------------------
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: TextFormField(
              controller: userEmail,
              decoration: const InputDecoration(
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter email",
              ),
              //Hints telling user what is missing.
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "Please enter your email.";
                }
                if (!EmailValidator.validate(userEmail.text.trim())) {
                  return "Please enter a valid email.";
                }
                return null;
              }),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            setState(() {
              if (userEmail.text.isEmpty ||
                  !userEmail.text.contains('@') ||
                  !userEmail.text.contains('.')) {
                alertMessage(7);
              } else {
                forgotPassword(email: userEmail.text);
                alertMessage(6);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 52, 52, 52),
                borderRadius: BorderRadius.circular(8)),
            child: const Center(
                child: Text(
              'Send password reset',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        )
      ]),
    ));
  }
}
