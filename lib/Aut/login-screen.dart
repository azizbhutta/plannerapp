import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plannerapp/Aut/signup-screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screen/task-screen.dart';
import '../constants/colors.dart';
import '../constants/image-strings.dart';
import 'package:firebase_auth/firebase_auth.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  FirebaseAuth auth = FirebaseAuth.instance;
  bool isPasswordVisible = false;



  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool loggedIn = preferences.getBool("loggedIn") ?? false;

    if (loggedIn) {
      // If the user is already logged in, navigate to the task screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskListScreen()),
      );
    }
  }

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }


  void login() {
    setState(() {
      loading = true;
    });
    auth
        .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text.toString())
        .then((value) {
      // Save login state in shared preferences
      saveLoginStatus();

      Fluttertoast.showToast(
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.purple,
        msg: value.user!.email.toString(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskListScreen()),
      );

      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Fluttertoast.showToast(
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.purple,
        msg: error.toString(),
      );
      setState(() {
        loading = false;
      });
    });
  }

  void saveLoginStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("loggedIn", true);
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async {
      SystemNavigator.pop();
      // Return true to allow the pop, or false to prevent it.
      return false;

    },
      child: Scaffold(
        body: Container(
          color: primaryColor,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // logo here
                     const Image(image: AssetImage(tLoginImage),
                      height: 120,
                      width: 120,
                    ),
                    Text(
                      'Log In Now',
                      style: GoogleFonts.indieFlower(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                    ),
                    Text(
                      'Please login to continue using our app',
                      style: GoogleFonts.indieFlower(
                        textStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                            // height: 1.5,
                            fontSize: 15),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 170,
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 8, top: 25),
                                    child: SizedBox(
                                      height: 50,
                                      child: TextFormField(
                                        controller: emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        cursorColor: tDorkColor,
                                        decoration: const InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(10))),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(10))),
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: secondaryColor,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: "Email",
                                          labelStyle: TextStyle(color: tDorkColor),
                                        ),
                                        validator: (value){
                                          if(value!.isEmpty){
                                            Fluttertoast.showToast(backgroundColor: Colors.purple,msg: "please provide your email");
                                          }
                                          return null ;
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 6, top: 5),
                                    child: SizedBox(
                                      height: 50,
                                      child: TextFormField(
                                        controller: passwordController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        obscureText: !isPasswordVisible,
                                        cursorColor: Colors.blue, // Change to your preferred color
                                        decoration: InputDecoration(
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: secondaryColor, // Change to your preferred color
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isPasswordVisible = !isPasswordVisible;
                                              });
                                            },
                                            icon: Icon(
                                              isPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: secondaryColor, // Change to your preferred color
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: "Password",
                                          labelStyle: TextStyle(color: tDorkColor), // Change to your preferred color
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty || value.length < 5) {
                                            Fluttertoast.showToast(
                                              backgroundColor: Colors.purple,
                                              msg: "Enter a valid password",
                                            );
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    // this is button
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            backgroundColor: secondaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width / 3.3,
                                vertical: 10)
                        ),
                        onPressed: () {
                          loading = loading;
                          if(_formKey.currentState!.validate()){
                            login();
                          }
                        },
                        child: const Text(
                          'Log in!',
                          style: TextStyle(fontSize: 17,color: tDorkColor),
                        )), //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You have\'t any account?',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupScreen()));
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


