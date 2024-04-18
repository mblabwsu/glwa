// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:microbial_source_tracking/src/auth/auth_page.dart';

/*This file handles creation of the user's account for the purposes of tracking
  who submitted a given test.*/

//Initialize Firebase authentication
FirebaseAuth auth = FirebaseAuth.instance;

//Register is the name of this widget,
//refer to Register for routing purposes
class Register extends StatefulWidget {
  const Register({
    super.key,
  });
  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {
//Save the first name, last name, email and password
  final userFirstName = TextEditingController();
  final userLastName = TextEditingController();
  final userEmail = TextEditingController();
  final userPass = TextEditingController();
  final userPassConfirm = TextEditingController();

/*Initial password requirement check. True if password field meets strength req
  Strength req = Min of 8 characters, 1 capital, 1 lower, 1 number, 1 special
  passConfirm returns true if both password fields match. 
  both must return true to allow registration. 
  uniqueEmail tests if the email entered is not already in the database. 
  Initalized as true, set to false should the email already exist. Set to true
  after registerUser is called without getting caught by the already exist check.*/
  bool passStrength = false;
  bool passConfirm = false;
  bool uniqueEmail = true;

//Check if all the fields are filled. If even one is empty, return false
  bool checkButton() {
    if ((userEmail.text.isEmpty |
        userFirstName.text.isEmpty |
        userLastName.text.isEmpty |
        userPass.text.isEmpty |
        userPassConfirm.text.isEmpty)) {
      return false;
    } else {
      return true;
    }
  }

/*alertMessage returns a message based on the users inputs in the form of an issue
  0: Default error message and template, unused
  1: one or more fields were empty
  2,3: Password issue, these both clear the password fields after being called
  4: Email exists in the database already
  5: Success, signs the user in and takes them to the home page
 
  Case 0-4 will set the alert text button to "Return" for the user to try again
  Case 5 changes the alert text button to "Home page"*
  
  *: The application routes to the authpage, this is used to effectively sign 
  the user in. Once they log out, they are called back to it. On the user's side, 
  they will go from the registration page to the home page.*/

  Future<void> alertMessage(int issue) async {
    String issueTitle = " ";
    String issueContent = " ";
    String textForButton = "Return";

    switch (issue) {
      case 0:
        issueTitle = "Default error";
        issueContent = "This is the default error.";
        break;
      case 1:
        issueTitle = "Empty fields";
        issueContent = "Please fill out all fields.";
        break;
      case 2:
        issueTitle = "Password is too weak.";
        issueContent =
            "To ensure a strong password, make sure that the Password Strength fields are gone when submitting.";
        break;
      case 3:
        issueTitle = "Passwords do not match";
        issueContent = "Please make sure both passwords are the same.";
        break;
      case 4:
        issueTitle = "Email in use.";
        issueContent =
            "This email is already in use. Please enter a different email, or use 'Forgot password' on the login screen";
        break;
      case 5:
        issueTitle = "Check your email";
        issueContent =
            "A verification email has been sent to ${userEmail.text}";
        textForButton = "Home page";
        break;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, //the "textForButton" value must be pressed to close the alert
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(issueTitle, style: TextStyle(fontSize: 25)),
          content: Text(issueContent, style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (issue == 5) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AuthPage()), //Sets the user to be logged in, then sends them to the home page
                  );
                } else {
                  Navigator.of(context)
                      .pop(); //For any other issue, pressing the text button will return them to the registration page
                }
              },
              child: Text(textForButton, style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

//For showing/hiding the passwords
  bool passVisible = true;
  bool confirmVisible = true;

//Clears the password fields after not matching
  void clearPassword() {
    userPass.clear();
    userPassConfirm.clear();
  }

/*Error message that appears when creating a password, holds all the requirements
  that slowly are removed as the strength requirements are met.*/
  String _em = '';

/*strengthRequirements checks the password field if the password is:
  between 8 and 20 characters and contains at minimum
  One uppercase, lowcase, number, AND special character 
  
  Note: This only checks the initial password field, since confirm password
  must be the same as the password field, so no second strength check needed */
  bool strengthRequirements(String userPass) {
    //Resets error message after user updates password field.
    _em = '';
    //Returns true if any of these values "fail"
    if (userPass.length < 8) {
      _em += '• Minimum 8 characters.\n';
    }
    if (userPass.length > 20) {
      _em += '• Maximum 20 characters.\n';
    }
    if (!userPass.contains(RegExp(r'[A-Z]'))) {
      _em += '• 1 uppercase.\n';
    }
    if (!userPass.contains(RegExp(r'[a-z]'))) {
      _em += '• 1 lowercase.\n';
    }
    if (!userPass.contains(RegExp(r'[~!@#\\$%^&*(),.?":{}|<>]'))) {
      _em += '• 1 special character.\n';
    }
    if (!userPass.contains(RegExp(r'\d'))) {
      _em += '• 1 number.\n';
    }

    return _em.isEmpty;
  }

/*registerUser is called when the user presses 'Create account' after having
  passed the password checks. userCredential attempts to add the email and password
  to the Firebase, but if that email is already connected to a user, then issue 4
  from alertMessage is called notifying the user that the email is in use. 
  
  If all checks pass, alertMessage(5) is called, where the email and password are stored
  in Firebase. FirebaseFirestore handles adding first name, last name, and email
  into user collections.*/
  Future<User?> registerUser(
      {required String uEmail,
      required String uPass,
      required BuildContext context}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: uEmail,
        password: uPass,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstname': userFirstName.text.trim(),
        'lastname': userLastName.text.trim(),
        'email': userEmail.text.trim().toLowerCase(),
      });
      FirebaseAuth.instance.currentUser?.sendEmailVerification();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: uEmail,
        password: uPass,
      );
      alertMessage(5);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          uniqueEmail = false;
          alertMessage(4);
          break;
        case "invalid-email":
          uniqueEmail = false;
          alertMessage(4);
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  @override
  void dispose() {
    //clean up controller when widget is done using it.
    userFirstName.dispose();
    userLastName.dispose();
    userEmail.dispose();
    userPass.dispose();
    userPassConfirm.dispose();
    super.dispose();
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
            controller: userFirstName,
            decoration: const InputDecoration(
              labelText: 'First Name',
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              fillColor: Colors.white,
              filled: true,
              hintText: "First Name",
            ),
          ),
        ),

        //Enter in their Last Name (required)-------------------------------
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: TextFormField(
            controller: userLastName,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              fillColor: Colors.white,
              filled: true,
              hintText: "Last Name",
            ),
          ),
        ),

        //Enter in their email (required)-----------------------------------
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
                hintText: "Enter Email",
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

        //Initial password (required)---------------------------------------
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: TextFormField(
              controller: userPass,
              obscureText: passVisible,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter password",
                suffixIcon: IconButton(
                  icon: Icon(
                      passVisible ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(
                      () {
                        //Toggle to show the contents of "Enter password"
                        passVisible = !passVisible;
                      },
                    );
                  },
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                fillColor: Colors.white,
                filled: true,
              ),
              //Check for password strength and show what is missing.
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return null;
                }
                if (strengthRequirements(text) == false) {
                  passStrength = false;
                  return _em;
                }
                if (strengthRequirements(text) == true) {
                  passStrength = true;
                }
                return null;
              }),
        ),

        //Password confirmation, must be the same as above (required)-------
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: TextFormField(
              controller: userPassConfirm,
              obscureText: confirmVisible,
              decoration: InputDecoration(
                labelText: "Confirm password",
                hintText: "Confirm password",

                //Show/hide contents of "Confirm password"
                suffixIcon: IconButton(
                  icon: Icon(
                      confirmVisible ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(
                      () {
                        //Toggle to show the contents of "Confirm password"
                        confirmVisible = !confirmVisible;
                      },
                    );
                  },
                ),

                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                fillColor: Colors.white,
                filled: true,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return null;
                }
                if (userPass.text != userPassConfirm.text) {
                  passConfirm = false;
                }
                if (userPass.text == userPassConfirm.text) {
                  passConfirm = true;
                }
                return null;
              }),
        ),

        //Registration button-----------------------------------------------
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            setState(() {
              //User entered nothing in one or more fields
              if (((checkButton()) == false)) {
                alertMessage(1);
              }
              //User entered a weak password. Empty password fields and try again
              else if (((passStrength) == false)) {
                alertMessage(2);
                clearPassword();
              }
              //Password meets strength, but are not equal
              else if (((passConfirm) == false)) {
                alertMessage(3);
                clearPassword();
              }
              //Password is strong, both are equal, and email is unique
              else if (((passStrength & passConfirm) == true)) {
                registerUser(
                    uEmail: userEmail.text,
                    uPass: userPass.text,
                    context: context);
                uniqueEmail = true;
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
              'Create account',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
      ]),
    ));
  }
}
