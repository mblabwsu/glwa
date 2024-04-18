import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/services.dart';

class TestSSH extends StatelessWidget{
  const TestSSH({super.key});
  

  void Test(List<String> args) async {
    final client = SSHClient(
      await SSHSocket.connect('localhost', 22), 
      username: 'ddlpi',
      onPasswordRequest: () {
        stdout.write('rootpi');
        stdin.echoMode = false;
        return stdin.readLineSync() ?? exit(1);
      }
    );
    final session = await client.execute('sudo /home/ddl2/Desktop/TestLight.py');
    await File('').openRead().cast<Uint8List>().pipe(session.stdin);

    await session.done;
    print('done');

    client.close();
    await client.done;

  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}