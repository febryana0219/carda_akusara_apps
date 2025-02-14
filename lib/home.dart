import 'package:flutter/material.dart';
import 'materi.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title for Materi
            Text(
              'Kategori',
              style: TextStyle(
                fontFamily: 'Lalezar',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15), // Spasi antara title dan tombol
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Aksara Ngalagena
                CategoryButton(
                  text: 'Aksara\nNgalagena',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MateriScreen()),
                    );
                  },
                ),
                const SizedBox(width: 20), // Spasi antara tombol
                // Tombol Aksara Swara
                CategoryButton(
                  text: 'Aksara\nSwara',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MateriScreen()),
                    );
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
  final String text;
  final VoidCallback onTap;

  const CategoryButton({super.key, required this.text, required this.onTap});

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
        child: Text(
          widget.text,
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
