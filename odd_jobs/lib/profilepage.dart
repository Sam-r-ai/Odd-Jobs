// Jyant Productions
// Justin Cheung
// Bryant Hernandez
// CSCI 467 Final Project
// OddJobs

import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({super.key});

  @override
  _ProfilePageWidgetState createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  File? _image; 
  final ImagePicker _picker = ImagePicker();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path); 
      });
    }
  }

  Future<void> _saveDataToFirestore() async {
    var profileData = {
      'Address': _addressController.text,
      'Bio': _bioController.text,
      'City': _cityController.text,
      'Email': _emailController.text,
      'First name': _firstNameController.text,
      'Last name': _lastNameController.text,
      'Phone number': int.tryParse(_phoneController.text) ?? 0,
      'ProfilePictureURL': _image?.path ?? 'NULL',
      'Skills': _skillsController.text,
      'State': _stateController.text,
      'Zip Code': int.tryParse(_zipController.text) ?? 0,
      'Contacts': ['Bryant'] // Everyone gets free connect with Bryant who uses this app
                             // If you don't have my phone number, you don't know me well enough 
                             // To have a problem with me.
    };

    try {
      await FirebaseFirestore.instance.collection('profiles').add(profileData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
    }
  }

  Future<User?> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  void _signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    print("User Signed Out");
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _skillsController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider profileImage = _image != null ? FileImage(_image!) as ImageProvider : const NetworkImage('https://picsum.photos/200') as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: profileImage,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _takePicture,
                child: const Text('Take Picture'),
              ),
              TextFormField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'First Name')),
              TextFormField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Last Name')),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Address')),
              TextFormField(controller: _bioController, decoration: const InputDecoration(labelText: 'Bio')),
              TextFormField(controller: _cityController, decoration: const InputDecoration(labelText: 'City')),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
              TextFormField(controller: _skillsController, decoration: const InputDecoration(labelText: 'Skills')),
              TextFormField(controller: _stateController, decoration: const InputDecoration(labelText: 'State')),
              TextFormField(controller: _zipController, decoration: const InputDecoration(labelText: 'Zip Code')),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  _handleSignIn().then((User? user) {
                    if (user != null) {
                      print('Signed in as ${user.displayName}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Signed in as ${user.displayName}')),
                      );
                    }
                  });
                },
                child: const Text('Sign in with Google'),
              ),
              ElevatedButton(
                onPressed: _signOut,
                child: const Text('Sign Out'),
              ),
              ElevatedButton(
                onPressed: _saveDataToFirestore,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
