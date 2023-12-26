import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plannerapp/Aut/login-screen.dart';

import 'Screen/home-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyA0rc8rCeJiEnN36THflcVWkDBiro2CzgM',
            appId: '1:758640598581:web:94cedf9a48c071e0bb5b7c',
            messagingSenderId: 'G-B4G98CLEBG',
            projectId: 'planner-app-9d4a9',
          storageBucket: 'planner-app-9d4a9.appspot.com',
        ),);
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
