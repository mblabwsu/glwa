// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../widgets/password_reset_controller.dart';

/*
  PasswordResetView creates the page view for resetting the user's password.
*/

class PasswordResetView extends StatelessWidget {
  const PasswordResetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 248, 255),
      ),
      backgroundColor: const Color.fromARGB(255, 233, 248, 255),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Forgot your password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Enter your email to receive a password reset link.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Password reset widget
                  PasswordReset(),
                  SizedBox(height: 20),
                ],
              )),
        ),
      ),
    );
  }
}
