


// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WifiConnect extends StatefulWidget {
WifiConnect({Key? key, required this.title}) : super(key: key);
final String title;
@override
_WifiConnect createState() => _WifiConnect();
}

class _WifiConnect extends State<WifiConnect> {
  String _pinState = 'off';
  void _sendCommand(String pinState) async {

    String url = 'https://46f3-174-240-144-167.ngrok-free.app/control'; //enter pyngrok generated url
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String body = jsonEncode({'pin_state': pinState});

    /*
      This try catch is what allows the application to connect to the ngrok endpoint required
      for communicating with the IoT device through a webserver supported on flask
    */

    try{
      final response = await http.post(Uri.parse(url), headers: headers,body: body);
      if (response.statusCode == 200) {
        setState(() {
          _pinState = pinState;
        });
        print('Command sent successfully');
      } else {
        print('Command failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'GPIO Pin State:',
            ),
            Text(
              _pinState,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              _sendCommand('on'); //Here is where you can change the command being sent
            },
            child: const Text('Turn On'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                _sendCommand('off'); //Here is where you can change the commmand being sent
              }, 
              child: const Text('Turn Off'),
            ),
          ],
        )
      ),
    );
  }

}