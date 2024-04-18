import 'package:flutter/material.dart';

class NavModel{
  final Widget page;
  final GlobalKey<NavigatorState> navBarKey;

  NavModel({
    required this.page, 
    required this.navBarKey
  });
}

