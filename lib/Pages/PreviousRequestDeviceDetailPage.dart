import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PreviousRequestDeviceDetailPage extends StatefulWidget {
  final Map<String, dynamic> request;
  final String documentId; // Firestore document ID

  PreviousRequestDeviceDetailPage({required this.request, required this.documentId});

  @override
  _PreviousRequestDeviceDetailPageState createState() =>
      _PreviousRequestDeviceDetailPageState();
}

class _PreviousRequestDeviceDetailPageState extends State<PreviousRequestDeviceDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userEmail;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _bandIdController = TextEditingController();
  final TextEditingController _assignedByController = TextEditingController();

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
    _fromDateController.text = widget.request['fromDate'] ?? '';
    _toDateController.text = widget.request['toDate'] ?? '';
    _purposeController.text = widget.request['purpose'] ?? '';
    _statusController.text = widget.request['status'] ?? '';
    _bandIdController.text = widget.request['bandId'] ?? '';
    _assignedByController.text = userEmail ?? '';
  }

  Future<void> _updateRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.documentId)
          .update({
        'status': _statusController.text,
        'bandId': _bandIdController.text,
        'assignedBy': userEmail,
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
      appBar: AppBar(title: const Text("Request Details")),
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
                TextFormField(
                  controller: _fromDateController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "From Date/Time"),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _toDateController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "To Date/Time"),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _purposeController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Purpose of Request"),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _statusController.text.isNotEmpty ? _statusController.text : null,
                  decoration: InputDecoration(labelText: "Status"),
                  items: ["Assigned", "Pending", "Rejected", "Returned"]
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
                SizedBox(height: 16),
                TextFormField(
                  controller: _bandIdController,
                  decoration: InputDecoration(labelText: "Band ID"),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter Band ID" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _assignedByController,
                  decoration: InputDecoration(labelText: "Assigned By"),
                  readOnly: true,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _updateRequest,
                  child: _isSubmitting
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Update Request"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
