import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/QuestionComp.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("New Test"),
          backgroundColor: Color(0xffffffff)
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "WALK BAND PDI CHECKLIST",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildInfoTile("Name", _name),
            _buildInfoTile("Date", _date),
            _buildInfoTile("UID", _uid),
            Text(
              "Note: Wear the bands and check alignment of bands before testing.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff3C4142),
              ),
            ),
            SizedBox(height: 16),
            QuestionWidget(
              question: "Fabric is properly sewed. (Check edges of the fabric)",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Hook and loop of the band are properly stitched",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Right band Turning on",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Left band Turning on",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Bands are held in proper orientation (band arrow pointing down)",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Right band LEDs working",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Left band LEDs working",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Right band both vibration motors are vibrating",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Left band both vibration motors are vibrating",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Bands went to open loop mode",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Band stopped vibrating when right band is turned to 90 degree",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Bands connect with app",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Right band magnitude is changing via app",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Left band magnitude is changing via app",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Frequency of the bands is changing via app",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "No vib/high frequency mode is working as intended",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Swing phase continuous mode is working as intended",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Swing phase burst mode is working as intended",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Stance phase continuous mode is working as intended",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Stance phase burst mode is working as intended",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Open loop mode is working as intended",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Football game is working without major lag",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Both positive and negative angles are working as intended",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Swing game is working without major lag",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Fish game is working without major lag",
              option1: "Pass",
              option2: "Fail",
            ),
            QuestionWidget(
              question: "Reset the magnitude and frequency",
              option1: "Pass",
              option2: "Fail",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
