import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:microbial_source_tracking/src/widgets/light_controller.dart';

class BluetoothConnect extends StatelessWidget {
  const BluetoothConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Configuration"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBluePlus.scanResults, 
              initialData: [],
              builder: (c, snapshot) => Column(
                children: snapshot.data!
                    .map((result) => ListTile(
                      title: Text(result.device.platformName == "" ? "No Device Name" : result.device.platformName),
                      subtitle: Text(result.device.remoteId.toString()),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        result.device.connect();
                        return LightController(device: result.device);
                      })),
                    ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBluePlus.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => FlutterBluePlus.stopScan(),
              backgroundColor: Colors.lightBlue.shade700,
              child: const Icon(Icons.stop),
            );
          } 
          else {
            return FloatingActionButton(
              onPressed: () => FlutterBluePlus.startScan(
                timeout: const Duration(seconds: 5),
              ),
              backgroundColor: Colors.lightBlue.shade700,
              child: const Icon(Icons.search),
            );
          }
        },
      ),
    );
  }
}
