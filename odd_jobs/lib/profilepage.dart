import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({super.key});

  @override
  _ProfilePageWidgetState createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://picsum.photos/200', // Replace with your profile image URL
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Your Name',
                style: GoogleFonts.readexPro(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'your.email@example.com',
                style: GoogleFonts.readexPro(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // Implement your logout logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logging out...')),
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
