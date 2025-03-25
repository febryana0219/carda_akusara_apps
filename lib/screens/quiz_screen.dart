import 'package:app_mobile/blocs/quiz/quiz_bloc.dart';
import 'package:app_mobile/core/event_type.dart';
import 'package:app_mobile/core/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

class QuizScreen extends StatefulWidget {
  final int? materiId;
  final String? categoryName;
  const QuizScreen({super.key, this.materiId, this.categoryName});

  @override
  State<StatefulWidget> createState() => _QuizScreen();
}

class _QuizScreen extends State<QuizScreen> {
  QuizBloc _materiBloc = QuizBloc();

  int score = 0;
  int lives = 3;
  int quiz = 1;
  final double maxQuiz = 10;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Materi Id : ${widget.materiId}');
    print('Category Name : ${widget.categoryName}');
    _materiBloc = BlocProvider.of<QuizBloc>(context);
    _materiBloc.add(QuizEvn(EventType.direct,
        materiId: widget.materiId!, questionId: quiz));
  }

  void minLife() {
    if (lives > 0) {
      setState(() {
        lives--;
      });
    }
  }

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
        body: BlocConsumer<QuizBloc, QuizState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is QuizSuccess) {
              // print('In Listener : ${state.data}');
              print('${state.statusCode} - ${state.message}');
              if (state.statusCode == 102) {
                _showCustomDialog(true, Message.success);
              }

              if (state.statusCode == 101) {
                _showCustomDialog(false, Message.gameOver);
              }

              if (state.statusCode == 103) {
                Navigator.of(context).pop(true);
                // Navigator.of(context).popUntil((route) => route.isFirst);
              }
            }
          },
          builder: (context, state) {
            if (state is QuizSuccess) {
              // print('In Builder : ${state.data}');
              var resultCode = state.statusCode;
              var data = state.data!;
              var jawaban = data['jawaban'];

              if (data.isNotEmpty) {
                return Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Stack(
                    children: [
                      // Center(
                      //   child: Image.asset(
                      //     'assets/images/decoration_black.png',
                      //     width: MediaQuery.of(context).size.width,
                      //     fit: BoxFit.cover, // Mengisi layar
                      //   ),
                      // ),
                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Judul Materi
                          Text(
                            widget.categoryName!,
                            style: TextStyle(
                              fontFamily: 'Lalezar',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: Duration(seconds: 1),
                                  width: (quiz / maxQuiz) *
                                      MediaQuery.of(context).size.width,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildLives(),
                                Text(
                                  '${Message.score} : $score',
                                  style: TextStyle(
                                    fontFamily: 'Lalezar',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                // Column(
                                //   children: [
                                //     buildLives(),
                                //     Text(
                                //       '${Message.score} : $score',
                                //       style: TextStyle(
                                //         fontFamily: 'Lalezar',
                                //         fontSize: 24,
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Text(
                                //   '${Message.quiz} : ${data['seqno']}',
                                //   style: TextStyle(
                                //     fontFamily: 'Lalezar',
                                //     fontSize: 24,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.black,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                width: 170,
                                height: 170,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFF9F7FFF), // Warna tombol
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color(0xFF8055FE),
                                    width: 5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withAlpha((0.2 * 255).toInt()),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  data['pertanyaan'], // Teks pertama
                                  style: TextStyle(
                                    fontFamily: 'SundaVUnpad',
                                    fontSize: 100,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnswerButton(
                                    onTap: () {
                                      if (resultCode != 2) {
                                        _doAnswer(jawaban, data['opsi_a']);
                                      }
                                    },
                                    child: Text(
                                      data['opsi_a'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Lalezar',
                                        fontSize: 32,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  AnswerButton(
                                    onTap: () {
                                      if (resultCode != 2) {
                                        _doAnswer(jawaban, data['opsi_b']);
                                      }
                                    },
                                    child: Text(
                                      data['opsi_b'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Lalezar',
                                        fontSize: 32,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  AnswerButton(
                                    onTap: () {
                                      if (resultCode != 2) {
                                        _doAnswer(jawaban, data['opsi_c']);
                                      }
                                    },
                                    child: Text(
                                      data['opsi_c'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Lalezar',
                                        fontSize: 32,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text(Message.dataEmpty),
                );
              }
            }

            if (state is QuizFailed) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(state.errorMessage!),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildLives() {
    List<Widget> hearts = [];
    for (int i = 0; i < 3; i++) {
      if (i < lives) {
        hearts.add(Icon(
          Icons.favorite,
          color: Colors.red,
        ));
      } else {
        hearts.add(Icon(
          Icons.favorite_border,
          color: Colors.grey,
        ));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: hearts,
    );
  }

  void _doAnswer(String jawaban, String opsi) {
    if (jawaban != opsi) {
      print('salah');
      minLife();
      if (lives == 0) {
        print('anda gagal');
        _materiBloc.add(QuizEvn(EventType.send,
            materiId: widget.materiId!, questionId: quiz, score: score));
        // _showCustomDialog(false, Message.gameOver);
      }
    } else {
      setState(() {
        quiz += 1;
        score += 10;
        _materiBloc.add(QuizEvn(EventType.single,
            materiId: widget.materiId!, questionId: quiz, score: score));
      });
    }
  }

  void _showCustomDialog(bool isScuccess, String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Membuat sudut melengkung
          ),
          title: Column(
            children: [
              Icon(
                isScuccess ? Icons.check_circle : Icons.error,
                color: isScuccess ? Colors.green : Colors.red,
                size: 50.0,
              ),
              SizedBox(height: 10),
              Text(
                result,
                style: TextStyle(
                  fontFamily: 'Lalezar',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isScuccess ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Mengatur ukuran konten
            children: [
              Text(
                isScuccess ? Message.successText : Message.failedText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lalezar',
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                isScuccess
                    ? 'assets/images/checked.png'
                    : 'assets/images/failed.png',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              Text(
                "${Message.score} : $score",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lalezar',
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // setState(() {
                //   score = 0;
                // });
              },
              child: Text(
                Message.backToCategory,
                style: TextStyle(
                  fontFamily: 'Lalezar',
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _handleBackEvent() async {
    // Kirim event ke BLoC dan tunggu hasilnya
    _materiBloc.add(QuizEvn(
      EventType.back,
      materiId: widget.materiId,
      questionId: quiz,
    ));
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    // Memastikan return type sesuai dengan Future<bool>
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Konfirmasi"),
              content: Text("Apakah Anda yakin ingin keluar?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Batal"),
                ),
                TextButton(
                  onPressed: () {
                    _materiBloc.add(QuizEvn(EventType.back,
                        materiId: widget.materiId!, questionId: quiz));
                  },
                  child: Text("Keluar"),
                ),
              ],
            );
          },
        ) ??
        false; // Mengembalikan false jika hasilnya null
  }
}

// Widget untuk tombol kategori
class AnswerButton extends StatefulWidget {
  final String? text;
  final Widget? child;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    this.text,
    this.child,
    required this.onTap,
  });

  @override
  _AnswerButtonState createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 120,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _isPressed
              ? Color(0xFFFFA500)
              : Color(0xFFFFFFFF), // Warna tombol
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isPressed ? Color(0xFFFF8C00) : Color(0xFFFFA500),
            width: 5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: widget.child ??
            Text(
              widget.text ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Lalezar',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
      ),
    );
  }
}
