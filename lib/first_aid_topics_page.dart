import 'package:flutter/material.dart';

class FirstAidTopicsPage extends StatelessWidget {
  final List<Map<String, String>> topics = [
    {"title": "Burns", "subtitle": "Immediate steps and care guidelines"},
    {"title": "Cuts", "subtitle": "How to manage and dress cuts"},
    {"title": "Choking", "subtitle": "Steps to relieve choking hazards"},
    {"title": "CPR", "subtitle": "Learn how to perform CPR"},
    {"title": "Fractures", "subtitle": "How to assist fractures until help arrives"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("First Aid Topics")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search for first aid topics...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(topics[index]["title"]!),
                    subtitle: Text(topics[index]["subtitle"]!),
                    tileColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(Icons.health_and_safety),
                    onTap: () {},
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text("Back to Topics"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF019874), // Background color
                foregroundColor: Colors.white, // White text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // More rectangular with a lower borderRadius
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // More vertical padding
                minimumSize: Size(double.infinity, 50), // Make the button take up more width
              ),
            ),
          ],
        ),
      ),
    );
  }
}
