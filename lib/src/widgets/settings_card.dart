import 'package:flutter/material.dart';

import '../settings/settings_model.dart';

class SettingsCard extends StatelessWidget {
  final Setting settings;
  const SettingsCard({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => settings.route)));
      }, //Navigation tool
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
            child: Icon(settings.icon, color: Colors.black),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            settings.title,
            style: const TextStyle(
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
    );
  }
}
