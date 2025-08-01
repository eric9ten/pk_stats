import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/views/game_tracker.dart';
import 'package:pk_stats/widgets/ad_banner.dart';

class GoalSetupView extends StatefulWidget {
  const GoalSetupView ({super.key, required this.game, required this.gameHalf});

  final Game game;
  final int gameHalf;

  @override 
  State<GoalSetupView> createState() {
    return _GoalSetupView();
  }

}

class _GoalSetupView extends State<GoalSetupView> {
  bool _aIsDefendingRight = true;

  void _updateGoal() {
    final Game gameInfo = widget.game;
    gameInfo.aIsDefendingRight = _aIsDefendingRight;

    Navigator.push(
      context, MaterialPageRoute(builder: (ctx) => 
        GameTrackerView(
          game: gameInfo, 
          gameHalf: widget.gameHalf,
        )
      )
    );
  }

  @override 
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

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
                      child: Text('Which goal is ${widget.game.teamA.name} defending?',
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
                      value: _aIsDefendingRight,
                      activeColor: Theme.of(context).colorScheme.primary,
                      inactiveThumbColor: Theme.of(context).colorScheme.onPrimary,
                      onChanged: (bool value) {
                        setState(() {
                          print('changed is `$value`');
                          _aIsDefendingRight = value;
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
                MyBannerAdWidget(),
              ],
            ),
          ),
        );
  }
}
