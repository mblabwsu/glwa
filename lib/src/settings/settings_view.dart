import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/settings/settings_model.dart';
import 'package:microbial_source_tracking/src/widgets/profile_card.dart';
import 'package:microbial_source_tracking/src/widgets/settings_card.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({
    super.key,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        //ignore: prefer_const_constructors
        body: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ProfileCard(),
              const SizedBox(height: 0.005),
              const Divider(),
              const SizedBox(height: 10),
              Column(
                children: List.generate(
                  settings.length,
                  (index) => SettingsCard(settings: settings[index]),
                ),
              ),

              // Sign out button
              GestureDetector(
                onTap: signUserOut,
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade200,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(Icons.logout, color: Colors.black),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Log out',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
