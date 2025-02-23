import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PreviousReportBugDetailPage extends StatefulWidget {
  final Map<String, dynamic> request;
  final String documentId;
  PreviousReportBugDetailPage({required this.request, required this.documentId});
  @override
  _PreviousReportBugDetailPageState createState() => _PreviousReportBugDetailPageState();
}
class _PreviousReportBugDetailPageState extends State<PreviousReportBugDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userEmail;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _explainController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email;
    _initializeFields();
  }

  void _initializeFields() {
    _nameController.text = widget.request['name'] ?? '';
    _dateController.text = widget.request['submissionDate'] ?? '';
    _explainController.text = widget.request['explanation'] ?? '';
    _statusController.text = widget.request['status'] ?? '';
  }

  Future<void> _updateRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('Bugs')
          .doc(widget.documentId)
          .update({
        'status': _statusController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request updated successfully!")),
      );

      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating request: $e")),
      );
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reported Bug Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                SizedBox(height: 16),
                TextFormField(
                  controller: _explainController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Explanation"),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _statusController.text.isNotEmpty ? _statusController.text : null,
                  decoration: InputDecoration(labelText: "Status"),
                  items: ["Resolved", "Pending", "In Progress"]
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _statusController.text = value!;
                    });
                  },
                  validator: (value) => value == null ? "Please select a status" : null,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _updateRequest,
                  child: _isSubmitting
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Update Bug Report"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
