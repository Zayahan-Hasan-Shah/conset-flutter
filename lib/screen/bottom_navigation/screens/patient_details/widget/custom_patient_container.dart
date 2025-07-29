import 'package:conset/core/color_assets/color_assets.dart';
import 'package:conset/widgets/common_widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomPatientContainer extends StatelessWidget {
  String title;
  String item;
  bool? isVIP;
  CustomPatientContainer({super.key, required this.title, required this.item, this.isVIP=false,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorAssets.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleText(
            title: title,
            fontSize: 16.sp,
            color: ColorAssets.primaryColor,
          ),
          TitleText(
            title: item,
            fontSize: 16.sp,
            color: ColorAssets.primaryColor,
          ),
        ],
      ),
    );
  }
}
