import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

typedef GoalCallback = void Function(int val);

class GoalCounter extends StatefulWidget {
  const GoalCounter ({ super.key, 
    required this.teamAbbrev,
    required this.teamColor,
    required this.direction,
    required this.callback,
  });

  final String direction;
  final String teamAbbrev;
  final Color teamColor;
  final GoalCallback callback;

  @override
  State<GoalCounter> createState() {
    return _GoalCounter();
  }

}

class _GoalCounter extends State<GoalCounter>{
  int _goalCount = 0;
  final TextEditingController _goalCountController = TextEditingController(
    text: '0'
  ); 
  
  @override
  void initState() {
    super.initState();
    _goalCountController.addListener(_updateGoalCount);
  }  
  
  @override
  void dispose() {
    _goalCountController.dispose();
    super.dispose();
  }

  void _incrementGoalCount() {
    setState(() {
      _goalCount++;
      _goalCountController.text = _goalCount.toString();
      widget.callback(_goalCount);
    });
  }

  void _decrementGoalCount() {
    setState(() {
      if (_goalCount > 0 ) {
        _goalCount--; 
      } else {
        _goalCount = 0;
      }
      _goalCountController.text = _goalCount.toString();
      widget.callback(_goalCount);

    });
  }

  void _updateGoalCount() {
    setState((){
      final count = int.parse(_goalCountController.text);
      _goalCount = count;
    });
  } 

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center ,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.direction == 'LTR')...[
              Text( widget.teamAbbrev,                    
                style: GoogleFonts.dosis(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: widget.teamColor,
                ),
              ),
              const SizedBox(
                width: 12,
              )
            ],
            SizedBox(
              width: 30,
              child: TextField (
                controller: _goalCountController,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                maxLength: 2,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  fillColor: Color.fromARGB(255, 130, 130, 130),
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  
                ),
                showCursor: false,
                textAlign: TextAlign.center,                    
                style: GoogleFonts.dosis(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 36, 36, 36),
                ),
              ),
            ),
            if (widget.direction == 'RTL')...[
              const SizedBox(
                width: 16,
              ),
              Text( widget.teamAbbrev,                    
                style: GoogleFonts.dosis(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: widget.teamColor,
                ),
              ),
            ],
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: _decrementGoalCount,
              tooltip: 'Subtract Goal',
              icon: const Icon(
                Icons.remove,
                color: Color.fromARGB(255, 36, 36, 36),
              ),
            ),
            IconButton(
              onPressed: _incrementGoalCount,
              tooltip: 'Add Goal',
              icon: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 36, 36, 36),
              ),
            ),
        ],)
      ],
    );
  }
}
