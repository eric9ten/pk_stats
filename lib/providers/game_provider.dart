import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pk_stats/providers/team_provider.dart';
import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/models/game_stats.dart';
import 'package:pk_stats/models/team.dart';

class GameNotifier extends StateNotifier<Game> {
  
  GameNotifier() : super(
    Game(
      id: '',
      date: null,
      time: null, 
      location: '', 
      teamA: null, 
      teamB: null, 
      teamAStats: null, 
      teamBStats: null, 
      isAHome: true,
    ));


  void updateGame(Game game) {
    state = game;
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, Game>((ref){
  ref.watch(teamProvider);
  return GameNotifier();
});