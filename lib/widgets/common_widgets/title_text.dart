import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? weight;
  final Color? color;
  final TextAlign? textAlign;
  final bool? isUnderLine;
  final bool? isEllipse;

  const TitleText({
    Key? key,
    required this.title,
    this.style,
    this.fontSize,
    this.weight,
    this.color,
    this.isUnderLine,
    this.textAlign,
    this.isEllipse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      overflow: isEllipse == true ? TextOverflow.ellipsis : null,
      maxLines: isEllipse == true ? 1 : null,
      style: TextStyle(fontSize: fontSize, fontWeight: weight, color: color),
    );
  }
}
