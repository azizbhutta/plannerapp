import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  DateTime? selectedDate;


  // TODO: Add a function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Form fields for editing profile data
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: dobController,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(labelText: 'Date of Birth'),
            ),
            // Button to submit edited data
            ElevatedButton(
              onPressed: () {
                updateProfileData();
                Navigator.pop(
                    context); // Go back to the profile screen after editing
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void updateProfileData() async {
    User? user = await FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.updateProfile(displayName: nameController.text);
        await FirebaseFirestore.instance.collection('users')
            .doc(user.uid)
            .update({
          'name': nameController.text,
          'email': emailController.text,
          'dob': dobController.text,
        });
      } catch (error) {
        print("Error updating profile: $error");
      }
    }
  }
}

