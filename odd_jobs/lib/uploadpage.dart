// Jyant Productions
// Justin Cheung
// Bryant Hernandez
// CSCI 467 Final Project
// OddJobs

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UploadPageWidget extends StatefulWidget {
  const UploadPageWidget({super.key});

  @override
  _UploadPageWidgetState createState() => _UploadPageWidgetState();
}

class _UploadPageWidgetState extends State<UploadPageWidget> {
  final TextEditingController _jobTitleTextController = TextEditingController();
  final FocusNode _jobTitleFocusNode = FocusNode();

  final TextEditingController _descriptionTextController = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();

  final TextEditingController _payTextController = TextEditingController();
  final FocusNode _payFocusNode = FocusNode();

  final TextEditingController _locationTextController = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _jobTitleTextController.dispose();
    _jobTitleFocusNode.dispose();
    _descriptionTextController.dispose();
    _descriptionFocusNode.dispose();
    _payTextController.dispose();
    _payFocusNode.dispose();
    _locationTextController.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = imageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> _uploadJob() async {
    final String jobTitle = _jobTitleTextController.text;
    final String description = _descriptionTextController.text;
    final String location = _locationTextController.text;
    final String pay = _payTextController.text;

    if (jobTitle.isNotEmpty && description.isNotEmpty && location.isNotEmpty && pay.isNotEmpty) {

      try {
        String? imageUrl;
        if (_selectedImage != null) {
          imageUrl = await _uploadImage(_selectedImage!);
        }

        await FirebaseFirestore.instance.collection('Jobs').add({
          'JobTitle': jobTitle,
          'Description': description,
          'Location': location,
          'Pay': pay,
          'Image': imageUrl ?? 'https://images.unsplash.com/photo-1639843906796-a2c47fc24330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxNHx8ZmlsZSUyMHVwbG9hZHxlbnwwfHx8fDE3MTU2MzU1ODV8MA&ixlib=rb-4.0.3&q=80&w=1080',
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job uploaded successfully!')),
        );

        // Clear the form fields
        _jobTitleTextController.clear();
        _descriptionTextController.clear();
        _locationTextController.clear();
        _payTextController.clear();
        setState(() {
          _selectedImage = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload job: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Upload Job',
                    style: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Container(
                  width: 270,
                  height: 59,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _jobTitleTextController,
                      focusNode: _jobTitleFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Job Title',
                        labelStyle: GoogleFonts.readexPro(),
                        hintStyle: GoogleFonts.readexPro(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLength: 25,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a job title';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 270,
                    height: 270,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              width: 300,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'https://images.unsplash.com/photo-1639843906796-a2c47fc24330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxNHx8ZmlsZSUyMHVwbG9hZHxlbnwwfHx8fDE3MTU2MzU1ODV8MA&ixlib=rb-4.0.3&q=80&w=1080',
                              width: 300,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Description',
                    style: GoogleFonts.readexPro(),
                  ),
                ),
                const SizedBox(height: 12.0),
                Container(
                  width: 270,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _descriptionTextController,
                      focusNode: _descriptionFocusNode,
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.readexPro(),
                        hintStyle: GoogleFonts.readexPro(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: GoogleFonts.readexPro(fontSize: 12),
                      maxLines: 13,
                      maxLength: 450,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Container(
                  width: 270,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: TextFormField(
                    controller: _locationTextController,
                    focusNode: _locationFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Location:',
                      labelStyle: GoogleFonts.readexPro(),
                      hintStyle: GoogleFonts.readexPro(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: GoogleFonts.readexPro(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12.0),
                Container(
                  width: 270,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'I will pay: ',
                          style: GoogleFonts.readexPro(),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _payTextController,
                            focusNode: _payFocusNode,
                            decoration: InputDecoration(
                              labelStyle: GoogleFonts.readexPro(),
                              hintStyle: GoogleFonts.readexPro(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            style: GoogleFonts.readexPro(),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _uploadJob,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
                      textStyle: GoogleFonts.readexPro(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text('Upload'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

