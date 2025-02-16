import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final String question;
  final String option1;
  final String option2;

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.option1,
    required this.option2,
  }) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? selectedOption;
  TextEditingController remarksController = TextEditingController();

  void submitAnswer() {
    String remarks = remarksController.text.trim();
    String result =
        "Selected: ${selectedOption ?? "None"}\nRemarks: ${remarks.isNotEmpty ? remarks : "No remarks"}";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Your Response"),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        RadioListTile<String>(
          title: Text(widget.option1),
          value: widget.option1,
          groupValue: selectedOption,
          onChanged: (value) => setState(() => selectedOption = value),
        ),
        RadioListTile<String>(
          title: Text(widget.option2),
          value: widget.option2,
          groupValue: selectedOption,
          onChanged: (value) => setState(() => selectedOption = value),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: remarksController,
          decoration: InputDecoration(
            labelText: "Remarks (optional)",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            FocusScope.of(context).unfocus();
          },
        ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: submitAnswer,
            child: Text("Submit"),
          ),
        ),
      ],
    );
  }
}