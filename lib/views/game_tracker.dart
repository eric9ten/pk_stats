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
  GameTrackerView ({ super.key, required this.game, required this.gameHalf});

  final Game game;
  int gameHalf;

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
  final Game _gameInfo =  Game(date: DateTime.now(), time: TimeOfDay.now(), location: '', 
    teamA: Team(name: '', abbrev: '', color: ''),
    teamB: Team(name: '', abbrev: '', color: ''),
    teamAStats: GameStats(goals: 0, shots: 0, corners: 0, goalKicks: 0,
      tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0),
    teamBStats: GameStats(goals: 0, shots: 0, corners: 0, goalKicks: 0,
      tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0),
    isAHome: true);
  int _gameHalf = 1;

  Future<void> _toReview(BuildContext context) async {
    if (widget.game.aIsDefendingRight) {
      if (widget.gameHalf == 1) {
        widget.game.teamB = _leftTeam;
        widget.game.teamBStats = _leftStats;
        widget.game.teamA = _rightTeam;
        widget.game.teamAStats = _rightStats;
      } else {
        widget.game.teamA = _leftTeam;
        widget.game.teamAStats = _leftStats;
        widget.game.teamB = _rightTeam;
        widget.game.teamBStats = _rightStats;
      }
    } else {
      if (widget.gameHalf == 1) {
        widget.game.teamA = _leftTeam;
        widget.game.teamAStats = _leftStats;
        widget.game.teamB = _rightTeam;
        widget.game.teamBStats = _rightStats;
      } else {
        widget.game.teamB = _leftTeam;
        widget.game.teamBStats = _leftStats;
        widget.game.teamA = _rightTeam;
        widget.game.teamAStats = _rightStats;
      }
    }

    final result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => 
         GameReviewView(game: widget.game, gameHalf: widget.gameHalf)
      )
    );

    if(context.mounted) {
      setState(() {
        _gameHalf = result;
        widget.gameHalf = result;
      });
    }
  }

  void _updateTeams() {
    
    if (_gameInfo.aIsDefendingRight) {
      if (_gameHalf == 1) {
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
      if (_gameHalf == 1) {
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

  }

  void _updateLeftGoals(int count) {
    setState(() {
      _leftStats.goals = count;
    });
  }

  void _updateRightGoals(int count) {
    setState(() {
      _rightStats.goals = count;
    });
  }

  void _updateLeftPasses(int count) {
    setState(() {
      _leftStats.passes = count;
    });
  }

  void _updateRightPasses(int count) {
    setState(() {
      _rightStats.passes = count;
    });
  }

  void _updateLeftShots(int count) {
    setState(() {
      _leftStats.shots = count;
    });
  }

  void _updateRightShots(int count) {
    setState(() {
      _rightStats.shots = count;
    });
  }

  void _updateLeftCorners(int count) {
    setState(() {
      _leftStats.corners = count;
    });
  }

  void _updateRightCorners(int count) {
    setState(() {
      _rightStats.corners = count;
    });
  }

  void _updateLeftGoalKicks(int count) {
    setState(() {
      _leftStats.goalKicks = count;
    });
  }

  void _updateRightGoalKicks(int count) {
    setState(() {
      _rightStats.goalKicks = count;
    });
  }

  void _updateLeftTackles(int count) {
    setState(() {
      _leftStats.tackles = count;
    });
  }

  void _updateRightTackles(int count) {
    setState(() {
      _rightStats.tackles = count;
    });
  }

  void _updateLeftOffsides(int count) {
    setState(() {
      _leftStats.offsides = count;
    });
  }

  void _updateRightOffsides(int count) {
    setState(() {
      _rightStats.offsides = count;
    });
  }

  void _updateLeftFouls(int count) {
    setState(() {
      _leftStats.fouls = count;
    });
  }

  void _updateRightFouls(int count) {
    setState(() {
      _rightStats.fouls = count;
    });
  }

  void _updateLeftYellows(int count) {
    setState(() {
      _leftStats.yellows = count;
    });
  }

  void _updateRightYellows(int count) {
    setState(() {
      _rightStats.yellows = count;
    });
  }

  void _updateLeftReds(int count) {
    setState(() {
      _leftStats.reds = count;
    });
  }

  void _updateRightReds(int count) {
    setState(() {
      _rightStats.reds = count;
    });
  }

  @override 
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    
    String buttonLabel = 'End 1st Half';
    if ( widget.gameHalf == 2) {
      buttonLabel = 'End 2nd Half';
    }

    _updateTeams();
    
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
                  callback: _updateLeftGoals,
                  goalCount: _leftStats.goals,
                ),
                const GameStatTitle(
                  title: 'Goals'
                ),
                GoalCounter(
                  teamAbbrev: _rightTeam.abbrev, 
                  direction: 'LTR', 
                  teamColor: _rightTeam.color.toColor()!,
                  callback: _updateRightGoals,
                  goalCount: _rightStats.goals,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatCounter(
                  direction: 'LTR',
                  callback: _updateLeftPasses,
                  statCount: _leftStats.passes,
                ),
                const GameStatTitle(
                  title: 'Passes'
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateRightPasses,
                  statCount: _rightStats.passes,
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
                  callback: _updateLeftShots,
                  statCount: _leftStats.shots,
                ),
                const GameStatTitle(
                  title: 'Shots'
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateRightShots,
                  statCount: _rightStats.shots,
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
                  callback: _updateLeftCorners,
                  statCount: _leftStats.corners,
                ),
                const GameStatTitle(
                  title: 'Corners',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateRightCorners,
                  statCount: _rightStats.corners,
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
                  callback: _updateLeftGoalKicks,
                  statCount: _leftStats.goalKicks,
                ),
                const GameStatTitle(
                  title: 'Goal Kicks',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateRightGoalKicks,
                  statCount: _rightStats.goalKicks,
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
                  callback: _updateLeftTackles,
                  statCount: _leftStats.tackles,
                ),
                const GameStatTitle(
                  title: 'Tackles',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateRightTackles,
                  statCount: _rightStats.tackles,
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
                  callback: _updateLeftOffsides,
                  statCount: _leftStats.offsides,
                ),
                const GameStatTitle(
                  title: 'Offsides',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateRightOffsides,
                  statCount: _rightStats.offsides,
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
                  callback: _updateLeftFouls,
                  statCount: _leftStats.fouls,
                ),
                const GameStatTitle(
                  title: 'Fouls',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateRightFouls,
                  statCount: _rightStats.fouls,
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
                  callback: _updateLeftYellows,
                  statCount: _leftStats.yellows,
                ),
                const GameStatTitle(
                  title: 'Yellow Cards',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateRightYellows,
                  statCount: _rightStats.yellows,
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
                  callback: _updateLeftReds,
                  statCount: _leftStats.reds,
                ),
                const GameStatTitle(
                  title: 'Red Cards',
                ),
                StatCounter(
                  direction: 'RTL',
                  callback: _updateRightReds,
                  statCount: _rightStats.reds,
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
                IconButton(
                  onPressed: () {}, 
                  icon: const Icon(Icons.restart_alt),
                ),
                TextButton(
                  onPressed: () { 
                    _toReview(context);
                  },  
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                  ),
                  child: Text(
                    buttonLabel,
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
