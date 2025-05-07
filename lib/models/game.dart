import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pk_stats/models/team.dart';
import 'package:pk_stats/models/game_stats.dart';

final formatter = DateFormat.yMd();
const timeFormat = TimeOfDayFormat.HH_colon_mm;

class Game {
  Game({
    required this.id,
    this.location,
    this.teamA,
    this.teamB,
    this.teamAStats,
    this.teamBStats,
    this.isAHome,
    this.aIsDefendingRight,
    this.date,
    this.time,
  });

  final String id;
  DateTime? date;
  TimeOfDay? time;
  String? location;
  Team? teamA;
  Team? teamB;
  bool? isAHome;
  GameStats? teamAStats;
  GameStats? teamBStats;
  bool? aIsDefendingRight;

  String get formattedDate {
    if (date != null) {
      return DateFormat.yMd().format(date!);
    } else {
      return '';
    }
  }

  String get formattedTime {
    if (time != null) {
      return '${time!.hour}:${time!.minute.toString().padLeft(2, '0')} ${time!.period == DayPeriod.am ? 'AM' : 'PM'}';
    } else {
      return '';
    }
  }
}