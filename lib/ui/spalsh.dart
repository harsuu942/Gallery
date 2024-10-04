import 'package:flutter/material.dart';
import '../base/utils/font_style.dart';
import 'package:gallery_app/base/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setStatusBar(); // Sets the status bar style for the splash screen
    Future.delayed(const Duration(seconds: 3), widget.onComplete); // Delay before calling onComplete callback

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Gallery APP',
          style: FontStyle.absurdWordSemiBoldTextColor_16,
        ),
      ),
    );
  }
}
