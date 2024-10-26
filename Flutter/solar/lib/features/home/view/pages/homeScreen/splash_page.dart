import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key, required this.widget});
  Widget widget;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset(
          "assets/animations/Veshack.json",
        ),
      ),
      nextScreen: widget,
      duration: 2000,
      splashIconSize: 500,
    );
  }
}
