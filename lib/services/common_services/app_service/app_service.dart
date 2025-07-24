import 'package:flutter/cupertino.dart';

class AppSize {
  static SizedBox vrtSpace(double height) => SizedBox(height: height);

  static SizedBox hrzSpace(double width) => SizedBox(width: width);

  static SizedBox noSpace() => const SizedBox.shrink();

  static Spacer spacer() => const Spacer();
}
