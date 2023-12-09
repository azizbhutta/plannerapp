// import 'package:flutter/material.dart';
//
//
//
// class ProfileScreen extends StatelessWidget {
//   // Replace these values with your actual data
//   final String name = "John Doe";
//   final String email = "john.doe@example.com";
//   final String dob = "January 1, 1990"; // Format the date as needed
//   final String profilePictureUrl =
//       "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwallpapers.com%2Fcool-profile-pictures&psig=AOvVaw39aCVyz7I-4Bi90SeMSGSx&ust=1702218327881000&source=images&cd=vfe&ved=0CBIQjRxqFwoTCPCR1MnHgoMDFQAAAAAdAAAAABAE"; // Replace with the actual URL
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 60.0,
//               backgroundImage: NetworkImage(profilePictureUrl),
//             ),
//             const SizedBox(height: 16.0),
//             Text(
//               name,
//               style: const TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               email,
//               style: const TextStyle(
//                 fontSize: 16.0,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               "DOB: $dob",
//               style: const TextStyle(
//                 fontSize: 16.0,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> getUser() async {
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>> getProfileData() async {
    User? user = await getUser();
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await _firestore.collection('users').doc(user?.uid).get();

    return snapshot.data() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder(
        future: getProfileData(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            Map<String, dynamic> profileData = snapshot.data ?? {};
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(profileData['profileImageUrl'] ?? ''),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    profileData['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    profileData['email'] ?? '',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "DOB: ${profileData['dob'] ?? ''}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

