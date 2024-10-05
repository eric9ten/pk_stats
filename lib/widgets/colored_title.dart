import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColoredTitle extends StatelessWidget {
  const ColoredTitle ({super.key, required this.title, required this.color});

  final String title;
  final String color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.dosis(
        color: color.toColor(),
        fontSize: 28,
        fontWeight: FontWeight.w700,
        shadows: color == 'FFFFFFFF' ? const [
          Shadow(
              // bottomLeft
              offset: Offset(-1.5, -1.5),
              color: Color.fromARGB(255, 175, 175, 175)
          ),
          Shadow(
              // bottomRight
              offset: Offset(1.5, -1.5),
              color: Color.fromARGB(255, 175, 175, 175)
          ),
          Shadow(
              // topRight
              offset: Offset(1.5, 1.5),
              color: Color.fromARGB(255, 175, 175, 175)
          ),
          Shadow(
              // topLeft
              offset: Offset(-1.5, 1.5),
              color: Color.fromARGB(255, 175, 175, 175)
          ),
        ] : [],
      ),
    );
  }
}