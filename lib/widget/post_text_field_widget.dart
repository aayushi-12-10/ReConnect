import 'package:flutter/material.dart';

class PostTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const PostTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: Colors.grey[900],
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
    );
  }
}
