import 'package:flutter/material.dart';
import 'package:tirecheck/homepage.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: LottieBuilder.asset(
          "assets/splash/splash4.json",
          width: MediaQuery.of(context).size.width * 1, // Adjust the width as needed
          height: MediaQuery.of(context).size.height * 1, // Adjust the height as needed
        ),
      ),
      nextScreen: const HomePage(title: "Tire Check AI"),
      splashIconSize: 600,
      backgroundColor: Color.fromARGB(255, 232, 223, 244),
      animationDuration: Duration(milliseconds: 100),
    );
  }
}