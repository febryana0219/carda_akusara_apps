import 'package:app_mobile/blocs/auth/auth_bloc.dart';
import 'package:app_mobile/core/app/app_router.dart';
import 'package:app_mobile/core/components/alert_widget.dart';
import 'package:app_mobile/core/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestResetScreen extends StatefulWidget {
  const RequestResetScreen({super.key});

  @override
  State<RequestResetScreen> createState() => _RequestResetScreenState();
}

class _RequestResetScreenState extends State<RequestResetScreen> {
  AuthBloc _authBloc = AuthBloc();
  final _usernameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  void _requestResetCode() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) return;

    // TODO: Call API to request reset code
    print("Request reset for: $username");
    _authBloc.add(
        ResetPasswordEvent(isRequest: true, payload: {'username': username}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8055FE),
      appBar: AppBar(
        title: Text(
          'Request',
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
              if (state.statusCode == 1) {
                Navigator.of(context)
                    .pushNamed(AppRouter.resetPassword, arguments: state.data);
              }
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
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: Message.username,
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
