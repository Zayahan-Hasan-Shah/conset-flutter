import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:conset/core/color_assets/color_assets.dart';
import 'package:conset/utils/global.dart';
import 'package:conset/utils/text_asset.dart';
import 'package:flutter/widgets.dart';

class InternetService {
  late StreamSubscription<List<ConnectivityResult>> connectionStream;

  Future<void> checkConnectivity(BuildContext context) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      customSnackbar(
        context,
        noInternetTitle,
        noInternetMessage,
        ColorAssets.errorColor,
      );
    }
    connectionStream = Connectivity().onConnectivityChanged.listen((
      connection,
    ) {
      if (connection.contains(ConnectivityResult.none)) {
        customSnackbar(
          context,
          noInternetTitle,
          noInternetMessage,
          ColorAssets.errorColor,
        );
      }
    });
  }
}
