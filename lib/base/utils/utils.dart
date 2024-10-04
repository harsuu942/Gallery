import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Sets the status bar and navigation bar styles for the app.
void setStatusBar() {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
      ));
}

String formatNumber(double number) {
      if (number >= 1e9) {
            return '${(number / 1e9).toStringAsFixed(1)}B';
      } else if (number >= 1e6) {
            return '${(number / 1e6).toStringAsFixed(1)}M';
      } else if (number >= 1e3) {
            return '${(number / 1e3).toStringAsFixed(1)}K';
      } else {
            return number.toStringAsFixed(0);
      }
}


