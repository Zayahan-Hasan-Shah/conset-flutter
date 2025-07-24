import 'package:conset/controllers/bottom_navigation_controller/bottom_navigation_controller.dart';
import 'package:conset/core/color_assets/color_assets.dart';
import 'package:conset/widgets/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final navstate = ref.watch(bottomNavigationProvider);
    final navController = ref.watch(bottomNavigationProvider.notifier);
    return Scaffold(
      appBar: CustomAppBar(
        text: navController.title,
        backgroundColor: ColorAssets.primaryColor,
      ),
      body: PopScope(canPop: false,child: navController.getScreen),

    );
  }


  Widget _buildBottomNavigationBar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 7.5.h + MediaQuery.of(context).padding.bottom,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: ColorAssets.primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(index: 0, icon: Icons.home, label: "Dashboard"),
            ],
          ),
        ),
        Positioned(
          bottom: 25,
          left: MediaQuery.of(context).size.width / 2 - 34,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 32, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bottomNavigationController = ref.read(bottomNavigationProvider.notifier);
    bool isSelected = bottomNavigationController.index == index;
    return InkWell(
      onTap: () {
        bottomNavigationController.setData(label, index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.7.h),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade300 : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
