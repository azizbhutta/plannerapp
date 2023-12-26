import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'task-screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  User? _user;
  late Map<String, dynamic> _profileData;
  bool _isUpdatingProfileImage = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _user = await getUser();
    _profileData = await getProfileData();
    if (mounted) {
      setState(() {});
    }
  }

  Future<User?> getUser() async {
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>> getProfileData() async {
    User? user = await getUser();
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await _firestore.collection('users').doc(user?.uid).get();

    return snapshot.data() ?? {};
  }

  Future<void> _pickImageAndUpload(BuildContext context) async {
    setState(() {
      _isUpdatingProfileImage = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.grey,
            ),
          ),
          AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Updating Profile Image...'),
                SizedBox(height: 16.0),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );

    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && _user != null) {
      File imageFile = File(pickedFile.path);

      String imagePath =
          'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask task = _storage.ref().child(imagePath).putFile(imageFile);
      TaskSnapshot taskSnapshot = await task.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await _firestore.collection('users').doc(_user?.uid).update({
        'profileImageUrl': downloadUrl,
      });

      await _loadData();

      Navigator.pop(context); // Close the progress dialog

      setState(() {
        _isUpdatingProfileImage = false;
      });
    } else {
      Navigator.pop(context); // Close the progress dialog

      setState(() {
        _isUpdatingProfileImage = false;
      });
      // Handle error or user cancellation
    }
  }

  void _showEditDialog(String field, String currentValue) {
    TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (field == 'password') {
                await _updatePassword(controller.text);
              } else {
                // Update the data in the database
                await _updateField(field, controller.text);
              }

              // Reload the profile data
              await _loadData();

              Navigator.pop(context); // Close the dialog
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateField(String field, String value) async {
    await _firestore.collection('users').doc(_user?.uid).update({
      field: value,
    });
  }

  Future<void> _updatePassword(String newPassword) async {
    try {
      await _user?.updatePassword(newPassword);
      Fluttertoast.showToast(backgroundColor: Colors.purple, msg: "Password updated successfully");

      // Since the password is updated, sign out and sign in again to refresh the session
      await _auth.signOut();
      await _auth.signInWithEmailAndPassword(
        email: _user!.email!,
        password: newPassword,
      );

      // Reload the profile data after updating the password
      await _loadData();
      Fluttertoast.showToast(backgroundColor: Colors.purple, msg: "Password update failed: $e");
    } catch (e) {
      print("Password update failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskListScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => TaskListScreen()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: const Text('Profile',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.redAccent,
        ),
        body: _user != null
            ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                           CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(
                            _profileData['profileImageUrl'] ?? ''),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _pickImageAndUpload(context),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30),
                    child: Row(
                      children: [
                        const Text(
                          'Name: ',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          _profileData['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(
                          width: 150,
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog('name', _profileData['name']);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30),
                    child: Row(
                      children: [
                        const Text(
                          'Email: ',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          _profileData['email'] ?? '',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30),
                    child: Row(
                      children: [
                        const Text(
                          'DOB: ',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          _profileData['dob'] ?? '',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(
                          width: 80
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog('dob', _profileData['dob']);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30),
                    child: Row(
                      children: [
                        const Text(
                          'Password: ',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        const Text(
                          '******', // Replace with password data
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog('password', ''); // You may need to handle password editing securely
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}





