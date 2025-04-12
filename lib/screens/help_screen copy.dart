// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How can we help you?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.info, color: Colors.blueAccent),
              title: Text("Getting Started"),
              onTap: () {
                // Navigate to a more detailed help page
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.green),
              title: Text("Account Settings"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.orange),
              title: Text("Privacy & Security"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.contact_support, color: Colors.red),
              title: Text("Contact Support"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
