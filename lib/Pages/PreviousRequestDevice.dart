import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'PreviousRequestDeviceDetailPage.dart';

class PreviousRequestDevice extends StatefulWidget {
  @override
  _PreviousRequestDeviceState createState() => _PreviousRequestDeviceState();
}

class _PreviousRequestDeviceState extends State<PreviousRequestDevice> {
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
      appBar: AppBar(title: const Text("All Requested Devices")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('requests')
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
                      Text("From: ${request['fromDate'] ?? 'N/A'}"),
                      Text("To: ${request['toDate'] ?? 'N/A'}"),
                      Text("Purpose: ${request['purpose'] ?? 'N/A'}"),
                      Text("Submitted: ${request['submissionDate'] ?? 'N/A'}"),
                      Text("Status: ${request['status'] ?? 'N/A'}"),
                      Text("Assigned by: ${request['assignedBy'] ?? ''}"),
                      Text("bandId: ${request['bandId'] ?? 'not assign Yet'}"),
                    ],
                  ),
                  onTap: () {
                    if (request['email'] == userEmail) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreviousRequestDeviceDetailPage(
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
