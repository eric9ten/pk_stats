import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pk_stats/models/team.dart';
import 'package:pk_stats/models/game_stats.dart';

final formatter = DateFormat.yMd();

class Game {
  Game({
    required this.date,
    required this.time,
    required this.location,
    required this.teamA,
    required this.teamB,
    required this.teamAStats,
    required this.teamBStats,
    required this.isAHome,
  });

  final DateTime date;
  final TimeOfDay time;
  final String location;
  Team teamA;
  Team teamB;
  final bool isAHome;
  GameStats teamAStats;
  GameStats teamBStats;
  bool? aIsDefendingRight;

  String get formattedDate {
    return formatter.format(date);
  }
}