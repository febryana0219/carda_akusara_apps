import 'package:app_mobile/blocs/materi/materi_bloc.dart';
import 'package:app_mobile/core/app/app_router.dart';
import 'package:app_mobile/core/event_type.dart';
import 'package:app_mobile/core/message.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MateriScreen extends StatefulWidget {
  final int? materiId;
  final String? categoryName;
  const MateriScreen({super.key, this.materiId, this.categoryName});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  MateriBloc _materiBloc = MateriBloc();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  // final String _audioUrl =
  // 'https://carda.ahmto.com/public/storage/suara/VpOcaVWpTUWt20FUZjq5BefOiwXf2cJ74Wa4OcAt.aac';
  // 'https://carda.ahmto.com/public/storage/suara/0CkAtLlQaEqwmhQRifRXwWVqpKeZ2Q0b3CGJQmWS.mp3';
  int materiNo = 1;

  @override
  void initState() {
    super.initState();
    _materiBloc = BlocProvider.of<MateriBloc>(context);
    _materiBloc.add(MateriEvn(EventType.direct,
        materiId: widget.materiId!, materiNo: materiNo));

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(String audioUrl) async {
    if (audioUrl.isNotEmpty) {
      await _audioPlayer.play(UrlSource(audioUrl));
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  // void _stopAudio() async {
  //   await _audioPlayer.stop();
  //   setState(() {
  //     _isPlaying = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // bool shouldPop = await _showExitDialog(context);
        // return shouldPop;
        bool shouldPop = await _handleBackEvent();
        return shouldPop;
      },
      child: Scaffold(
        body: BlocConsumer<MateriBloc, MateriState>(
          listener: (context, state) {
            if (state is MateriSuccess) {
              // print('In Listener : ${state.data}');
              print('Response cuyyy :: ${state.statusCode} - ${state.message}');
              if (state.statusCode == 102) {
                // _showCustomDialog(true, Message.success);
              }

              if (state.statusCode == 103) {
                Navigator.of(context).pop(true);
              }
            }
          },
          builder: (context, state) {
            if (state is MateriSuccess) {
              var data = state.data!;

              if (state.statusCode == 102) {
                return materiFinish();
              }

              materiNo = data['seqno'];
              print('materi no : $materiNo');
              return materiWidget(data);
              // return materiFinish();
            }

            if (state is MateriFailed) {
              return Center(
                child: Text(state.errorMessage!),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget materiWidget(Map<String, dynamic> data) {
    return Column(
      spacing: 10,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width,
          child: Text(
            widget.categoryName!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Lalezar',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(right: 10, bottom: 20),
          child: Text(
            '${Message.totalScore} : ${data['total_score']}',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Lalezar',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          height: 350,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 70, right: 70),
          decoration: BoxDecoration(
            color: Color(0xFF9F7FFF),
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(
            //   color: Color(0xFF8055FE),
            //   width: 5,
            // ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data['aksun'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lalezar',
                  fontSize: 100,
                  color: Colors.white,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                height: 5,
                color: Colors.white,
              ),
              Text(
                data['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lalezar',
                  fontSize: 100,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol Prev
            materiNo > 1
                ? InkWell(
                    onTap: () {
                      // Aksi tombol kiri
                      // setState(() {
                      //   materiNo -= 1;
                      // });
                      // print('Materi No : $materiNo');
                      _materiBloc.add(MateriEvn(EventType.prev,
                          materiId: widget.materiId!, materiNo: materiNo));
                    },
                    child: Container(
                      width: 35,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFA500),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_left,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  )
                : Container(),
            // Tombol Next
            InkWell(
              onTap: () {
                // setState(() {
                //   materiNo += 1;
                // });
                // print('Next - Materi No : $materiNo');
                _materiBloc.add(MateriEvn(EventType.next,
                    materiId: widget.materiId!, materiNo: materiNo));
              },
              child: Container(
                width: 35,
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xFFFFA500),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),

        Container(
          height: MediaQuery.of(context).size.height > 588
              ? MediaQuery.of(context).size.height - 588
              : 200,
          alignment: Alignment.center,
          child: TextButton(
            style: TextButton.styleFrom(
              shape: const CircleBorder(),
            ),
            onPressed: () {
              if (_isPlaying) {
                _pauseAudio();
              } else {
                var suara = data['suara'] ?? '';
                _playAudio(suara);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF9F7FFF),
              ),
              padding: EdgeInsets.all(20),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
        // SizedBox(height: 20),
        // ElevatedButton(
        //   onPressed: _stopAudio,
        //   child: Text('Stop Audio'),
        // ),
      ],
    );
  }

  Widget materiFinish() {
    return Column(
      spacing: 10,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width,
          child: Text(
            widget.categoryName!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Lalezar',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          height: 350,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 70, right: 70, top: 50),
          decoration: BoxDecoration(
            color: Color(0xFF9F7FFF),
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(
            //   color: Color(0xFF8055FE),
            //   width: 5,
            // ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Message.quiz,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lalezar',
                  fontSize: 100,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 70, right: 70),
          height: MediaQuery.of(context).size.height - 484,
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              // Navigator.of(context).pushReplacementNamed(
              //   AppRouter.quiz,
              //   arguments: {
              //     'materiId': widget.materiId,
              //     'categoryName': widget.categoryName,
              //   },
              // );
              Navigator.of(context).pushNamed(
                AppRouter.quiz,
                arguments: {
                  'materiId': widget.materiId,
                  'categoryName': widget.categoryName,
                },
              ).then((onValue) {
                Navigator.of(context).pop(true);
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFA500),
                padding: EdgeInsets.symmetric(vertical: 12),
                fixedSize: Size(MediaQuery.of(context).size.width, 45)),
            child: Text(
              Message.doQuiz,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _handleBackEvent() async {
    // Kirim event ke BLoC dan tunggu hasilnya
    _materiBloc.add(MateriEvn(
      EventType.back,
      materiId: widget.materiId,
      materiNo: materiNo,
    ));
    await Future.delayed(Duration(seconds: 1));
    return true;
  }
}
