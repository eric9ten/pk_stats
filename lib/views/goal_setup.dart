import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pk_stats/providers/providers.dart';
import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/views/game_tracker.dart';
import 'package:pk_stats/widgets/ad_banner.dart';

class GoalSetupView extends ConsumerStatefulWidget {
  const GoalSetupView ({super.key});

  @override 
  ConsumerState<GoalSetupView> createState() {
    return _GoalSetupViewState();
  }

}

class _GoalSetupViewState extends ConsumerState<GoalSetupView> {
  void _updateGoal() {
    final games = ref.read(gameListProvider);
    if (games.isEmpty) {
      // Handle case where no game exists (should not happen if navigated from GameSetupWidget)
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('No Game Found'),
          content: const Text('Please set up a game first.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    final game = games.first;
    final aIsDefendingRight = ref.read(aIsDefendingRightProvider);
    final updatedGame = Game(
      id: game.id,
      location: game.location,
      teamA: game.teamA,
      teamB: game.teamB,
      teamAStats: game.teamAStats,
      teamBStats: game.teamBStats,
      isAHome: game.isAHome,
      date: game.date,
      time: game.time,
      aIsDefendingRight: aIsDefendingRight,
    );

    // Update provider (replace single game)
    ref.read(gameListProvider.notifier).update((state) => [updatedGame]);

    // Navigate to GameTrackerView
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => GameTrackerView()
      )
    );
  }

  @override 
  Widget build(BuildContext context) {
    final games = ref.watch(gameListProvider);
    final aIsDefendingRight = ref.watch(aIsDefendingRightProvider);
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    
    if (games.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Goal Setup')),
        body: const Center(child: Text('No game data available')),
      );
    }

    final game = games.first;

    return Scaffold (
      appBar: AppBar (
        title: const Text ('Goal Setup'),
      ),
      body: 
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text('Which goal is ${game.teamA!.name} defending?',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Left',
                      style:  
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      ),
                    const SizedBox(width: 10),
                    Switch(
                      value: aIsDefendingRight,
                      activeColor: Theme.of(context).colorScheme.primary,
                      inactiveThumbColor: Theme.of(context).colorScheme.onPrimary,
                      onChanged: (bool value) {
                        setState(() {
                          ref.read(aIsDefendingRightProvider.notifier).state = value;
                        });
                      }
                    ),
                    const SizedBox(width: 10),
                    Text('Right',
                      style:  
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        )
                    ),
                  ],
                ),
                const Row(
                  children: [
                    SizedBox(height: 48),
                  ]
                ),              
                Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _updateGoal,  
                      style: TextButton.styleFrom(
                        textStyle: GoogleFonts.inter (
                          fontSize: 12,
                          color:  const Color.fromARGB(255, 130, 130, 130),
                        ),
                        padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                      ),
                      child: const Text(
                        'Track Game',
                        style: TextStyle(
                          fontSize: 24,
                        )
                      ),
                    ),
                  ]
                ),
                const Spacer(
                  flex: 1,
                ),
                BannerAdWidget(),
              ],
            ),
          ),
        );
  }
}
