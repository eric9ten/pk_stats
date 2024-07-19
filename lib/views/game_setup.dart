import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pk_stats/models/team.dart';
import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/widgets/new_team.dart';

final formatter = DateFormat.yMd();
const timeFormatter = TimeOfDayFormat.HH_colon_mm;

class GameSetupView extends StatefulWidget {
  const GameSetupView({super.key});

  @override
  State<GameSetupView> createState() {
    return _GameSetupView();
  }
}

class _GameSetupView extends State<GameSetupView> {
  final _locationController = TextEditingController(text: 'TBD');
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Team? _teamA;
  Team? _teamB;
  bool _aIsHome = true;
  Game? _game;

  void _openAddTeamAOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewTeam(onAddTeam: _addTeamA),
    );
  }

  void _openAddTeamBOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewTeam(onAddTeam: _addTeamB),
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
    final teamB = _teamB;
    final isAHome = _aIsHome;

    if (date == null || time == null || teamA == null || teamB == null) {
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

    _game = Game (
      date: date,
      time: time,
      location: location,
      teamA: teamA,
      teamB: teamB,
      isAHome: isAHome,
    );

    print('GAME UPDATED... $_game');
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext conntext) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView (
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
          child: Column(
            children: [
              Text('Game Details',
                  style: GoogleFonts.dosis(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _presentDatePicker,
                    icon: const Icon(
                      Icons.calendar_month,
                      color:Color.fromARGB(255, 255, 152, 0),
                    ),
                  ),
                  Text(
                      _selectedDate == null
                          ? 'select a game date'
                          : formatter.format(_selectedDate!),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _presentTimePicker,
                    icon: const Icon(
                      Icons.schedule,
                      color: Color.fromARGB(255, 255, 152, 0),
                    ),
                  ),
                  Text(
                      _selectedTime == null
                          ? 'enter the game time'
                          : _selectedTime!.format(context),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                      )),
                ],
              ),
              // const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _locationController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Game Location'),
                        fillColor: Color.fromARGB(255, 130, 130, 130),
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
                      style: GoogleFonts.inter (
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )
                    ),
                  ),
                  Text(
                      _teamA?.name ?? 'Add team A',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                      )
                  ),
                  IconButton(
                    onPressed: _openAddTeamAOverlay, 
                    icon: Icon (_teamA?.name != "" ? Icons.edit : Icons.add_circle_outline),
                    color:  const Color.fromARGB(255, 255, 152, 0),
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
                      style: GoogleFonts.inter (
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )
                    ),
                  ),
                  Text(
                    _teamB?.name ?? 'Add team B',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                    )
                  ),
                  IconButton(
                    onPressed: _openAddTeamBOverlay, 
                    icon: Icon (_teamB?.name != "" ? Icons.edit : Icons.add_circle_outline),
                    color:  const Color.fromARGB(255, 255, 152, 0),
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
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  const SizedBox(width: 20),
                  Text('A',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                      )),
                  const SizedBox(width: 10),
                  Switch(
                    value: _aIsHome,
                    activeColor: const Color.fromARGB(255, 192, 115, 0),
                    inactiveThumbColor: const Color.fromARGB(255, 255, 152, 0),
                    onChanged: (bool value) {
                      setState(() {
                        _aIsHome = value;
                      });
                    }
                  ),
                  const SizedBox(width: 10),
                  Text('B',
                    style: GoogleFonts.inter(
                      fontSize: 12,
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
                      textStyle: GoogleFonts.inter (
                        fontSize: 12,
                        color:  const Color.fromARGB(255, 130, 130, 130),
                      ),
                      padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                    ),
                    child: const Text(
                      'Track Game',
                      style: TextStyle(
                        fontSize: 24,
                      )
                    ),
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}
