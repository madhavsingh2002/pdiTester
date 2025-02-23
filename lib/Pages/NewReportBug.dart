import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewReportBug extends StatefulWidget {
  @override
  _NewReportBugState createState() => _NewReportBugState();
}
class _NewReportBugState extends State<NewReportBug> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _explainController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  bool _isSubmitted = false;
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
        setState(() async {
          Map<String, dynamic> userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          _nameController.text = userData['name'] ?? "";
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userrole', userData['role'] ?? "");
          _dateController.text = DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.now());
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


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        String? userEmail = FirebaseAuth.instance.currentUser?.email;
        if (userEmail == null) {
          print("User not logged in");
          setState(() => _isLoading = false);
          return;
        }
        await _firestore.collection('Bugs').add({
          'name': _nameController.text,
          'email': userEmail,
          'submissionDate': _dateController.text,
          'explanation': _explainController.text,
          'status': "Pending",
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bug Reported successfully")),
        );
        _explainController.clear();
      } catch (e) {
        print("Error submitting request: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit request")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isSubmitted = true);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Bug")),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode:
              _isSubmitted ? AutovalidateMode.always : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: "Submission Date"),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _explainController,
                    decoration: InputDecoration(labelText: "Explain the Bug"),
                    validator: (value) => value!.isEmpty ? "Please enter purpose" : null,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
