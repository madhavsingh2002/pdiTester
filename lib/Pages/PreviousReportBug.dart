import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'PreviousReportBugDetailPage.dart';
import 'PreviousRequestDeviceDetailPage.dart';

class PreviousReportBug extends StatefulWidget {
  @override
  _PreviousReportBugState createState() => _PreviousReportBugState();
}

class _PreviousReportBugState extends State<PreviousReportBug> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userEmail;
  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Report Bug")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Bugs')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No requests found"));
          }

          var requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(request['name'] ?? 'Unknown User'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${request['email'] ?? 'N/A'}"),
                      Text("Explanation: ${request['explanation'] ?? 'N/A'}"),
                      Text("Submitted: ${request['submissionDate'] ?? 'N/A'}"),
                      Text("Status: ${request['status'] ?? 'N/A'}"),
                    ],
                  ),
                  onTap: () {
                    if (request['email'] == userEmail) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreviousReportBugDetailPage(
                            request: request,
                            documentId: requests[index].id,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
