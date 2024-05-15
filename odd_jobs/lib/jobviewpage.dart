import 'package:flutter/material.dart';

class JobViewPage extends StatelessWidget {
  final String jobTitle;
  final String imageUrl;
  final String description;
  final String pay;

  const JobViewPage({
    required this.jobTitle,
    required this.imageUrl,
    required this.description,
    required this.pay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OddJobs'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
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
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle accept job action
              },
              child: const Text('Accept'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Handle message action
              },
              child: const Text('Message'),
            ),
          ],
        ),
      ),
    );
  }
}
