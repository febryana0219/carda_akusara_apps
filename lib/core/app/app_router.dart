import 'package:app_mobile/screens/category_screen.dart';
import 'package:app_mobile/screens/login_screen.dart';
import 'package:app_mobile/screens/materi_screen.dart';
import 'package:app_mobile/screens/profile_screen.dart';
import 'package:app_mobile/screens/quiz_screen.dart';
import 'package:app_mobile/screens/registration_screen.dart';
import 'package:app_mobile/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String splash = "/splash-screen";
  static const String registration = "/registration-screen";
  static const String login = "/login-screen";
  static const String category = "/category-screen";
  static const String quiz = "/quiz-screen";
  static const String profile = "/profile-screen";
  static const String materi = "/materi-screen";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: ((context) => SplashScreen()));
      case registration:
        return MaterialPageRoute(builder: ((context) => RegistrationScreen()));
      case login:
        return MaterialPageRoute(builder: ((context) => LoginScreen()));
      case category:
        return MaterialPageRoute(builder: (context) => CategoryScreen());
      case materi:
        return MaterialPageRoute(builder: (context) {
          final Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>;
          return MateriScreen(
            materiId: args['materiId'],
            categoryName: args['categoryName'],
          );
        });
      case quiz:
        return MaterialPageRoute(builder: (context) {
          final Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>;
          return QuizScreen(
            materiId: args['materiId'],
            categoryName: args['categoryName'],
          );
        });
      case profile:
        return MaterialPageRoute(builder: (context) => ProfileScreen());
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Center(
                    child: Text("Halaman ${settings.name} tidak ada."),
                  ),
                ));
    }
  }
}
