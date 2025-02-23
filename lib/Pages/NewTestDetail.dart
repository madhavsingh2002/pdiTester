import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/InfoTile.dart';
import '../Components/QuestionComp.dart';
import '../Components/QuestionList.dart';
import 'ResultsPage.dart';
class NewTestDetail extends StatefulWidget {
  @override
  _NewTestDetailState createState() => _NewTestDetailState();
}

class _NewTestDetailState extends State<NewTestDetail> {
  String _name = "";
  String _date = "";
  String _uid = "";
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
  void _submitAllAnswers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(responses: questionsList),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        "WALK BAND PDI CHECKLIST",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ), backgroundColor: Color(0xffffffff)),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xffffffff), // Set background color here
          padding: const EdgeInsets.all(16.0), // Optional padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              InfoTile(label: "Name", value: _name),
              InfoTile(label: "Date", value: _date),
              InfoTile(label: "UID", value: _uid),
              Text(
                "Note: Wear the bands and check alignment of bands before testing.",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff3C4142)),
              ),
              SizedBox(height: 16),
              ...questionsList.map((q) => QuestionWidget(questionData: q)).toList(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitAllAnswers,
                  child: Text("Submit All"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}