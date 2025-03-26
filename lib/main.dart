import 'package:app_mobile/blocs/category/category_bloc.dart';
import 'package:app_mobile/blocs/auth/auth_bloc.dart';
import 'package:app_mobile/blocs/materi/materi_bloc.dart';
import 'package:app_mobile/blocs/profile/profile_bloc.dart';
import 'package:app_mobile/blocs/quiz/quiz_bloc.dart';
import 'package:app_mobile/blocs/registration/registration_bloc.dart';
import 'package:app_mobile/core/app/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/splash_screen.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     statusBarColor: Color(0xFF8055FE),
  //     statusBarIconBrightness: Brightness.light,
  //   ),
  // );
  runApp(MyApp.runWidget());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  final NavigatorObserver _navigatorObserver = MyNavigatorObserver();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carda Akusara',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [_navigatorObserver],
      onGenerateRoute: AppRouter.generateRoute,
      home: SplashScreen(),
    );
  }

  static Widget runWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(),
        ),
        BlocProvider<RegistrationBloc>(
          create: (BuildContext context) => RegistrationBloc(),
        ),
        BlocProvider<CategoryBloc>(
          create: (BuildContext context) => CategoryBloc(),
        ),
        BlocProvider<QuizBloc>(
          create: (BuildContext context) => QuizBloc(),
        ),
        BlocProvider<MateriBloc>(
          create: (BuildContext context) => MateriBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (BuildContext context) => ProfileBloc(),
        ),
      ],
      child: MyApp(),
    );
    // return const MyApp();
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _updateStatusBar(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _updateStatusBar(previousRoute);
  }

  // Fungsi untuk mengatur status bar sesuai route
  void _updateStatusBar(Route? route) {
    // Periksa jika route dan route.settings.name tidak null
    final routeName = route?.settings.name;
    print('route name : $routeName');

    if (routeName == '/' ||
        routeName == AppRouter.login ||
        routeName == AppRouter.registration) {
      // Halaman 1 - Tidak ada warna di status bar
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor:
              Colors.transparent, // Tidak ada warna untuk status bar
          statusBarIconBrightness:
              Brightness.dark, // Ikon status bar tetap gelap
        ),
      );
    } else {
      // Halaman lain - Warna tertentu di status bar
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Color(0xFF8055FE), // Warna status bar di Page 2
          statusBarIconBrightness: Brightness.light, // Ikon status bar terang
        ),
      );
    }
  }
}
