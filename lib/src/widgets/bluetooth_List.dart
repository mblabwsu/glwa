import 'package:flutter/material.dart';

// ignore: camel_case_types
class bluetoothList extends StatelessWidget {
  const bluetoothList({
    super.key,
    required this.devices,
  });

  final List<String> devices;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          // horizontal: 5,
          vertical: 18,
        ),
        itemCount: devices.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            // color: Colors.grey.shade100,
            child: ListTile(
              title: Text('Bluetooth ${devices[index]}'),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const NextPage(),
                //   ),
                // );
              },
            ),
          );
        },
      ),
    );
  }
}


class NextPage extends StatelessWidget {
  const NextPage({
      super.key,
      });



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
    );
  }
}
