import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:pk_stats/models/game_stats.dart';

import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/models/team.dart';
import 'package:pk_stats/widgets/goal_counter.dart';
import 'package:pk_stats/widgets/stat_counter.dart';
import 'package:pk_stats/widgets/game_stat_title.dart';
import 'package:pk_stats/views/game_review.dart';

class GameTrackerView extends StatefulWidget {
  const GameTrackerView ({ super.key, required this.game, required this.gameHalf});

  final Game game;
  final int gameHalf;

  @override 
  State<GameTrackerView> createState() {
    return _GameTrackerView();
  }

}

class _GameTrackerView extends State<GameTrackerView> {
  GameStats leftStats = GameStats(
    goals: 0, shots: 0, corners: 0, goalKicks: 0,
    tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0);
  GameStats rightStats = GameStats(
    goals: 0, passes: 0, shots: 0, corners: 0, goalKicks: 0,
    tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0);

  int _stat = 0;

  void _toReview() {
    Navigator.push(
      context, MaterialPageRoute(builder: (ctx) => 
        GameReviewView(gameHalf: widget.gameHalf, game: widget.game)
      )
    );
  }

  void _updateAPasses(int count) {
    setState(() {
      leftStats.passes = count;
    });
  }

  void _updateBPasses(int count) {
    setState(() {
      rightStats.passes = count;
    });
  }

  void _updateAShots(int count) {
    setState(() {
      leftStats.shots = count;
    });
  }

  void _updateBShots(int count) {
    setState(() {
      rightStats.shots = count;
    });
  }

  void _updateACorners(int count) {
    setState(() {
      leftStats.corners = count;
    });
  }

  void _updateBCorners(int count) {
    setState(() {
      rightStats.corners = count;
    });
  }

  void _updateAGoalKicks(int count) {
    setState(() {
      leftStats.goalKicks = count;
    });
  }

  void _updateBGoalKicks(int count) {
    setState(() {
      rightStats.goalKicks = count;
    });
  }

  void _updateATackles(int count) {
    setState(() {
      leftStats.tackles = count;
    });
  }

  void _updateBTackles(int count) {
    setState(() {
      rightStats.tackles = count;
    });
  }

  void _updateAOffsides(int count) {
    setState(() {
      leftStats.offsides = count;
    });
  }

  void _updateBOffsides(int count) {
    setState(() {
      rightStats.offsides = count;
    });
  }

  void _updateAFouls(int count) {
    setState(() {
      leftStats.fouls = count;
    });
  }

  void _updateBFouls(int count) {
    setState(() {
      rightStats.fouls = count;
    });
  }

  void _updateAYellows(int count) {
    setState(() {
      leftStats.yellows = count;
    });
  }

  void _updateBYellows(int count) {
    setState(() {
      rightStats.yellows = count;
    });
  }

  void _updateAReds(int count) {
    setState(() {
      leftStats.reds = count;
    });
  }

  void _updateBReds(int count) {
    setState(() {
      rightStats.reds = count;
    });
  }


  @override 
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    var gameInfo = widget.game;
    Team leftTeam;
    Team rightTeam;

    print(gameInfo.aIsDefendingRight);
    if (gameInfo.aIsDefendingRight!) {
      if (widget.gameHalf == 1) {
        leftTeam = gameInfo.teamB;
        rightTeam = gameInfo.teamA;
      } else {
        leftTeam = gameInfo.teamA;
        leftStats = gameInfo.teamAStats!;
        rightTeam = gameInfo.teamB;
        rightStats = gameInfo.teamBStats!;
      }
    } else {
      if (widget.gameHalf == 1) {
        leftTeam = gameInfo.teamA;
        rightTeam = gameInfo.teamB;
      } else {
        leftTeam = gameInfo.teamB;
        leftStats = gameInfo.teamBStats!;
        rightTeam = gameInfo.teamA;
        rightStats = gameInfo.teamAStats!;
      }
    }
    
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
                  teamAbbrev: leftTeam.abbrev, 
                  direction: 'LTR', 
                  teamColor: leftTeam.color.toColor()!,
                ),
                const GameStatTitle(
                  title: 'Goals'
                ),
                GoalCounter(
                  teamAbbrev: rightTeam.abbrev, 
                  direction: 'LTR', 
                  teamColor: rightTeam.color.toColor()!,
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
                  onPressed: _toReview,  
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
