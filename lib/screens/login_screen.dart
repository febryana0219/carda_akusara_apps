import 'package:app_mobile/blocs/auth/auth_bloc.dart';
import 'package:app_mobile/core/app/app_router.dart';
import 'package:app_mobile/core/components/alert_widget.dart';
import 'package:app_mobile/core/event_type.dart';
import 'package:app_mobile/core/message.dart';
import 'package:app_mobile/core/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Storage storage = Storage();
  AuthBloc _loginBloc = AuthBloc();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscureText = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of<AuthBloc>(context);
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
          Center(
            child: Column(
              spacing: 20,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoading) {
                      print("Loading...");
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          content: Row(
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(width: 20),
                              Text(Message.pleaseWait),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is AuthFailed) {
                      print("${state.errorMessage}");
                      Navigator.of(context).pop();

                      AlertWidget().showAlertSingleButton(context,
                          title: Message.failed, msg: state.errorMessage);
                    }

                    if (state is AuthSuccess) {
                      Navigator.of(context).pop();
                      print("${state.message}");
                      if (state.statusCode == 1) {
                        storage.setStorage(
                            storage.accessToken, state.data!['token']);
                        storage.setStorage(
                            storage.refreshToken, state.data!['refresh_token']);
                        // _loginBloc.close();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRouter.category,
                            (Route<dynamic> route) => false);
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 300,
                    child: Column(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: Message.username,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color(0xFF8055FE), width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color(0xFF8055FE),
                                  width: 2), // Ganti warna border saat fokus
                            ),
                          ),
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: Message.password,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color(0xFF8055FE), width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color(0xFF8055FE),
                                  width: 2), // Ganti warna border saat fokus
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Color(0xFF8055FE),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: Color(0xFF8055FE),
                              side: BorderSide(
                                color: Color(0xFF8055FE),
                                width: 2,
                              ),
                              onChanged: (bool? value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            Text(Message.rememberMe),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _doLogin();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8055FE),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              fixedSize:
                                  Size(MediaQuery.of(context).size.width, 45)),
                          child: Text(
                            Message.login,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(Message.haveNotAccount),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRouter.registration);
                              },
                              child: Text(
                                Message.registNow,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _doLogin() {
    if (usernameController.text.trim().isEmpty) {
      AlertWidget().showAlertSingleButton(context,
          title: Message.failed, msg: Message.usernameEmpty);
    } else if (passwordController.text.trim().isEmpty) {
      AlertWidget().showAlertSingleButton(context,
          title: Message.failed, msg: Message.passwordEmpty);
    } else {
      // addLocation();
      Map<String, dynamic> dataRequest = {
        'username': usernameController.text,
        'password': passwordController.text,
        'remember_me': _rememberMe ? 'Y' : 'T'
      };
      print(dataRequest);
      _loginBloc.add(AuthEvn(EventType.login, payload: dataRequest));
    }
  }
}
