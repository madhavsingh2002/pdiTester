import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/InfoTile.dart';
import '../Components/QuestionComp.dart';

class ResultsPage extends StatefulWidget {
  final List<QuestionData> responses;

  const ResultsPage({super.key, required this.responses});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  String _name = "";
  String _date = "";
  String _uid = "";
  String _finalRemark = "Pass"; // Default value for RadioListTile
  final TextEditingController _remarkController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('testername') ?? "N/A";
      _date = prefs.getString('testerdate') ?? "N/A";
      _uid = prefs.getString('testeruid') ?? "N/A";
    });
  }
  Future<void> _submitData() async {
    try {
      CollectionReference testResults = FirebaseFirestore.instance.collection('test_results');
      Map<String, dynamic> testData = {
        "name": _name,
        "date": _date,
        "uid": _uid,
        "finalRemark": _finalRemark,
        "additionalRemarks": _remarkController.text.trim(),
        "responses": widget.responses.map((q) {
          return {
            "question": q.question,
            "selectedOption": q.selectedOption ?? "None",
            "remarks": q.remarksController.text.trim().isNotEmpty
                ? q.remarksController.text.trim()
                : "No remarks",
          };
        }).toList(),
      };
      await testResults.add(testData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Test results submitted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit results: $e")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Responses")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Note: Change the mode to open loop before turning off the device.",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3C4142)),
              ),
              const Text(
                "Final Remarks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Pass"),
                      value: "Pass",
                      groupValue: _finalRemark,
                      onChanged: (value) {
                        setState(() {
                          _finalRemark = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Fail"),
                      value: "Fail",
                      groupValue: _finalRemark,
                      onChanged: (value) {
                        setState(() {
                          _finalRemark = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Text(
                "Signature",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              InfoTile(label: "Name", value: _name),
              const SizedBox(height: 10),
              Text(
                "Only applicable in case of fail:",
                style: TextStyle(fontSize: 14, color: Color(0xff3C4142)),
              ),
              // const Text(
              //   "Reviewed by:",
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // _buildInfoTile("Name", _name),
              SizedBox(height: 4),
              TextFormField(
                controller: _remarkController,
                decoration: InputDecoration(
                  labelText: "Remarks",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _submitData,
                  child: Text("Submit"),
                ),
              ),
              const Text(
                "Your Response:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...widget.responses.map((q) {
                return SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(q.question,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("Selected: ${q.selectedOption ?? "None"}"),
                          const SizedBox(height: 4),
                          Text(
                              "Remarks: ${q.remarksController.text.trim().isNotEmpty ? q.remarksController.text.trim() : "No remarks"}"),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
