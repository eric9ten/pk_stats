import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:pk_stats/providers/providers.dart';
import 'package:pk_stats/views/game_setup.dart';
import 'package:pk_stats/models/team.dart';
import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/models/game_stats.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void startGame() {
      // Reset all providers to initial state
      ref.read(gameListProvider.notifier).update((state) => [
            Game(
              id: const Uuid().v4(),
              location: '',
              teamA: Team(name: '', abbrev: '', color: 'FF000000'),
              teamB: Team(name: '', abbrev: '', color: 'FF000000'),
              teamAStats: GameStats(),
              teamBStats: GameStats(),
              isAHome: true,
              date: DateTime.now(),
              time: TimeOfDay.now(),
              aIsDefendingRight: true,
            )
          ]);
      ref.read(teamListProvider.notifier).update((state) => [
            Team(name: '', abbrev: '', color: 'FF000000'),
            Team(name: '', abbrev: '', color: 'FF000000'),
          ]);
      ref.read(isAHomeProvider.notifier).state = true;
      ref.read(aIsDefendingRightProvider.notifier).state = true;
      ref.read(gameHalfProvider.notifier).state = 1;
      ref.read(leftStatsProvider.notifier).state = GameStats();
      ref.read(rightStatsProvider.notifier).state = GameStats();

      // Navigate to GameSetupView
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => const GameSetupView()),
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
