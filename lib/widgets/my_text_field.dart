import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final String validTitle;
  final bool obscureText;
  final TextEditingController controller;
  const MyTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    required this.validTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black, width: 0.2)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return validTitle;
            }
          },
          controller: controller,
          obscureText: obscureText,
          decoration:
              InputDecoration(border: InputBorder.none, hintText: hintText),
        ),
      ),
    );
  }
}
