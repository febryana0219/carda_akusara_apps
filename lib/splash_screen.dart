import 'package:flutter/material.dart';
import 'home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulate splash screen delay of 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF8055FE),
      body: Stack(
        children: [
          // Decoration - Top Left
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 100,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          // Decoration - Bottom Right
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 150,
              width: 75,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                ),
              ),
            ),
          ),
          // Background Decoration Image
          Center(
            child: Image.asset(
              'assets/images/decoration_white.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover, // Mengisi layar
            ),
          ),
          // Logo Aplikasi
          Center(
            child: Image.asset(
              'assets/images/app_logo.png',
              height: 150,
              width: 150,
            ),
          ),
        ],
      ),
    );
  }
}
