import 'package:app_mobile/blocs/category/category_bloc.dart';
import 'package:app_mobile/blocs/auth/auth_bloc.dart';
import 'package:app_mobile/blocs/materi/materi_bloc.dart';
import 'package:app_mobile/blocs/profile/profile_bloc.dart';
import 'package:app_mobile/blocs/quiz/quiz_bloc.dart';
import 'package:app_mobile/blocs/registration/registration_bloc.dart';
import 'package:app_mobile/core/app/app_router.dart';
import 'package:app_mobile/screens/materi_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp.runWidget());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carda Akusara',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
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
      child: const MyApp(),
    );
    // return const MyApp();
  }
}
