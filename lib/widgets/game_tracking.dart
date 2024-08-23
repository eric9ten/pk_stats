import 'package:flutter/material.dart';

import 'package:pk_stats/views/game_setup.dart';
import 'package:pk_stats/views/goal_setup.dart';

class GameTracking extends StatelessWidget {
  const GameTracking({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PK Stats - Game Tracker'),
      ),
      body: const Column (
          mainAxisSize: MainAxisSize.min,
          children: [
            // GameSetupView(),
            // GoalSetupView()
          ],
        ),
    );
   }

}