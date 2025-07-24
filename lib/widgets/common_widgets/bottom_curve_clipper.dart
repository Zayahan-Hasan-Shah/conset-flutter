import 'package:flutter/cupertino.dart';

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50); // Start slightly above the bottom-left corner
    path.quadraticBezierTo(
      size.width / 2, size.height, // Control point at the bottom center
      size.width, size.height - 50, // Slightly above the bottom-right corner
    );
    path.lineTo(size.width, 0); // Top-right corner
    path.lineTo(0, 0); // Top-left corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
