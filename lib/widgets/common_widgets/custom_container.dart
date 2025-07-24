import 'package:conset/core/color_assets/color_assets.dart';
import 'package:conset/widgets/common_widgets/title_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

class CustomContainer extends StatelessWidget {
  final String? mrNo;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? fullName;
  final String? sex;
  final String? birthDate;
  final String? nationality;
  final String? phone;
  final bool? isVIP;
  final List<String>? pdfUrls;
  CustomContainer({
    this.mrNo,
    this.firstName,
    this.middleName,
    this.lastName,
    this.fullName,
    this.sex,
    this.birthDate,
    this.nationality,
    this.phone,
    this.isVIP = false,
    this.pdfUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 14.h,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: ColorAssets.primaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(
              fullName != null ? fullName![0].toUpperCase() : 'N/A',
              style: TextStyle(fontSize: 20, color: ColorAssets.primaryColor),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(
                  title: fullName ?? 'N/A',
                  fontSize: 18.sp,
                  color: ColorAssets.whiteColor,
                ),
                SizedBox(height: 0.4.h),
                TitleText(
                  title: 'MR No: ${mrNo ?? 'N/A'}',
                  color: ColorAssets.whiteColor,
                  fontSize: 16.sp,
                ),
                TitleText(
                  title: 'Phone: ${phone ?? 'N/A'}',
                  color: ColorAssets.whiteColor,
                  fontSize: 16.sp,
                ),
                if (isVIP == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleText(
                        title: 'VIP Patient',
                        color: ColorAssets.whiteColor,
                        fontSize: 16.sp,
                      ),
                      Icon(Icons.star, color: Colors.yellow, size: 20),
                      SizedBox(width: 0.5.w),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
