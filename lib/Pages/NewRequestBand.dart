import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewRequestDevice extends StatefulWidget {
  @override
  _NewRequestDeviceState createState() => _NewRequestDeviceState();
}
class _NewRequestDeviceState extends State<NewRequestDevice> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
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

  Future<void> _selectDateTime(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        DateTime finalDateTime = DateTime(
            picked.year, picked.month, picked.day, time.hour, time.minute);
        controller.text = DateFormat("dd MMM yyyy, hh:mm a").format(finalDateTime);
      }
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
        await _firestore.collection('requests').add({
          'name': _nameController.text,
          'email': userEmail,
          'submissionDate': _dateController.text,
          'fromDate': _fromDateController.text,
          'toDate': _toDateController.text,
          'purpose': _purposeController.text,
          'status': "Pending",
          'assignedBy': "",
          'bandId': "",
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Request submitted successfully")),
        );
        _fromDateController.clear();
        _toDateController.clear();
        _purposeController.clear();
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
      appBar: AppBar(title: const Text("Request Device")),
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
                  controller: _fromDateController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "From Date/Time"),
                  onTap: () => _selectDateTime(_fromDateController),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _toDateController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "To Date/Time"),
                  onTap: () => _selectDateTime(_toDateController),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _purposeController,
                  decoration: InputDecoration(labelText: "Purpose of Request"),
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
