import 'package:flutter/material.dart';
import 'package:pditester/Pages/PreviousReportBug.dart';
import 'NewReportBug.dart';
class ReportBugScreen extends StatefulWidget {
  @override
  _ReportBugScreenState createState() => _ReportBugScreenState();
}
class _ReportBugScreenState extends State<ReportBugScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Bug")),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    "Report a new Bug",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewReportBug(),
                      ),
                    );
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    "Previous Reported Bugs",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PreviousReportBug(),
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
