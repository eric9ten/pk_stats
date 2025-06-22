import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:pk_stats/providers/providers.dart';
import 'package:pk_stats/models/game_stats.dart';

import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/models/team.dart';
import 'package:pk_stats/widgets/goal_counter.dart';
import 'package:pk_stats/widgets/stat_counter.dart';
import 'package:pk_stats/widgets/game_stat_title.dart';
import 'package:pk_stats/views/game_review.dart';
import 'package:pk_stats/widgets/ad_banner.dart';

class GameTrackerView extends ConsumerStatefulWidget {
  const GameTrackerView ({super.key});

  @override
  ConsumerState<GameTrackerView> createState() {
    return _GameTrackerViewState();
  }
}

class _GameTrackerViewState extends ConsumerState<GameTrackerView> {
  Future<void> _toReview(BuildContext context) async {
    final games = ref.read(gameListProvider);
    final gameHalf = ref.read(gameHalfProvider);
    if (games.isEmpty) {
      _showErrorDialog('No game data available');
      return;
    }

    final game = games.first;
    final updatedGame = _updateGameStats(game, gameHalf);
    ref.read(gameListProvider.notifier).update((state) => [updatedGame]);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameReviewView(),
      ),
    );
    
    if (context.mounted && result != null && result is int) {
      ref.read(gameHalfProvider.notifier).state = result;
      if (result == 2) {
        // Swap stats between leftStatsProvider and rightStatsProvider for GameTrackerView
        final leftStats = ref.read(leftStatsProvider);
        final rightStats = ref.read(rightStatsProvider);
        ref.read(leftStatsProvider.notifier).state = rightStats;
        ref.read(rightStatsProvider.notifier).state = leftStats;
        WakelockPlus.enable(); // Re-enable WakelockPlus for second half
      }
    }

  }

  void _resetTracker() {    
    showDialog(
        context: context, 
        builder: (ctx) => AlertDialog (
          title: const Text('Confirm Reset'),
          content: const Text(
              'Are you sure you want to reset the game stats?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _resetStats();
                Navigator.pop(ctx);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
  }

  void _resetStats() {
    final games = ref.read(gameListProvider);
    if (games.isNotEmpty) {
      final game = games.first;
      ref.read(gameListProvider.notifier).update((state) => [
            Game(
              id: game.id,
              location: game.location,
              teamA: game.teamA,
              teamB: game.teamB,
              teamAStats: GameStats(),
              teamBStats: GameStats(),
              isAHome: game.isAHome,
              date: game.date,
              time: game.time,
              aIsDefendingRight: game.aIsDefendingRight,
            )
          ]);
    }
    ref.read(leftStatsProvider.notifier).state = GameStats();
    ref.read(rightStatsProvider.notifier).state = GameStats();
    ref.read(gameHalfProvider.notifier).state = 1;
  }

Game _updateGameStats(Game game, int gameHalf) {
    final aIsDefendingRight = ref.read(aIsDefendingRightProvider);
    final leftStats = ref.read(leftStatsProvider);
    final rightStats = ref.read(rightStatsProvider);

    GameStats? teamAStats;
    GameStats? teamBStats;

    if (gameHalf == 1) {
      teamAStats = aIsDefendingRight ? rightStats : leftStats;
      teamBStats = aIsDefendingRight ? leftStats : rightStats;
    } else {
      teamAStats = aIsDefendingRight ? rightStats : leftStats;
      teamBStats = aIsDefendingRight ? leftStats : rightStats;
    }

    return Game(
      id: game.id,
      location: game.location,
      teamA: game.teamA,
      teamB: game.teamB,
      teamAStats: teamAStats,
      teamBStats: teamBStats,
      isAHome: game.isAHome,
      date: game.date,
      time: game.time,
      aIsDefendingRight: aIsDefendingRight,
    );
  }

  void _updateStat({
  required StatType statType,
  required int count,
  required bool isLeft,
  }) {
    final provider = isLeft ? leftStatsProvider : rightStatsProvider;
    ref.read(provider.notifier).update((state) => GameStats(
          goals: statType == StatType.goals ? count : state.goals,
          passes: statType == StatType.passes ? count : state.passes,
          shots: statType == StatType.shots ? count : state.shots,
          corners: statType == StatType.corners ? count : state.corners,
          goalKicks: statType == StatType.goalKicks ? count : state.goalKicks,
          tackles: statType == StatType.tackles ? count : state.tackles,
          offsides: statType == StatType.offsides ? count : state.offsides,
          fouls: statType == StatType.fouls ? count : state.fouls,
          yellows: statType == StatType.yellows ? count : state.yellows,
          reds: statType == StatType.reds ? count : state.reds,
      ));
  }
  
  void _updateLeftGoals(int count) => _updateStat(statType: StatType.goals, count: count, isLeft: true);
  void _updateRightGoals(int count) => _updateStat(statType: StatType.goals, count: count, isLeft: false);
  void _updateLeftPasses(int count) => _updateStat(statType: StatType.passes, count: count, isLeft: true);
  void _updateRightPasses(int count) => _updateStat(statType: StatType.passes, count: count, isLeft: false);
  void _updateLeftShots(int count) => _updateStat(statType: StatType.shots, count: count, isLeft: true);
  void _updateRightShots(int count) => _updateStat(statType: StatType.shots, count: count, isLeft: false);
  void _updateLeftCorners(int count) => _updateStat(statType: StatType.corners, count: count, isLeft: true);
  void _updateRightCorners(int count) => _updateStat(statType: StatType.corners, count: count, isLeft: false);
  void _updateLeftGoalKicks(int count) => _updateStat(statType: StatType.goalKicks, count: count, isLeft: true);
  void _updateRightGoalKicks(int count) => _updateStat(statType: StatType.goalKicks, count: count, isLeft: false);
  void _updateLeftTackles(int count) => _updateStat(statType: StatType.tackles, count: count, isLeft: true);
  void _updateRightTackles(int count) => _updateStat(statType: StatType.tackles, count: count, isLeft: false);
  void _updateLeftOffsides(int count) => _updateStat(statType: StatType.offsides, count: count, isLeft: true);
  void _updateRightOffsides(int count) => _updateStat(statType: StatType.offsides, count: count, isLeft: false);
  void _updateLeftFouls(int count) => _updateStat(statType: StatType.fouls, count: count, isLeft: true);
  void _updateRightFouls(int count) => _updateStat(statType: StatType.fouls, count: count, isLeft: false);
  void _updateLeftYellows(int count) => _updateStat(statType: StatType.yellows, count: count, isLeft: true);
  void _updateRightYellows(int count) => _updateStat(statType: StatType.yellows, count: count, isLeft: false);
  void _updateLeftReds(int count) => _updateStat(statType: StatType.reds, count: count, isLeft: true);
  void _updateRightReds(int count) => _updateStat(statType: StatType.reds, count: count, isLeft: false);

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override 
  Widget build(BuildContext context) {
    final games = ref.watch(gameListProvider);
    final gameHalf = ref.watch(gameHalfProvider);

    if (games.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Game Tracker')),
        body: const Center(child: Text('No game data available')),
      );
    }

    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final game = games.first;

    Team leftTeam;
    Team rightTeam;
    GameStats leftStats = ref.watch(leftStatsProvider);
    GameStats rightStats = ref.watch(rightStatsProvider);

    final aIsDefendingRight = ref.watch(aIsDefendingRightProvider);
    leftTeam = aIsDefendingRight ? game.teamB! : game.teamA!;
    rightTeam = aIsDefendingRight ? game.teamA! : game.teamB!;

    final displayHalf = (gameHalf >= 1 && gameHalf <= 2) ? gameHalf : 1;
    final buttonLabel = displayHalf == 1 ? 'Halftime' : 'End Game';

    WakelockPlus.enable();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Tracker'),
      ),
      body: 
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints){
            return SingleChildScrollView(
              child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight),
                child: IntrinsicHeight(
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
                            teamColor: leftTeam.color,
                            callback: _updateLeftGoals,
                            goalCount: leftStats.goals,
                          ),
                          const GameStatTitle(
                            title: 'Goals'
                          ),
                          GoalCounter(
                            teamAbbrev: rightTeam.abbrev, 
                            direction: 'LTR', 
                            teamColor: rightTeam.color,
                            callback: _updateRightGoals,
                            goalCount: rightStats.goals,
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
                            statCount: leftStats.passes,
                          ),
                          const GameStatTitle(
                            title: 'Passes'
                          ),
                          StatCounter(
                            direction: 'RTL',
                            callback: _updateRightPasses,
                            statCount: rightStats.passes,
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
                            statCount: leftStats.shots,
                          ),
                          const GameStatTitle(
                            title: 'Shots'
                          ),
                          StatCounter(
                            direction: 'RTL',
                            callback: _updateRightShots,
                            statCount: rightStats.shots,
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
                            statCount: leftStats.tackles,
                          ),
                          const GameStatTitle(
                            title: 'Tackles',
                          ),
                          StatCounter(
                            direction: 'RTL',
                            callback: _updateRightTackles,
                            statCount: rightStats.tackles,
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
                            statCount: leftStats.corners,
                          ),
                          const GameStatTitle(
                            title: 'Corners',
                          ),
                          StatCounter(
                            direction: 'RTL',
                            callback: _updateRightCorners,
                            statCount: rightStats.corners,
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
                            statCount: leftStats.goalKicks,
                          ),
                          const GameStatTitle(
                            title: 'Goal Kicks',
                          ),
                          StatCounter(
                            direction: 'RTL',
                            callback: _updateRightGoalKicks,
                            statCount: rightStats.goalKicks,
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
                            statCount: leftStats.offsides,
                          ),
                          const GameStatTitle(
                            title: 'Offsides',
                          ),
                          StatCounter(
                            direction: 'RTL',
                            callback: _updateRightOffsides,
                            statCount: rightStats.offsides,
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
                            statCount: leftStats.fouls,
                          ),
                          const GameStatTitle(
                            title: 'Fouls',
                          ),
                          StatCounter(
                            direction: 'RTL',
                            callback: _updateRightFouls,
                            statCount: rightStats.fouls,
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
                            statCount: leftStats.yellows,
                          ),
                          const GameStatTitle(
                            title: 'Yellow Cards',
                          ),
                          StatCounter(
                            direction: 'RTL',
                            callback: _updateRightYellows,
                            statCount: rightStats.yellows,
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
                            statCount: leftStats.reds,
                          ),
                          const GameStatTitle(
                            title: 'Red Cards',
                          ),
                          StatCounter(
                            direction: 'RTL',
                            callback: _updateRightReds,
                            statCount: rightStats.reds,
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
                            onPressed: _resetTracker, 
                            icon: const Icon(Icons.replay),
                          ),
                          TextButton(
                            onPressed: () { 
                              _toReview(context);
                              WakelockPlus.disable();
                            },  
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                            ),
                            child: Text(
                              buttonLabel,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
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
              ),
            );
          }
        ),
    );
  }
}
