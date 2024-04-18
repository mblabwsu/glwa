import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/home/home_view.dart';
import 'package:microbial_source_tracking/src/login/login_view.dart';

/*
  AuthPage takes care of user authentication after logging in. If the user
  is logged in, the home page will be shown to the user. If the user is not
  logged in, the login page will be shown to the user.
*/

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is logged in
          if (snapshot.hasData) {
            return const HomeView();
          } else {
            // User is not logged in
            return const LoginView();
          }
        },
      ),
    );
  }
}
