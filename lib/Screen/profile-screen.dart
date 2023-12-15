//
//
//
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'editprofile-screen.dart';
// import 'task-screen.dart';
//
//
//
// class ProfileScreen extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<User?> getUser() async {
//     return _auth.currentUser;
//   }
//
//   Future<Map<String, dynamic>> getProfileData() async {
//     User? user = await getUser();
//     DocumentSnapshot<Map<String, dynamic>> snapshot =
//     await _firestore.collection('users').doc(user?.uid).get();
//
//     return snapshot.data() ?? {};
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           // Always return false to prevent going back
//           return Future.value(false);
//         },
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pushReplacement(context,
//                   MaterialPageRoute(builder: (context) =>  TaskListScreen()));
//             },
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             ),
//           ),
//           centerTitle: true,
//           title: const Text('Profile',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//           backgroundColor: Colors.redAccent,
//         ),
//         body: FutureBuilder(
//           future: getProfileData(),
//           builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text("Error: ${snapshot.error}");
//             } else {
//               Map<String, dynamic> profileData = snapshot.data ?? {};
//               return Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 60.0,
//                         backgroundImage: NetworkImage(profileData['profileImageUrl'] ?? ''),
//                       ),
//                       const SizedBox(height: 20.0),
//                       Text(
//                         profileData['name'] ?? '',
//                         style: const TextStyle(
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
//                       Text(
//                         profileData['email'] ?? '',
//                         style: const TextStyle(
//                           fontSize: 16.0,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
//                       Text(
//                         "DOB: ${profileData['dob'] ?? ''}",
//                         style: const TextStyle(
//                           fontSize: 16.0,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'task-screen.dart';
//
// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final ImagePicker _imagePicker = ImagePicker();
//
//   User? _user; // Change: initialize as nullable
//   late Map<String, dynamic> _profileData;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     _user = await getUser();
//     _profileData = await getProfileData();
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   Future<User?> getUser() async {
//     return _auth.currentUser;
//   }
//
//   Future<Map<String, dynamic>> getProfileData() async {
//     User? user = await getUser();
//     DocumentSnapshot<Map<String, dynamic>> snapshot =
//     await _firestore.collection('users').doc(user?.uid).get();
//
//     return snapshot.data() ?? {};
//   }
//
//   Future<void> _pickImageAndUpload(BuildContext context) async {
//     final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null && _user != null) { // Check if _user is not null
//       File imageFile = File(pickedFile.path);
//
//       String imagePath = 'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
//       UploadTask task = _storage.ref().child(imagePath).putFile(imageFile);
//       TaskSnapshot taskSnapshot = await task.whenComplete(() => null);
//       String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//
//       await _firestore.collection('users').doc(_user?.uid).update({
//         'profileImageUrl': downloadUrl,
//       });
//
//       await _loadData();
//     } else {
//       // Handle error or user cancellation
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return Future.value(false);
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                   context, MaterialPageRoute(builder: (context) => TaskListScreen()));
//             },
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             ),
//           ),
//           centerTitle: true,
//           title: const Text('Profile',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//           backgroundColor: Colors.redAccent,
//         ),
//         body: _user != null
//             ? SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 60.0,
//                         backgroundImage: NetworkImage(_profileData['profileImageUrl'] ?? ''),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: GestureDetector(
//                           onTap: () => _pickImageAndUpload(context),
//                           child: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             decoration: const BoxDecoration(
//                               color: Colors.redAccent,
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.camera_alt,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20.0),
//                   Text(
//                     _profileData['name'] ?? '',
//                     style: const TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8.0),
//                   Text(
//                     _profileData['email'] ?? '',
//                     style: const TextStyle(
//                       fontSize: 16.0,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 8.0),
//                   Text(
//                     "DOB: ${_profileData['dob'] ?? ''}",
//                     style: const TextStyle(
//                       fontSize: 16.0,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         )
//             : const CircularProgressIndicator(),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'editprofile-screen.dart';
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

    final pickedFile =
    await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && _user != null) {
      File imageFile = File(pickedFile.path);

      String imagePath =
          'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask task =
      _storage.ref().child(imagePath).putFile(imageFile);
      TaskSnapshot taskSnapshot = await task.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await _firestore.collection('users').doc(_user?.uid).update({
        'profileImageUrl': downloadUrl,
      });

      await _loadData();

      setState(() {
        _isUpdatingProfileImage = false;
      });
    } else {
      setState(() {
        _isUpdatingProfileImage = false;
      });
      // Handle error or user cancellation
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
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
                      _isUpdatingProfileImage
                          ? CircularProgressIndicator()
                          : CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(_profileData['profileImageUrl'] ?? ''),
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
                  Text(
                    _profileData['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _profileData['email'] ?? '',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "DOB: ${_profileData['dob'] ?? ''}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
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




