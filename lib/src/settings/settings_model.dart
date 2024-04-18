import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/settings/account_data.dart';

class Setting {
  final String title;
  final Widget route;
  final IconData icon;

  Setting({
    required this.title,
    required this.route,
    required this.icon,
  });
}

final List<Setting> settings = [
  Setting(
    title: 'Account Data',
    route: const AccountData(),
    icon: Icons.person_4,
  ),
];
