import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pk_stats/models/game_stats.dart';

import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/widgets/goal_counter.dart';
import 'package:pk_stats/widgets/stat_counter.dart';
import 'package:pk_stats/widgets/game_stat_title.dart';

class GameTrackerView extends StatefulWidget {
  const GameTrackerView ({ super.key, required this.game});

  final Game game;

  @override 
  State<GameTrackerView> createState() {
    return _GameTrackerView();
  }

}

class _GameTrackerView extends State<GameTrackerView> {
  GameStats teamAStats = GameStats(
    goals: 0, shots: 0, corners: 0, goalKicks: 0,
    tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0);
  GameStats teamBStats = GameStats(
    goals: 0, passes: 0, shots: 0, corners: 0, goalKicks: 0,
    tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0);

  int _stat = 0;

  void _updateAPasses(int count) {
    setState(() {
      teamAStats.passes = count;
    });
  }

  void _updateBPasses(int count) {
    setState(() {
      teamBStats.passes = count;
    });
  }

  void _updateAShots(int count) {
    setState(() {
      teamAStats.shots = count;
    });
  }

  void _updateBShots(int count) {
    setState(() {
      teamBStats.shots = count;
    });
  }

  void _updateACorners(int count) {
    setState(() {
      teamAStats.corners = count;
    });
  }

  void _updateBCorners(int count) {
    setState(() {
      teamBStats.corners = count;
    });
  }

  void _updateAGoalKicks(int count) {
    setState(() {
      teamAStats.goalKicks = count;
    });
  }

  void _updateBGoalKicks(int count) {
    setState(() {
      teamBStats.goalKicks = count;
    });
  }

  void _updateATackles(int count) {
    setState(() {
      teamAStats.tackles = count;
    });
  }

  void _updateBTackles(int count) {
    setState(() {
      teamBStats.tackles = count;
    });
  }

  void _updateAOffsides(int count) {
    setState(() {
      teamAStats.offsides = count;
    });
  }

  void _updateBOffsides(int count) {
    setState(() {
      teamBStats.offsides = count;
    });
  }

  void _updateAFouls(int count) {
    setState(() {
      teamAStats.fouls = count;
    });
  }

  void _updateBFouls(int count) {
    setState(() {
      teamBStats.fouls = count;
    });
  }

  void _updateAYellows(int count) {
    setState(() {
      teamAStats.yellows = count;
    });
  }

  void _updateBYellows(int count) {
    setState(() {
      teamBStats.yellows = count;
    });
  }

  void _updateAReds(int count) {
    setState(() {
      teamAStats.reds = count;
    });
  }

  void _updateBReds(int count) {
    setState(() {
      teamBStats.reds = count;
    });
  }


  @override 
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    var gameInfo = widget.game;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Tracker'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GoalCounter(
                  teamAbbrev: gameInfo.teamA.abbrev, 
                  direction: 'LTR', 
                  teamColor: gameInfo.teamA.color.toColor()!,
                ),
                const GameStatTitle(
                  title: 'Goals'
                ),
                GoalCounter(
                  teamAbbrev: gameInfo.teamB.abbrev, 
                  direction: 'LTR', 
                  teamColor: gameInfo.teamB.color.toColor()!,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatCounter(
                  direction: 'LTR',
                  callback: _updateAPasses,
                ),
                const GameStatTitle(
                  title: 'Passes'
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateBPasses,
                ),
              ],
            ),
            const Row (children: [ SizedBox(height: 10,)]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatCounter(
                  direction: 'LTR',
                  callback: _updateAShots,
                ),
                const GameStatTitle(
                  title: 'Shots'
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateBShots,
                ),
              ],
            ),
            const Row (children: [ SizedBox(height: 10,)]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatCounter(
                  direction: 'LTR',
                  callback: _updateACorners
                ),
                const GameStatTitle(
                  title: 'Corners',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateBCorners
                ),
              ],
            ),
            const Row (children: [ SizedBox(height: 10,)]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatCounter(
                  direction: 'LTR',
                  callback: _updateAGoalKicks
                ),
                const GameStatTitle(
                  title: 'Goal Kicks',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateBGoalKicks
                ),
              ],
            ),
            const Row (children: [ SizedBox(height: 10,)]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatCounter(
                  direction: 'LTR',
                  callback: _updateATackles
                ),
                const GameStatTitle(
                  title: 'Tackles',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateBTackles
                ),
              ],
            ),
            const Row (children: [ SizedBox(height: 10,)]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatCounter(
                  direction: 'LTR',
                  callback: _updateAOffsides
                ),
                const GameStatTitle(
                  title: 'Offsides',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateBOffsides
                ),
              ],
            ),
            const Row (children: [ SizedBox(height: 10,)]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatCounter(
                  direction: 'LTR',
                  callback: _updateAFouls
                ),
                const GameStatTitle(
                  title: 'Fouls',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateBFouls
                ),
              ],
            ),
            const Row (children: [ SizedBox(height: 10,)]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatCounter(
                  direction: 'LTR',
                  callback: _updateAYellows
                ),
                const GameStatTitle(
                  title: 'Yellow Cards',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateBYellows
                ),
              ],
            ),
            const Row (children: [ SizedBox(height: 10,)]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatCounter(
                  direction: 'LTR',
                  callback: _updateAReds
                ),
                const GameStatTitle(
                  title: 'Red Cards',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateBReds
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},  
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                  ),
                  child: const Text(
                    'Halftime',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                  ),
                ),
                IconButton(
                  onPressed: () {}, 
                  icon: const Icon(Icons.restart_alt),
                ),
                TextButton(
                  onPressed: () {},  
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                  ),
                  child: const Text(
                    'End Game',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                  ),
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}
