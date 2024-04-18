import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:microbial_source_tracking/src/auth/account_creation_view.dart';
import 'package:microbial_source_tracking/src/widgets/login_controller.dart';

import '../auth/password_reset_view.dart';

/*
  LoginView displays the login page of the application, which includes the
  GLWA logo, login text, login widget, routing to the account creation page,
  and routing to the reset password page.
*/

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 248, 255),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/images/glwa_logo.svg')),
                  const SizedBox(height: 50),
                  const Text(
                    'Log in to your account',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // Login widget
                  const Login(),

                  const SizedBox(height: 20),

                  // Account creation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Don\'t have an account? ',
                              style: TextStyle(fontSize: 16)),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterView(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign up here',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          )
                        ]),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // Forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PasswordResetView(),
                                ),
                              );
                            },
                            child: const Text('Forgot password?',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          )
                        ]),
                  ),
                  const SizedBox(height: 10),
                ],
              )),
        ),
      ),
    );
  }
}
