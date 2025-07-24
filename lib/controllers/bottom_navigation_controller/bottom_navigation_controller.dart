import 'package:conset/controllers/bottom_navigation_controller/bottom_navigation_state.dart';
import 'package:conset/screen/bottom_navigation/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';

class BottomNavigationNotifier extends StateNotifier<BottomNavigationState> {
  BottomNavigationNotifier() : super(BottomNavigationState(pageTitle: '', pageIndex: 0));

  void setData(String pageTitle, int pageIndex){  
    state = state.copyWith(pageTitle: pageTitle, pageIndex: pageIndex);
  } 

  int get index {
    return state.pageIndex;
  }

  Widget get getScreen {
    switch (state.pageIndex) {
      case 0:
        return const DashboardScreen();
      default:
        return const DashboardScreen();
    }
  }

  String get title {
    switch(state.pageIndex) {
      case 0:
        return 'Dashboard';
      default:
        return 'Dashboard';
    }
  }

}

final bottomNavigationProvider =
    StateNotifierProvider<BottomNavigationNotifier, BottomNavigationState>((ref) => BottomNavigationNotifier());