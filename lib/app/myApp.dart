import 'package:conset/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return ProviderScope(
          child: MaterialApp(
            title: 'Conset App',
            home: ProviderScope(
              child: MaterialApp.router(
                routerConfig: router,
                title: 'Conset App',
              ),
            ),
          ),
        );
      },
    );
  }
}
