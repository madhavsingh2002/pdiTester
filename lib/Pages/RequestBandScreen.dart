import 'package:flutter/material.dart';
import 'NewRequestBand.dart';
import 'PreviousRequestDevice.dart';

class RequestDeviceScreen extends StatefulWidget {
  @override
  _RequestDeviceScreenState createState() => _RequestDeviceScreenState();
}

class _RequestDeviceScreenState extends State<RequestDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request Band")),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    "Request a new Band",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewRequestDevice(),
                      ),
                    );
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    "Previous Bands",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PreviousRequestDevice(),
                      ),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
}
