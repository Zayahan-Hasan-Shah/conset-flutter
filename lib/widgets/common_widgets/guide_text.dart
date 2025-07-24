import 'package:conset/core/color_assets/color_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class GuideText extends StatelessWidget {
  final String text1;
  final String text2;
  final VoidCallback ontap; // Corrected this line
  const GuideText({
    required this.text1,
    required this.text2,
    required this.ontap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: RichText(
        text: TextSpan(
          text: text1,
          style: TextStyle(color: ColorAssets.blackColor),
          children: <TextSpan>[
            TextSpan(text: text2, style: TextStyle(fontWeight: FontWeight.normal, color: ColorAssets.primaryColor)),
          ],
        ),
      ),
    );
  }
}
