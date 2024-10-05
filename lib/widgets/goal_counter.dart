import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pk_stats/widgets/colored_title.dart';

typedef GoalCallback = void Function(int val);

class GoalCounter extends StatefulWidget {
  const GoalCounter ({ super.key, 
    required this.teamAbbrev,
    required this.teamColor,
    required this.direction,
    required this.callback,
    required this.goalCount,
  });

  final String direction;
  final String teamAbbrev;
  final String teamColor;
  final GoalCallback callback;
  final int goalCount;

  @override
  State<GoalCounter> createState() {
    return _GoalCounter();
  }

}

class _GoalCounter extends State<GoalCounter>{

  late TextEditingController _goalCountController;
  
  @override
  void initState() {
    super.initState();
    _goalCountController = TextEditingController( text: widget.goalCount.toString());
  }  

  @override
  void didUpdateWidget (GoalCounter previousState) {
    super.didUpdateWidget(previousState);
    _goalCountController = TextEditingController( text: widget.goalCount.toString());
  }
  
  @override
  void dispose() {
    _goalCountController.dispose();
    super.dispose();
  }

  void _incrementGoalCount() {
    setState(() {
      int currentValue = int.parse(_goalCountController.text);
      currentValue++;
      _goalCountController.text = currentValue.toString();
      widget.callback(currentValue);
    });
  }

  void _decrementGoalCount() {
    setState(() {
      int currentValue = int.parse(_goalCountController.text);
      if (currentValue > 0 ) {
        currentValue--; 
      } else {
        currentValue = 0;
      }
      _goalCountController.text = currentValue.toString();
      widget.callback(currentValue);
    });
  }

  void _updateGoalCount() {
    setState((){
      int currentValue = int.parse(_goalCountController.text);
      final count = int.parse(_goalCountController.text);
      currentValue = count;
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
              ColoredTitle(
                title: widget.teamAbbrev,
                color: widget.teamColor,
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
              ColoredTitle(
                title: widget.teamAbbrev,
                color: widget.teamColor,
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
