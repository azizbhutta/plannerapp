import 'dart:ffi';

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String hintText;
  IconData icon;
  Color iconColor;
  bool obscureText;
  final TextEditingController controller;

  MyTextField(
      {Key? key,
        required this.hintText,
        required this.icon,
        required this.iconColor,
        required this.obscureText,
        required this.controller,
      })
      : super(key: key);
  // MyTextField( { required String hintText, required IconData icon, required Color iconColor});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            color: iconColor,
          ),
          hintStyle: const TextStyle(color: Colors.white),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ))),
    );
  }
}