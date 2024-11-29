
import 'package:flutter/material.dart';

class CurvedGradientButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onTap;
  final Widget child;

  CurvedGradientButton({
    required this.width,
    required this.height,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Center(child: child),
      ),
    );
  }
}