import 'package:flutter/material.dart';
import 'package:pk_stats/views/game_setup.dart';

import 'package:pk_stats/models/team.dart';
import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/models/game_stats.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.title});
  final String title;
  final Game game =  Game(date: DateTime.now(), time: TimeOfDay.now(), location: '', 
    teamA: Team(name: '', abbrev: '', color: ''),
    teamB: Team(name: '', abbrev: '', color: ''),
    teamAStats: GameStats(goals: 0, shots: 0, corners: 0, goalKicks: 0,
      tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0),
    teamBStats: GameStats(goals: 0, shots: 0, corners: 0, goalKicks: 0,
      tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0),
    isAHome: true);

  @override
  Widget build(BuildContext context) {
    Game gameInfo = game;

    void startGame() {
      Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => 
          GameSetupView(game: gameInfo))
        );
    }

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
                onPressed: startGame, 
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
