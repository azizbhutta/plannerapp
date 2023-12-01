// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../constants/image-strings.dart';
import 'login-screen.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  void dispose() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }


  void validate(){
    if (_formKey.currentState!.validate()){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen()));
    }else{
      return;
    }
  }

  void signup(){
    // setState(() {
    //   loading = true;
    // });
    // _auth.createUserWithEmailAndPassword(
    //     email: emailController.text.toString(),
    //     password: passwordController.text.toString()).then((value) {
    //   setState(() {
    //     loading = false;
    //   });
    // }).onError((error, stackTrace){
    //   Fluttertoast.showToast( gravity: ToastGravity.BOTTOM, backgroundColor: Colors.purple,msg: error.toString());
    // });
    // setState(() {
    //   loading = false;
    // });
  }
  // TODO PICK IMAGE

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // You can use the pickedFile for further processing here.
      if (kDebugMode) {
        print(pickedFile.path);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 320,
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
                                      labelText: "User Name",
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
                                      labelText: "Email",
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
                                    obscuringCharacter: '*',
                                    obscureText: true,
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
                                        Icons.lock,
                                        color: secondaryColor,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Password",
                                      labelStyle: TextStyle(color: tDorkColor),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty && value!.length < 5) {
                                        Fluttertoast.showToast( backgroundColor: Colors.purple,msg: "Enter a valid password");
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
                                    controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
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
                                        Icons.lock,
                                        color: secondaryColor,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "DOB",
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

                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text('Profile Image',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900),),
                                  IconButton(onPressed: openGallery,
                                      icon: Container(
                                          height:35,
                                          width:35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: Colors.white
                                          ),
                                          child: const Icon(Icons.camera_alt_outlined,color: Colors.black,)),)
                                ],
                              )
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
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignupScreenSecond()));
                      // if(_formKey.currentState!.validate()){
                      //   validate();
                      //   signup();
                      // }
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
    );
  }
}