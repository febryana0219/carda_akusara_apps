import 'package:app_mobile/blocs/auth/auth_bloc.dart';
import 'package:app_mobile/blocs/profile/profile_bloc.dart';
import 'package:app_mobile/core/app/app_router.dart';
import 'package:app_mobile/core/event_type.dart';
import 'package:app_mobile/core/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthBloc _authBloc = AuthBloc();
  ProfileBloc _profileBloc = ProfileBloc();
  String _versionName = '-';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAppVersion();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _profileBloc.add(ProfileEvn());
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _versionName = packageInfo.version;
    });
    print('Versi : $_versionName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                Text(
                  'Profil',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Lalezar',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                if (state is ProfileSuccess) {
                  return _profileDetails(state.data!);
                }
                return Container();
              })),
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              'v$_versionName',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Lalezar',
                fontSize: 16,
                // color: Colors.black,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthLoading) {
                  print('Loading logout');
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

                if (state is AuthSuccess || state is AuthFailed) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouter.login, (Route<dynamic> route) => false);
                }
              },
              child: OutlinedButton(
                onPressed: () {
                  _authBloc.add(AuthEvn(EventType.logout));
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  Message.logout,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _profileDetails(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileInfoTile(
          icon: Icons.admin_panel_settings_rounded,
          text: data['username'].toString(),
        ),
        ProfileInfoTile(
          icon: Icons.person,
          text: data['name'].toString(),
        ),
        ProfileInfoTile(
          icon: Icons.score,
          text: data['total_score'].toString(),
        ),
      ],
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileInfoTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(
            text,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Lalezar',
              fontSize: 20,
            ),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        Container(
          color: Colors.grey,
          height: 1,
          width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}
