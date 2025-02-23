import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  bool _isLoading = true;
  bool _isSubmitted = false;

  List<String> _bands = [];
  String? _selectedBand;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchBands();
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
      setState(() => _isLoading = false);
    }
  }

  Future<void> fetchBands() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firestore
          .collection('inventory')
          .doc('nDC9MyIkZgpvIlpiy9V2')
          .get();

      if (documentSnapshot.exists) {
        List<dynamic>? bandsArray = documentSnapshot.data()?['Bands'];
        if (bandsArray != null) {
          setState(() {
            _bands = bandsArray.map((band) => band.toString()).toList();
          });
        }
      } else {
        print("Document does not exist.");
      }
    } catch (e) {
      print("Error fetching bands: $e");
    }
  }

  void _handleNext() async {
    setState(() {
      _isSubmitted = true;
    });

    if (_selectedBand != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('testername', _nameController.text);
      await prefs.setString('testerdate', _dateController.text);
      await prefs.setString('testeruid', _selectedBand!);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewTestDetail()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a band UID")),
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
            ? Center(child: CircularProgressIndicator())
            : Column(
         // mainAxisAlignment: MainAxisAlignment.center,
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
                DropdownSearch<String>(
                  items: _bands,
                  selectedItem: _selectedBand,
                  onChanged: (value) {
                    setState(() {
                      _selectedBand = value;
                    });
                  },
                  dropdownBuilder: (context, selectedItem) => Text(
                    selectedItem ?? "Select UID",
                    style: TextStyle(fontSize: 16),
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  dropdownButtonProps: DropdownButtonProps(
                    icon: Icon(Icons.arrow_drop_down),
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorText: _isSubmitted && _selectedBand == null
                          ? "Please select a UID"
                          : null,
                    ),
                  ),
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
