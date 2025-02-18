import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
 import 'package:shared_preferences/shared_preferences.dart';

import 'NewTestDetail.dart';

class NewTestScreen extends StatefulWidget {
  @override
  _NewTestScreenState createState() => _NewTestScreenState();
}

class _NewTestScreenState extends State<NewTestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;
  bool _isLoading = true; // To track loading state
  bool _isSubmitted = false; // Track form submission state

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
        setState(() async{
          userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          _nameController.text = userData?['name'] ?? "";
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userrole', userData?['role'] ?? "");

          String formattedDate =
          DateFormat("dd MMM yyyy: hh:mm a").format(DateTime.now());
          _dateController.text = formattedDate;
        });
      } else {
        print("No user found.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      setState(() => _isLoading = false); // Stop loading indicator
    }
  }

  void _handleNext() async {
    setState(() {
      _isSubmitted = true; // Mark the form as submitted
    });
    String uid = _uidController.text.trim(); // Trim the input
    if (uid.isNotEmpty && (_formKey.currentState?.validate() ?? false)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('testername', _nameController.text);
      await prefs.setString('testerdate', _dateController.text);
      await prefs.setString('testeruid', _uidController.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewTestDetail()),
      );
    } else {
      // Show error message if UID is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("UID is mandatory...")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "WALK BAND PDI CHECKLIST",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              autovalidateMode: _isSubmitted
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
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
                    decoration: InputDecoration(labelText: "Date"),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _uidController,
                    decoration: InputDecoration(
                      labelText: "UID",
                      errorText: _isSubmitted &&
                          (_uidController.text.trim().isEmpty)
                          ? "Please enter UID"
                          : null,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleNext,
                    child: Text("Next"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
