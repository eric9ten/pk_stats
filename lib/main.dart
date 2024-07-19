import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pk_stats/widgets/game_tracking.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    // background: const Color.fromARGB(255, 34, 34, 34),
    background: const Color.fromARGB(255, 225, 225, 225),
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 255, 152, 0),
    primary: const Color.fromARGB(255, 255, 152, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);


void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      // home: const HomeScreen(
      home: const GameTracking(
        title: 'PK Stats - Game Tracking', 
      ),
    );
  }
}
