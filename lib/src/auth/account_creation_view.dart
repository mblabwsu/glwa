// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../widgets/account_creation_controller.dart';

//RegisterView is the name of this widget,
//refer to RegisterView for routing purposes
class RegisterView extends StatelessWidget {
  const RegisterView({
    super.key,
  });

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
                  Text(
                    'Create a new account',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Fill out the following fields to create an account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 15),

                  //Register widget
                  Register(),
                  SizedBox(height: 20),
                ],
              )),
        ),
      )
    );
  }
}