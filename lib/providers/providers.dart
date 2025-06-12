import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/models/team.dart';
import 'package:pk_stats/models/game_stats.dart';

extension ColorExtension on Color {
  String toHexString() {
    return value.toRadixString(16).padLeft(8, '0').toUpperCase();
  }

  static Color toColor(String hex) {
    String cleanedHex = hex.replaceFirst('#', '');
    return Color(int.parse(cleanedHex, radix: 16));
  }
}

enum StatType {
  goals,
  passes,
  shots,
  corners,
  goalKicks,
  tackles,
  offsides,
  fouls,
  yellows,
  reds,
}

final gameListProvider = StateProvider<List<Game>>((ref) => []);

final teamListProvider = StateProvider<List<Team>>((ref) => [
      Team(name: '', abbrev: '', color: '#FFFFFF'), // Team A
      Team(name: '', abbrev: '', color: '#000000'), // Team B
    ]);

final isAHomeProvider = StateProvider<bool>((ref) => false);
final locationProvider = StateProvider<String>((ref) => 'TBD');

final aIsDefendingRightProvider = StateProvider<bool>((ref) => false);

final gameHalfProvider = StateProvider<int>((ref) => 1);

final leftStatsProvider = StateProvider<GameStats>((ref) => GameStats());
final rightStatsProvider = StateProvider<GameStats>((ref) => GameStats());