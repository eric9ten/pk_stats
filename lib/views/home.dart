import 'package:flutter/material.dart';
import 'package:pk_stats/views/game_setup.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/pitch-keeper-icon.png',
                width: 300,
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => const GameSetupView())
                    );
                }, 
                style: TextButton.styleFrom(
                  foregroundColor:  const Color.fromARGB(255, 130, 130, 130),
                  padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                  
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 24,
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
