import 'package:flutter/material.dart';

final ThemeData glwaTheme = ThemeData(
  useMaterial3: true,
  fontFamily: ' ',
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Colors.lightBlue.shade700,
    secondary: Colors.lightBlue.shade200,
    background: Colors.white,
  ),  
);