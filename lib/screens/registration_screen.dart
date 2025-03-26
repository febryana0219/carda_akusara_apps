import 'package:app_mobile/blocs/registration/registration_bloc.dart';
import 'package:app_mobile/core/app/app_router.dart';
import 'package:app_mobile/core/components/alert_widget.dart';
import 'package:app_mobile/core/event_type.dart';
import 'package:app_mobile/core/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  RegistrationBloc _registrationBloc = RegistrationBloc();

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retryPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureRetryPassword = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _registrationBloc = BlocProvider.of<RegistrationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Center(
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
                    BlocListener<RegistrationBloc, RegistrationState>(
                      listener: (context, state) {
                        if (state is RegistrationLoading) {
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

                        if (state is RegistrationFailed) {
                          print("${state.errorMessage}");
                          Navigator.of(context).pop();

                          AlertWidget().showAlertSingleButton(context,
                              // title: Message.failed,
                              msg: state.errorMessage);
                        }

                        if (state is RegistrationSuccess) {
                          print("${state.message}");
                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${state.message}',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                              duration: Duration(
                                  seconds: 4), // Durasi tampil SnackBar
                            ),
                          );
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRouter.login, (Route<dynamic> route) => false);
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
                          spacing: 15,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              Message.registartionTitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Lalezar',
                                fontSize: 24,
                                // fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: Message.name,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color(0xFF8055FE), width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color(0xFF8055FE),
                                      width:
                                          2), // Ganti warna border saat fokus
                                ),
                              ),
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
                                      width:
                                          2), // Ganti warna border saat fokus
                                ),
                              ),
                            ),
                            TextField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
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
                                      width:
                                          2), // Ganti warna border saat fokus
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Color(0xFF8055FE),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            TextField(
                              controller: retryPasswordController,
                              obscureText: _obscureRetryPassword,
                              decoration: InputDecoration(
                                hintText: Message.retryPassword,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color(0xFF8055FE), width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color(0xFF8055FE),
                                      width:
                                          2), // Ganti warna border saat fokus
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureRetryPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Color(0xFF8055FE),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureRetryPassword =
                                          !_obscureRetryPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _doAuth();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF8055FE),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width, 45)),
                              child: Text(
                                Message.registration,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _doAuth() {
    if (nameController.text.trim().isEmpty) {
      AlertWidget().showAlertSingleButton(context,
          // title: Message.failed,
          msg: Message.nameEmpty);
    } else if (usernameController.text.trim().isEmpty) {
      AlertWidget().showAlertSingleButton(context,
          // title: Message.failed,
          msg: Message.usernameEmpty);
    } else if (passwordController.text.trim().isEmpty) {
      AlertWidget().showAlertSingleButton(context,
          // title: Message.failed,
          msg: Message.passwordEmpty);
    } else if (passwordController.text.trim() !=
        retryPasswordController.text.trim()) {
      AlertWidget().showAlertSingleButton(context,
          // title: Message.failed,
          msg: Message.passwordWrong);
    } else {
      // addLocation();
      Map<String, dynamic> dataRequest = {
        'name': nameController.text,
        'username': usernameController.text,
        'email': usernameController.text,
        'password': retryPasswordController.text,
      };
      print(dataRequest);
      _registrationBloc
          .add(RegistrationEvn(EventType.registration, dataRequest));
    }
  }
}
