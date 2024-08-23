import 'package:flutter/material.dart';

class GameStatTitle extends StatelessWidget {
  const GameStatTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context){
    return SizedBox(
        width: 63,
        child: Text(title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 16, 16, 16),
          )
        ),
    );
  }
}