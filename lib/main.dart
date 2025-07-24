import 'package:conset/app/myApp.dart';
import 'package:conset/utils/global.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefInitialization(); // Ensure preferences are ready before controllers
  await permission();
  runApp(const MyApp());
}


