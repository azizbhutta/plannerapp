import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../constants/image-strings.dart';
import 'login-screen.dart';



class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {



  File? selectedImage; // Track the selected image file
  DateTime? selectedDate;

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isPasswordVisible = false;

  // TODO: Add Firestore instance
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    dobController.clear();
    super.dispose();
  }

  // TODO: Add a function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      DateTime currentDate = DateTime.now();
      DateTime minimumBirthDate = currentDate.subtract(const Duration(days: 14 * 365));

      if (picked.isAfter(minimumBirthDate)) {
        Fluttertoast.showToast(
          backgroundColor: Colors.purple,
          msg: "You must be at least 14 years old to sign up.",
        );
      } else {
        setState(() {
          selectedDate = picked;
          dobController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
        });
      }
    }
  }

  // TODO: signup method to store Data in Firestore
  Future<void> signup() async {
    setState(() {
      loading = true;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      );

      // Calculate age based on selected date of birth
      DateTime currentDate = DateTime.now();
      DateTime minimumBirthDate = currentDate.subtract(const Duration(days: 14 * 365));

      if (selectedDate != null && selectedDate!.isAfter(minimumBirthDate)) {
        setState(() {
          loading = false;
        });

        Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.purple,
          msg: "You must be at least 14 years old to sign up.",
        );

        // Delete the created user as they don't meet the age requirement
        await userCredential.user!.delete();

        return;
      }

      // Upload profile image to Firebase Storage
      String userId = userCredential.user!.uid;
      Reference storageReference =
      FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');
      UploadTask uploadTask = storageReference.putFile(selectedImage!);
      await uploadTask.whenComplete(() async {
        // Get the download URL of the uploaded image
        String imageUrl = await storageReference.getDownloadURL();

        // Store user information in Cloud Firestore
        await _firestore.collection('users').doc(userId).set({
          'name': nameController.text,
          'email': emailController.text,
          'dob': dobController.text,
          'profileImageUrl': imageUrl,
        });

        // Update user profile with image URL
        await userCredential.user!.updateProfile(
            displayName: nameController.text, photoURL: imageUrl);

        setState(() {
          loading = false;
        });

        Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          msg: "Signup complete",
        );

        // Navigate to login screen only if user creation is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      });
    } catch (error) {
      setState(() {
        loading = false;
      });

      Fluttertoast.showToast(
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.purple,
        msg: error.toString(),
      );
    }
  }


  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Handle the back button press here
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
          // Return true to allow the pop, or false to prevent it.
          return false;
        },
      child: Scaffold(
        body: Container(
          color: primaryColor,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo here
                  const Image(image: AssetImage(signUpImage),
                    height: 100,
                    width: 100,
                  ),
                  Text(
                    'Sign Up',
                    style: GoogleFonts.indieFlower(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Text(
                    'Please signup to continue using our app',
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
                    height: 330,
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
                                      left: 20, right: 20, bottom: 2, top: 20),
                                  child: SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      controller: nameController,
                                      keyboardType: TextInputType.text,
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
                                          Icons.person,
                                          color: secondaryColor,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'User Name',
                                        labelStyle: TextStyle(color: tDorkColor),
                                      ),
                                      validator: (value){
                                        if(value!.isEmpty){
                                          Fluttertoast.showToast(backgroundColor: Colors.purple,msg: "please provide your name");
                                        }
                                        return null ;
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 2, top: 10),
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
                                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 2, top: 10),
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
                                        labelStyle: const TextStyle(color: tDorkColor), // Change to your preferred color
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 2, top: 10),
                                  child: SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      controller: dobController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      cursorColor: tDorkColor,
                                      onTap: () => _selectDate(context),
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
                                          Icons.calendar_month,
                                          color: secondaryColor,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "DOB",
                                        labelStyle: TextStyle(color: tDorkColor),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty && value!.length < 5) {
                                          Fluttertoast.showToast( backgroundColor: Colors.purple,msg: "Enter a valid DOB");
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text('Profile Image', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                                    const SizedBox(
                                      width: 140,
                                    ),
                                    Stack(
                                      children: [
                                        InkWell(
                                          onTap: openGallery,
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: secondaryColor,
                                            ),
                                            child: const Icon(Icons.camera_alt_outlined, color: Colors.black),
                                          ),
                                        ),
                                        if (selectedImage != null)
                                          Positioned.fill(
                                            child: ClipOval(
                                              child: Image.file(
                                                selectedImage!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
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
                        if (_formKey.currentState!.validate()) {
                          // Validate the form
                          if (selectedImage != null) {
                            // Image is selected, proceed with signup
                            signup();
                          } else {
                            Fluttertoast.showToast(backgroundColor: Colors.purple, msg: "Please select a profile image");
                          }
                        }
                      },

                      child: loading ? const CircularProgressIndicator(strokeWidth: 3,color: Colors.white,):
                      const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 17,color: tDorkColor),
                      )),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have account?',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          'Log In',
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
    );
  }
}



