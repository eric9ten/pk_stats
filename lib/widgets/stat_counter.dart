import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

typedef StatCallback = void Function(int val);

class StatCounter extends StatefulWidget {
  const StatCounter ({ 
    super.key,
    required this.direction,
    required this.callback, 
    });

  final String direction;
  final StatCallback callback;

  @override
  State<StatCounter> createState() {
    return _StatCounter();
  }

}

class _StatCounter extends State<StatCounter>{
  int _statCount = 0;
  final TextEditingController _statCountController = TextEditingController(
    text: '0'
  ); 

  void _incrementStatCount() {
    // setState(() {
      _statCount++;
      _statCountController.text = _statCount.toString();
      widget.callback(_statCount);
    // });
  }

  void _decrementStatCount() {
    setState(() {
      if (_statCount > 0 ) {
        _statCount--; 
      } else {
        _statCount = 0;
      }
      _statCountController.text = _statCount.toString();
      widget.callback(_statCount);


    });
  }

  @override
  Widget build(BuildContext context) {
  
  const double textWidth = 55;

  return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.direction == 'RTL')...[
            SizedBox(
              width: textWidth,
              child: TextField (
                controller: _statCountController,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                maxLength: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  counterText: '',
                  fillColor: Color.fromARGB(255, 130, 130, 130),
                  contentPadding: EdgeInsets.all(5),
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
          ],
          IconButton(
            onPressed: _decrementStatCount,
            tooltip: 'Decrease Stat',
            icon: const Icon(
              Icons.remove,
              color: Color.fromARGB(255, 36, 36, 36),
            ),
          ),
          IconButton(
            onPressed: _incrementStatCount,
            tooltip: 'Increase Stat',
            icon: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 36, 36, 36),
            ),
          ),
          if (widget.direction == 'LTR')...[
            SizedBox(
            width: textWidth,
            child: TextField (
              controller: _statCountController,
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              maxLength: 2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
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
          ],
        ]
    );
  }
}
