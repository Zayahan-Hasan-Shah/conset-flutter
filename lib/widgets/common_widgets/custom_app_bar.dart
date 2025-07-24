import 'dart:io';

import 'package:conset/core/color_assets/color_assets.dart';
import 'package:conset/widgets/common_widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class CustomAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final String text;
  final Color backgroundColor;
  final bool? isBackButtonEnable;

  const CustomAppBar(
      {super.key, this.backgroundColor = ColorAssets.primaryColor, required this.text, this.isBackButtonEnable});

  @override
  ConsumerState createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(40);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: widget.isBackButtonEnable ?? false,
      backgroundColor: widget.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      title: TitleText(
        title: widget.text,
        fontSize: 17.sp,
        weight: FontWeight.w500,
        color: ColorAssets.whiteColor,
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Are you sure you want to logout?",
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Add logout functionality here
                        Navigator.of(context).pop();
                        exit(0);
                      },
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
