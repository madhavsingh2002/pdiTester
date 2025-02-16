import 'package:flutter/material.dart';
class QuestionData {
  final String question;
  String? selectedOption;
  final TextEditingController remarksController = TextEditingController();

  QuestionData(this.question);
}
class QuestionWidget extends StatefulWidget {
  final QuestionData questionData;

  const QuestionWidget({Key? key, required this.questionData}) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.questionData.question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text("Pass"),
                value: "Pass",
                groupValue: widget.questionData.selectedOption,
                onChanged: (value) => setState(() {
                  widget.questionData.selectedOption = value;
                }),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text("Fail"),
                value: "Fail",
                groupValue: widget.questionData.selectedOption,
                onChanged: (value) => setState(() {
                  widget.questionData.selectedOption = value;
                }),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: widget.questionData.remarksController,
          decoration: InputDecoration(
            labelText: "Remarks (optional)",
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}