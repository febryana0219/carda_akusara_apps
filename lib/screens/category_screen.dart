import 'package:app_mobile/blocs/category/category_bloc.dart';
import 'package:app_mobile/core/app/app_router.dart';
import 'package:app_mobile/core/components/alert_widget.dart';
import 'package:app_mobile/core/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CategoryScreen();
}

class _CategoryScreen extends State<CategoryScreen> {
  late CategoryBloc categoryBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryBloc = BlocProvider.of<CategoryBloc>(context);
    getData();
  }

  Future<void> getData() async {
    categoryBloc.add(CategoryEvn());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: getData,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRouter.information,
                    );
                  },
                  child: const Icon(
                    Icons.info_outline_rounded,
                    // Icons.settings,
                    color: Color(0xFF9F7FFF),
                    size: 40,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRouter.profile,
                    );
                  },
                  child: const Icon(
                    Icons.account_circle_rounded,
                    // Icons.settings,
                    color: Color(0xFF9F7FFF),
                    size: 40,
                  ),
                ),
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
          Expanded(
            child: BlocConsumer<CategoryBloc, CategoryState>(
                listener: (context, state) {
              if (state is CategoryLoading) {
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

              if (state is CategoryFailed) {
                Navigator.of(context).pop();
                if (state.errorCode == 104) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouter.login, (Route<dynamic> route) => false);
                }
              }

              if (state is CategorySuccess) {
                Navigator.of(context).pop();
              }
            }, builder: (context, state) {
              if (state is CategorySuccess) {
                print('Response : ${state.statusCode}');
                if (state.statusCode == 1) {
                  var items = state.items;

                  print(items);
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10, right: 10),
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${Message.totalScore} : ${state.totalScore}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Lalezar',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: items!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CategoryList(items[index]!);
                          },
                        ),
                      ],
                    ),
                  );
                }
              }

              if (state is CategoryFailed) {
                return SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height - 70,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Image.asset(
                          'assets/images/failed.png',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          state.errorMessage!,
                          // 'yuhu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Lalezar',
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            }),
          ),
        ],
      ),
    ));
  }
}

class CategoryList extends StatefulWidget {
  final Map<String, dynamic> data;
  const CategoryList(this.data, {super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    print('Data : ${widget.data}');
    List<dynamic> materis = widget.data['materi'];
    print(materis);
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title for Materi
            Text(
              widget.data['category_name'],
              style: TextStyle(
                fontFamily: 'Lalezar',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15), // Spasi antara title dan tombol
            GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                children: List.generate(materis.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MateriList(
                      data: materis[index],
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRouter.materi,
                          arguments: {
                            'materiId': materis[index]['id'],
                            'categoryName': widget.data['category_name'],
                          },
                        ).then((onValue) {
                          setState(() {
                            // _CategoryScreen().getData();
                            final categoryBloc =
                                BlocProvider.of<CategoryBloc>(context);
                            categoryBloc.add(CategoryEvn());
                          });
                        });
                        // Navigator.of(context).pushNamed(AppRouter.materi);
                      },
                    ),
                  );
                }))
          ],
        ),
      ),
    );
  }
}

// Widget untuk list dari materi
class MateriList extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const MateriList({super.key, required this.data, required this.onTap});

  @override
  _MateriListState createState() => _MateriListState();
}

class _MateriListState extends State<MateriList> {
  bool _isPressed = false;

  bool _isStart = false;
  bool _isScore = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isScore = widget.data['score'] > 0 &&
            widget.data['is_start'] == true &&
            widget.data['is_open'] == 'yes'
        ? true
        : false;
    _isStart =
        widget.data['is_start'] == false && widget.data['is_open'] == 'no'
            ? false
            : true;
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.data['title'];
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
        if (_isStart) {
          widget.onTap();
        } else {
          AlertWidget()
              .showAlertSingleButton(context, msg: Message.materiNotOpen);
        }
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isPressed
              ? Color(0xFFFFA500)
              : Color(0xFF9F7FFF), // Warna tombol
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isPressed ? Color(0xFFFF8C00) : Color(0xFF8055FE),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.data['aksun'],
              textAlign: TextAlign.center,
              style: TextStyle(
                // fontFamily: 'SundaVUnpad',
                fontFamily: 'Lalezar',
                fontSize: 22,
                // fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                // fontFamily: 'Lalezar',
                fontSize: title.length > 10 ? 10 : 16,
                color: Colors.white,
              ),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            _isStart
                ? _isScore
                    ? Text(
                        widget.data['score'].toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          // fontFamily: 'Lalezar',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent,
                        ),
                      )
                    : Container()
                : Icon(
                    Icons.lock,
                    color: Colors.white,
                  )
          ],
        ),
      ),
    );
  }
}
