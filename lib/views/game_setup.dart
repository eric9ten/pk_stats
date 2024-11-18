import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pk_stats/models/team.dart';
import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/views/goal_setup.dart';
import 'package:pk_stats/widgets/new_team.dart';
import 'package:pk_stats/models/game_stats.dart';

final formatter = DateFormat.yMd();
const timeFormatter = TimeOfDayFormat.HH_colon_mm;

class GameSetupView extends StatefulWidget {
  const GameSetupView({super.key, required this.game});
  final Game game;

  @override
  State<GameSetupView> createState() {
    return _GameSetupView();
  }
}

class _GameSetupView extends State<GameSetupView> {
  final _locationController = TextEditingController(text: 'TBD');
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late Team _teamA;
  late Team _teamB;
  bool _aIsHome = true;
  late Game _game;
  final int _gameHalf = 1;
  final GameStats _teamAStats = GameStats(goals: 0, shots: 0, corners: 0, goalKicks: 0,
        tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0);
  final GameStats _teamBStats = GameStats(goals: 0, shots: 0, corners: 0, goalKicks: 0,
        tackles: 0, offsides: 0, fouls: 0, yellows: 0, reds: 0);

  @override
  void initState() {
    super.initState();
     _game = widget.game;
     _teamA = _game.teamA;
     _teamB = _game.teamB;
  }

  void _openAddTeamAOverlay() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewTeam(onAddTeam: _addTeamA, team: _teamA),
    );
  }

  void _openAddTeamBOverlay() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewTeam(onAddTeam: _addTeamB, team: _teamB),
    );
  }

  void _addTeamA(Team teamA) {
    setState(() {
      _teamA = teamA;
    });
  }

  void _addTeamB(Team teamB) {
    setState(() {
      _teamB = teamB;
    });
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 1, now.month, now.day),
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _presentTimePicker() async {
    final now = TimeOfDay.now();
    final pickedTime = await showTimePicker(
        context: context,
        initialTime: now,
        initialEntryMode: TimePickerEntryMode.inputOnly);
    setState(() {
      _selectedTime = pickedTime;
    });
  }

  void _updateGame() {
    final date = _selectedDate;
    final time = _selectedTime;
    final location = _locationController.text;
    final teamA = _teamA;
    final teamAStats = _teamAStats;
    final teamBStats = _teamBStats;
    final teamB = _teamB;
    final isAHome = _aIsHome;
    

    if (date == null || time == null || teamA.name == '' || teamB.name == '') {
      showDialog(
        context: context, 
        builder: (ctx) => AlertDialog (
          title: const Text('Invalid Game Info'),
          content: const Text(
              'Please make sure a valid date, time, and teams was entered.'
            ),
          actions: [
            TextButton( 
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );

      return;
    }

    final game = Game (
      date: date,
      time: time,
      location: location,
      teamA: teamA,
      teamAStats: teamAStats,
      teamB: teamB,
      teamBStats: teamBStats,
      isAHome: isAHome,
    );

    Navigator.push(
      context, MaterialPageRoute(builder: (ctx) => 
        GoalSetupView(game: game, gameHalf: _gameHalf,
      ))
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext conntext) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    
    return Scaffold ( 
      appBar: AppBar (
        title: const Text('Game Details'),
        ),
      body: 
      SizedBox(
        width: double.infinity,
        child: SingleChildScrollView (
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                Text('Enter Game Details',
                  style: 
                    Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    )
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 70),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      _selectedDate == null
                          ? 'select a game date'
                          : formatter.format(_selectedDate!),
                      style:  
                        Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 70),
                    IconButton(
                      onPressed: _presentTimePicker,
                      icon: Icon(
                        Icons.schedule,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                        _selectedTime == null
                            ? 'enter the game time'
                            : _selectedTime!.format(context),
                        style: 
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _locationController,
                        maxLength: 50,
                        decoration: InputDecoration(
                          label: const Text('Game Location'),
                          fillColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row (
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 12),
                      child: Text( 
                        'Team A:',
                        style: 
                          Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          )
                      ),
                    ),
                    Text(
                        _teamA.name == '' ? 'Add team A' : _teamA.name,
                        style: 
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          )
                    ),
                    IconButton(
                      onPressed: _openAddTeamAOverlay, 
                      icon: Icon (_teamA.name != "" ? Icons.edit : Icons.add_circle_outline),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row (
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 16),
                      child: Text( 
                        'Team B:',
                        style: 
                          Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          )
                      ),
                    ),
                    Text(
                      _teamB.name == '' ? 'Add team B': _teamB.name,
                      style: 
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        )
                    ),
                    IconButton(
                      onPressed: _openAddTeamBOverlay, 
                      icon: Icon (_teamB.name != "" ? Icons.edit : Icons.add_circle_outline),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                const Row(
                  children: [
                    SizedBox(height: 30),
                  ]
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text('Home Team',
                        style:  
                          Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          )
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text('A',
                      style:  
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        )
                    ),
                    const SizedBox(width: 10),
                    Switch(
                      value: _aIsHome,
                      activeColor: Theme.of(context).colorScheme.primary,
                      inactiveThumbColor: Theme.of(context).colorScheme.onPrimary,
                      onChanged: (bool value) {
                        setState(() {
                          _aIsHome = value;
                        });
                      }
                    ),
                    const SizedBox(width: 10),
                    Text('B',
                      style:  
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        )
                    ),
                  ],
                ),
                const Row(
                  children: [
                    SizedBox(height: 48),
                  ]
                ),
                Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _updateGame,  
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                      ),
                      child: Text(
                        'To Goal Setup',
                        style:
                          Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ),
                    ),
                  ]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
