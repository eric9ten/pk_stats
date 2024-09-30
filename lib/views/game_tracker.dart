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
  GameStats _leftStats = GameStats(
    goals: 0, shots: 0, corners: 0, goalKicks: 0,
    tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0);
  GameStats _rightStats = GameStats(
    goals: 0, passes: 0, shots: 0, corners: 0, goalKicks: 0,
    tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0);
  Team _leftTeam = Team(name: '', abbrev: '', color: '');
  Team _rightTeam = Team(name: '', abbrev: '', color: '');
  Game _gameInfo =  Game(date: DateTime.now(), time: TimeOfDay.now(), location: '', 
    teamA: Team(name: '', abbrev: '', color: ''),
    teamB: Team(name: '', abbrev: '', color: ''),
    teamAStats: GameStats(goals: 0, shots: 0, corners: 0, goalKicks: 0,
      tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0),
    teamBStats: GameStats(goals: 0, shots: 0, corners: 0, goalKicks: 0,
      tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0),
    isAHome: true);

  final int _stat = 0;

  void _toReview() {
    if (widget.game.aIsDefendingRight!) {
      if (widget.gameHalf == 1) {
        widget.game.teamB = _leftTeam;
        widget.game.teamBStats = _leftStats;
        widget.game.teamA = _rightTeam;
        widget.game.teamAStats = _rightStats;
        // leftTeam = gameInfo.teamB;
        // leftStats = gameInfo.teamBStats!;
        // rightTeam = gameInfo.teamA;
        // rightStats = gameInfo.teamAStats!;
      } else {
        widget.game.teamA = _leftTeam;
        widget.game.teamAStats = _leftStats;
        widget.game.teamB = _rightTeam;
        widget.game.teamBStats = _rightStats;
      }
    } else {
      if (widget.gameHalf == 1) {
        widget.game.teamB = _leftTeam;
        widget.game.teamBStats = _leftStats;
        widget.game.teamA = _rightTeam;
        widget.game.teamAStats = _rightStats;
        // leftTeam = gameInfo.teamA;
        // leftStats = gameInfo.teamAStats!;
        // rightTeam = gameInfo.teamB;
        // rightStats = gameInfo.teamBStats!;
      } else {
        widget.game.teamA = _leftTeam;
        widget.game.teamAStats = _leftStats;
        widget.game.teamB = _rightTeam;
        widget.game.teamBStats = _rightStats;
        // leftTeam = gameInfo.teamB;
        // leftStats = gameInfo.teamBStats!;
        // rightTeam = gameInfo.teamA;
        // rightStats = gameInfo.teamAStats!;
      }
    }

    Navigator.push(
      context, MaterialPageRoute(builder: (ctx) => 
        GameReviewView(gameHalf: widget.gameHalf, game: widget.game)
      )
    );
  }

  void _updateAGoals(int count) {
    setState(() {
      _leftStats.goals = count;
    });
  }

  void _updateBGoals(int count) {
    setState(() {
      _rightStats.goals = count;
    });
  }

  void _updateAPasses(int count) {
    setState(() {
      _leftStats.passes = count;
    });
  }

  void _updateBPasses(int count) {
    setState(() {
      _rightStats.passes = count;
    });
  }

  void _updateAShots(int count) {
    setState(() {
      _leftStats.shots = count;
    });
  }

  void _updateBShots(int count) {
    setState(() {
      _rightStats.shots = count;
    });
  }

  void _updateACorners(int count) {
    setState(() {
      _leftStats.corners = count;
    });
  }

  void _updateBCorners(int count) {
    setState(() {
      _rightStats.corners = count;
    });
  }

  void _updateAGoalKicks(int count) {
    setState(() {
      _leftStats.goalKicks = count;
    });
  }

  void _updateBGoalKicks(int count) {
    setState(() {
      _rightStats.goalKicks = count;
    });
  }

  void _updateATackles(int count) {
    setState(() {
      _leftStats.tackles = count;
    });
  }

  void _updateBTackles(int count) {
    setState(() {
      _rightStats.tackles = count;
    });
  }

  void _updateAOffsides(int count) {
    setState(() {
      _leftStats.offsides = count;
    });
  }

  void _updateBOffsides(int count) {
    setState(() {
      _rightStats.offsides = count;
    });
  }

  void _updateAFouls(int count) {
    setState(() {
      _leftStats.fouls = count;
    });
  }

  void _updateBFouls(int count) {
    setState(() {
      _rightStats.fouls = count;
    });
  }

  void _updateAYellows(int count) {
    setState(() {
      _leftStats.yellows = count;
    });
  }

  void _updateBYellows(int count) {
    setState(() {
      _rightStats.yellows = count;
    });
  }

  void _updateAReds(int count) {
    setState(() {
      _leftStats.reds = count;
    });
  }

  void _updateBReds(int count) {
    setState(() {
      _rightStats.reds = count;
    });
  }

  @override 
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    if (_gameInfo.aIsDefendingRight) {
      if (widget.gameHalf == 1) {
        _leftTeam = widget.game.teamB;
        _leftStats = widget.game.teamBStats;
        _rightTeam = widget.game.teamA; 
        _rightStats = widget.game.teamAStats;
      } else {
        _leftTeam = widget.game.teamA; 
        _leftStats = widget.game.teamAStats;
        _rightTeam = widget.game.teamB; 
        _rightStats = widget.game.teamBStats;
      }
    } else {
      if (widget.gameHalf == 1) {
        _leftTeam = widget.game.teamA;
        _leftStats = widget.game.teamAStats;
        _rightTeam = widget.game.teamB;
        _rightStats = widget.game.teamBStats;
      } else {
        _leftTeam = widget.game.teamB;
        _leftStats = widget.game.teamBStats;
        _rightTeam = widget.game.teamA;
        _rightStats = widget.game.teamAStats;
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
                  teamAbbrev: _leftTeam.abbrev, 
                  direction: 'LTR', 
                  teamColor: _leftTeam.color.toColor()!,
                  callback: _updateAGoals,
                ),
                const GameStatTitle(
                  title: 'Goals'
                ),
                GoalCounter(
                  teamAbbrev: _rightTeam.abbrev, 
                  direction: 'LTR', 
                  teamColor: _rightTeam.color.toColor()!,
                  callback: _updateBGoals,
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
