import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class MateriScreen extends StatelessWidget {
  const MateriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aksara Ngalagena',
          style: TextStyle(
            fontFamily: 'Lalezar',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF9F7FFF), // Warna AppBar tetap ungu
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Judul Materi
            Text(
              'Materi',
              style: TextStyle(
                fontFamily: 'Lalezar',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30), // Spasi antara teks dan tombol
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Aksara Ngalagena dengan dua font berbeda
                CategoryButton(
                  child: Column(
                    children: [
                      Text(
                        'ka ga nga', // Teks pertama
                        style: TextStyle(
                          fontFamily: 'SundaVUnpad',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                        // style: GoogleFonts.notoSansSundanese(
                        //   fontSize: 18,
                        //   fontWeight: FontWeight.bold,
                        //   color: Colors.white,
                        // ),
                      ),
                      Text(
                        'ka ga nga', // Teks kedua (Arial)
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navigasi atau aksi ketika tombol ditekan
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget untuk tombol kategori
class CategoryButton extends StatefulWidget {
  final String? text;
  final Widget? child;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    this.text,
    this.child,
    required this.onTap,
  });

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
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
        width: 170,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
