import 'package:flutter/material.dart';

class CurvedGradientTextField extends StatelessWidget {
  final double width;
  final double height;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  CurvedGradientTextField({
    required this.width,
    required this.height,
    required this.hintText,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
