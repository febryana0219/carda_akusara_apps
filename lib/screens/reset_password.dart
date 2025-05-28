import 'package:app_mobile/blocs/auth/auth_bloc.dart';
import 'package:app_mobile/core/app/app_router.dart';
import 'package:app_mobile/core/components/alert_widget.dart';
import 'package:app_mobile/core/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? code;
  const ResetPasswordScreen({super.key, this.code});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  AuthBloc _authBloc = AuthBloc();
  final _codeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  void _requestResetCode() async {
    final code = _codeController.text.trim();
    final new_password = _passwordController.text.trim();
    if (code.isEmpty || new_password.isEmpty) return;

    _authBloc.add(ResetPasswordEvent(
        isRequest: false,
        payload: {'code': code, 'new_password': new_password}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8055FE),
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF8055FE),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is ResetPasswordLoading) {
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

            if (state is ResetPasswordFailed) {
              print("${state.errorMessage}");
              Navigator.of(context).pop();

              AlertWidget().showAlertSingleButton(context,
                  // title: Message.failed,
                  msg: state.errorMessage);
            }

            if (state is ResetPasswordSuccess) {
              Navigator.of(context).pop();
              print("${state.message}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${state.message}',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 4), // Durasi tampil SnackBar
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
            // width: 300,
            child: Column(
              spacing: 10,
              children: [
                Text('Kode yang harus dimasukan : ${widget.code}'),
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    hintText: 'Kode',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color(0xFF8055FE), width: 1.5),
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
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Katasandi Baru',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color(0xFF8055FE), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Color(0xFF8055FE),
                          width: 2), // Ganti warna border saat fokus
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _requestResetCode();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8055FE),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      fixedSize: Size(MediaQuery.of(context).size.width, 45)),
                  child: Text(
                    'Request Kode',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
