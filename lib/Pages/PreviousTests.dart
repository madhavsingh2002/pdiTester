import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'PreviousTestDetail.dart';

class Previoustests extends StatefulWidget {
  @override
  _PrevioustestsState createState() => _PrevioustestsState();
}

class _PrevioustestsState extends State<Previoustests> {
  late Stream<QuerySnapshot> _testsStream;
  bool _showPassedOnly = false;
  Map<String, dynamic>? userData;
  TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) {
        setState(() => _isLoading = false);
        return;
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('userRole')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          _initializeStream(); // Initialize stream based on role
        });
      } else {
        print("No user found.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _initializeStream() {
    if (userData?['role'] == 'Admin') {
      _testsStream = _firestore.collection('test_results').snapshots();
    } else {
      _testsStream = _firestore
          .collection('test_results')
          .where("role", isEqualTo: "User")
          .snapshots();
    }
    setState(() {}); // Refresh UI after initializing stream
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Previous Tests")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Tests"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search by UID",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = "";
                      _searchController.clear();
                    });
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
            SizedBox(height: 10),
            SwitchListTile(
              title: const Text("Show only passed tests"),
              value: _showPassedOnly,
              onChanged: (value) {
                setState(() {
                  _showPassedOnly = value;
                });
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _testsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No previous tests found."));
                  }

                  var filteredTests = snapshot.data!.docs.where((doc) {
                    Map<String, dynamic> data =
                    doc.data() as Map<String, dynamic>;
                    bool matchesPassFilter =
                        !_showPassedOnly || (data['finalRemark'] == 'Pass');
                    bool matchesSearchFilter = _searchQuery.isEmpty ||
                        (data['uid']
                            ?.toString()
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ??
                            false);
                    return matchesPassFilter && matchesSearchFilter;
                  }).toList();

                  if (filteredTests.isEmpty) {
                    return const Center(child: Text("No matching tests found."));
                  }

                  return ListView(
                    children: filteredTests.map((doc) {
                      Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            "Final Remark: ${data['finalRemark'] ?? 'N/A'}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name: ${data['name'] ?? 'N/A'}"),
                              Text("UID: ${data['uid'] ?? 'N/A'}"),
                              Text("Date: ${data['date'] ?? 'N/A'}"),
                            ],
                          ),
                          onTap: () {
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
          ],
        ),
      ),
    );
  }
}
