import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:microbial_source_tracking/src/auth/auth_page.dart';
import 'package:microbial_source_tracking/src/themes/glwa_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override //This widget is the root of our application
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: glwaTheme,
      home: StreamBuilder<BluetoothAdapterState>(
        stream: FlutterBluePlus.adapterState,
        initialData: BluetoothAdapterState.unknown,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothAdapterState.on) {
            return const AuthPage();
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}
