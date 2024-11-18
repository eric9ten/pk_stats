import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pk_stats/views/home.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    surface: const Color.fromARGB(255, 240, 240, 240),
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 255, 152, 0),
    primary: const Color.fromARGB(255, 255, 152, 0),
    secondary: const Color.fromARGB(255, 36, 36, 36),
  ),
  canvasColor: const Color.fromARGB(255, 240, 240, 240),
  scaffoldBackgroundColor: const Color.fromARGB(255, 240, 240, 240),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.dosis(
      fontSize: 38,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.dosis(
      fontSize: 18,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.lato(
      fontSize: 18
    ),
    bodyMedium: GoogleFonts.lato(
      fontSize: 14
    ),
    bodySmall: GoogleFonts.lato(
      fontSize: 12
    ),
    labelLarge: GoogleFonts.lato(
      fontSize: 20
    ),
    labelMedium: GoogleFonts.lato(
      fontSize: 16,
    ),
    labelSmall: GoogleFonts.lato(
      fontSize: 12,
    ),
  ),
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
      home: HomeScreen(
        title: 'PK Stats - Game Tracking', 
      ),
    );
  }
}
