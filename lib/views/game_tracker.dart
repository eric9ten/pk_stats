import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameTrackerView extends StatefulWidget {
  const GameTrackerView ({ super.key});

  @override 
  State<GameTrackerView> createState() {
    return _GameTrackerView();
  }

}

class _GameTrackerView extends State<GameTrackerView> {

  @override 
  Widget build(BuildContext context) {

    return Text('Game Tracker',
      style: GoogleFonts.dosis(
        fontSize: 34,
        fontWeight: FontWeight.bold,
      )
    );
  }
}
