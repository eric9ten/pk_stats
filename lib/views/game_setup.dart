import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/views/goal_setup.dart';
import 'package:pk_stats/widgets/ad_banner.dart';
import 'package:pk_stats/widgets/new_team.dart';
import 'package:pk_stats/models/game_stats.dart';
import 'package:pk_stats/providers/providers.dart';

final formatter = DateFormat.yMd();
const timeFormatter =  TimeOfDayFormat.HH_colon_mm;

class GameSetupView extends ConsumerStatefulWidget {
  const GameSetupView({super.key});

  @override
  ConsumerState<GameSetupView> createState() {
    return _GameSetupViewState();
  }
}

class _GameSetupViewState extends ConsumerState<GameSetupView> {
  final _teamANameController = TextEditingController();
  final _teamBNameController = TextEditingController();
  final _locationController = TextEditingController(text: 'TBD'); // Default to TBD
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isAHome = true;
  String? _errorMessage;


  @override
  void initState() {
    super.initState();
    final games = ref.read(gameListProvider);
    if (games.isNotEmpty) {
      final game = games.first;
      _teamANameController.text = game.teamA?.name ?? '';
      _teamBNameController.text = game.teamB?.name ?? '';
      _locationController.text = 'TBD';
      _isAHome = game.isAHome ?? true;
    }  
  }

  @override
  void dispose() {
    _teamANameController.dispose();
    _teamBNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _errorMessage = null;
      });
    }
  }

  Future<void> _presentTimePicker() async {
    final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.inputOnly
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _errorMessage = null;
      });
    }
  }

  void _openAddTeamAOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, child) {
            final teams = ref.watch(teamListProvider);
            return NewTeam(
              teamIndex: 0,
              team: teams[0],
            );
          },
        );
      },
    );
  }

  void _openAddTeamBOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, child) {
            final teams = ref.watch(teamListProvider);
            return NewTeam(
              teamIndex: 1,
              team: teams[1],
            );
          },
        );
      },
    );
  }

  void _updateGame() {
    final teams = ref.read(teamListProvider);
    final teamA = teams[0];
    final teamB = teams[1];
    final location = _locationController.text.trim().isEmpty ? 'TBD' : _locationController.text.trim();
    final isAHome = ref.read(isAHomeProvider);
    final date = _selectedDate;
    final time = _selectedTime;
    
    if (
      date == null || 
      time == null || 
      teamA.name.isEmpty || 
      teamB.name.isEmpty
    ) {
      showDialog(
        context: context, 
        builder: (ctx) => AlertDialog (
          title: const Text('Invalid Game Info'),
          content: const Text(
              'Please make sure a valid date, time, and team names were entered.'
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

    final updatedGame = Game(
      id: const Uuid().v4(),
      location: location,
      teamA: teamA,
      teamAStats: GameStats(),
      teamB: teamB,
      teamBStats: GameStats(),
      isAHome: isAHome,
      date: date,
      time: time,
      aIsDefendingRight: false,
    );

    ref.read(gameListProvider.notifier).update((state) => [updatedGame]);
    ref.read(leftStatsProvider.notifier).state = GameStats();
    ref.read(rightStatsProvider.notifier).state = GameStats();
    ref.read(gameHalfProvider.notifier).state = 1;
    ref.read(aIsDefendingRightProvider.notifier).state = false;

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (ctx) => const GoalSetupView(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final teams = ref.watch(teamListProvider);
    final teamA = teams[0];
    final teamB = teams[1];
    final isAHome = ref.watch(isAHomeProvider);
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold ( 
      appBar: AppBar (
        title: const Text('Game Details'),
        ),
      body: 
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                  child: ConstrainedBox (
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
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
                                    : DateFormat.yMd().format(_selectedDate!),
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
                                  teamA.name.isEmpty ? 'Add team A' : teamA.name,
                                  style: 
                                    Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                    )
                              ),
                              IconButton(
                                onPressed: _openAddTeamAOverlay, 
                                icon: Icon (teamA.name.isNotEmpty 
                                  ? Icons.edit 
                                  : Icons.add_circle_outline
                                ),
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
                                teamB.name.isEmpty 
                                  ? 'Add team B'
                                  : teamB.name,
                                style: 
                                  Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                  )
                              ),
                              IconButton(
                                onPressed: _openAddTeamBOverlay, 
                                icon: Icon (
                                  teamB.name.isNotEmpty 
                                  ? Icons.edit 
                                  : Icons.add_circle_outline
                                ),
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
                                value: isAHome,
                                activeColor: Theme.of(context).colorScheme.primary,
                                inactiveThumbColor: Theme.of(context).colorScheme.onPrimary,
                                onChanged: (bool value) {
                                  ref.read(isAHomeProvider.notifier).state = value;
                                },
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
                          const Spacer(
                            flex: 1,
                          ),
                          MyBannerAdWidget(),
                        ],
                      ),
                    ),
                  ),
              );
            }
          )
    );
  }
}
