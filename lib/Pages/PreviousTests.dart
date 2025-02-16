import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'PreviousTestDetail.dart';

class Previoustests extends StatefulWidget {
  @override
  _PrevioustestsState createState() => _PrevioustestsState();
}

class _PrevioustestsState extends State<Previoustests> {
  final Stream<QuerySnapshot> _testsStream =
  FirebaseFirestore.instance.collection('test_results').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Tests"),
        // ✅ Back button is automatically added
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _testsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No previous tests found."));
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text("Final Remark: ${data['finalRemark'] ?? 'N/A'}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${data['name'] ?? 'N/A'}"),
                        Text("UID: ${data['uid'] ?? 'N/A'}"),
                        Text("Date: ${data['date'] ?? 'N/A'}"),
                      ],
                    ),
                    onTap: () {
                      // Navigate to detail screen with data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PrevioustestDetail(testData: data),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
