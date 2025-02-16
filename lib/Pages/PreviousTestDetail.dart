import 'package:flutter/material.dart';

class PrevioustestDetail extends StatelessWidget {
  final Map<String, dynamic> testData;

  const PrevioustestDetail({Key? key, required this.testData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic>? responses = testData['responses']; // Extract responses

    return Scaffold(
      appBar: AppBar(title: const Text("Test Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Display Basic Test Details
              Text("Final Remark: ${testData['finalRemark'] ?? 'N/A'}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Text("Name: ${testData['name'] ?? 'N/A'}"),
              Text("UID: ${testData['uid'] ?? 'N/A'}"),
              Text("Date: ${testData['date'] ?? 'N/A'}"),
              const SizedBox(height: 16),
              const Divider(),

              // ✅ Display Responses
              Text("Responses:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // ✅ If responses exist, display them in a ListView
              if (responses != null && responses.isNotEmpty)
                Column(
                  children: responses.map<Widget>((response) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(response['question'] ?? 'No Question', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Remarks: ${response['remarks'] ?? 'No Remarks'}"),
                            Text("Selected Option: ${response['selectedOption'] ?? 'N/A'}"),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                const Center(child: Text("No responses available.")),
            ],
          ),
        ),
      ),
    );
  }
}
