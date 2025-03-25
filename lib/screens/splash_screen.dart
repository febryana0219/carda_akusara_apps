import 'package:app_mobile/core/app/app_router.dart';
import 'package:app_mobile/core/storage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Storage storage = Storage();
  String? accessToken;
  String? refreshToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        Future.wait([
          storage.getStorage(storage.accessToken),
          storage.getStorage(storage.refreshToken)
        ]).then((value) {
          accessToken = value[0];
          refreshToken = value[1];

          if (accessToken != null && refreshToken != null) {
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouter.category, (Route<dynamic> route) => false);
            }
          } else {
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouter.login, (Route<dynamic> route) => false);
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
