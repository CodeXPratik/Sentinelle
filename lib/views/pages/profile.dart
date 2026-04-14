import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            CircleAvatar(radius: 40, backgroundColor: Colors.red, child: Icon(Icons.person, size: 40)),
            SizedBox(height: 10),
            Text('User Name', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ListTile(leading: Icon(Icons.phone), title: Text('Emergency Contacts')),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
          ],
        ),
      ),
    );
  }
}