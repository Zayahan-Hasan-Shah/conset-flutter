import 'dart:io';

import 'package:conset/core/color_assets/color_assets.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';


void customSnackbar(BuildContext context, String title, String message, Color backgroundColor) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: backgroundColor,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
    duration: const Duration(seconds: 3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}


String? validator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Field can\'t be empty';
  }
  return null;
}

Future<void> sharedPrefInitialization() async {
  final pref = await SharedPreferences.getInstance();
  final isFirstRun = pref.getBool('firstRun');
  if (isFirstRun ?? true) {
    await pref.clear();
    await pref.setBool('firstRun', false);
  }
}

Future<void> permission() async {
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt; // SDK, example: 31

    await [
      Permission.notification,
      Permission.storage,
    ].request();
    if (sdkInt >= 30) {
      await Permission.manageExternalStorage.request();
    } else {
      await [
        Permission.manageExternalStorage,
      ].request();
    }
  } else if (Platform.isIOS) {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      final result = await Permission.notification.request();
      if (result.isGranted) {
        print('Notification permission granted');
      } else {
        print('Notification permission not granted');
      }
    }
  }
}

Widget buildShimmerEffect() {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Shimmer.fromColors(
          baseColor: ColorAssets.shimmerBaseColor!,
          highlightColor: ColorAssets.shimmerHighlightColor!,
          child: Container(
            width: double.infinity,
            height: 150,
            color: ColorAssets.whiteColor,
          ),
        ),
        SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 4, // Number of shimmer placeholders
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Shimmer.fromColors(
                baseColor: ColorAssets.shimmerBaseColor!,
                highlightColor: ColorAssets.shimmerHighlightColor!,
                child: Container(
                  width: double.infinity,
                  height: 80,
                  color: ColorAssets.whiteColor,
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}