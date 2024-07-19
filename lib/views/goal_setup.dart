import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pk_stats/models/game.dart';

class GoalSetupView extends StatefulWidget {
  const GoalSetupView ({ super.key});

  @override 
  State<GoalSetupView> createState() {
    return _GoalSetupView();
  }

}

class _GoalSetupView extends State<GoalSetupView> {

  @override 
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    bool _aIsDefendingRight = false;

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
          child: Column(
            children: [
              Text('Goal Setup',
                style: GoogleFonts.dosis(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                )
              ),
              const SizedBox(height: 20),
              Text('Which goal is Team A defending?',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Left',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                      )),
                  const SizedBox(width: 10),
                  Switch(
                    value: _aIsDefendingRight,
                    activeColor: const Color.fromARGB(255, 192, 115, 0),
                    inactiveThumbColor: const Color.fromARGB(255, 255, 152, 0),
                    onChanged: (bool value) {
                      setState(() {
                        _aIsDefendingRight = value;
                      });
                    }
                  ),
                  const SizedBox(width: 10),
                  Text('Right',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
