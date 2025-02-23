import 'package:flutter/material.dart';
import 'package:pditester/Pages/PreviousTests.dart';
import 'New_Test.dart';
class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}
class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Band")),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    "New Test",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewTestScreen(),
                      ),
                    );
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    "Previous Tests Band",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Previoustests(),
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
