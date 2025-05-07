import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/team.dart';

class TeamNotifier extends StateNotifier<Team> {

  TeamNotifier() : super(
    Team(
      name: '',
      abbrev: '',
      color: '',
    ));

  void updateTeam(Team team) {
    state = team;
  }
}

final teamProvider = StateNotifierProvider<TeamNotifier, Team>((ref){
  return TeamNotifier();
});