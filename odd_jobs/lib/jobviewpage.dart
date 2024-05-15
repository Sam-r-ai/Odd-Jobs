// Jyant Productions
// Justin Cheung
// Bryant Hernandez
// CSCI 467 Final Project
// OddJobs

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobViewPage extends StatelessWidget {
  final String documentId;
  final String jobTitle;
  final String imageUrl;
  final String description;
  final String pay;

  const JobViewPage({
    required this.documentId,
    required this.jobTitle,
    required this.imageUrl,
    required this.description,
    required this.pay,
    Key? key,
  }) : super(key: key);

  void _acceptJob(BuildContext context) async {
    // Update the pay field to TAKEN in Firestore
    await FirebaseFirestore.instance
        .collection('Jobs')
        .doc(documentId)
        .update({'Pay': 'TAKEN'});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job accepted!')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OddJobs'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(imageUrl),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  jobTitle,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 34),
              Center(
                child: Text(
                  'Pay: $pay',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _acceptJob(context),
                child: const Text('Accept'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Try to find a way to connect the message to 
                  // Firebase. How? 
                  // Connect to userID? 
                },
                child: const Text('Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}