import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:pk_stats/models/team.dart';

class NewTeam extends StatefulWidget {
  const NewTeam({super.key, required this.onAddTeam, required this.team});
  final void Function(Team team) onAddTeam;
  final Team team;

  @override
  State<NewTeam> createState() {
    return _NewTeamState();
  }
}

class _NewTeamState extends State<NewTeam> {
  String _abbrev = '';
  late TextEditingController _nameController; // = TextEditingController(text:'To Be Announced');
  late TextEditingController _abbrevController; // = TextEditingController(text:'TBA');
  late Color? _teamColor;

  void _updateTeam() {
    final teamName = _nameController.text.trim();
    final teamAbbrev = _abbrevController.text;
    final teamColor = _teamColor;

    if (teamName.isEmpty || teamAbbrev.isEmpty ) {
      showDialog(
        context: context, 
        builder: (ctx) => AlertDialog (
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid team name and abbreviation was entered.'),
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

    widget.onAddTeam(
      Team (
        abbrev: teamAbbrev,
        name: teamName,
        color: teamColor!.toHexString(),

      )
    );
    Navigator.pop(context);
  }

  void _presentColorPicker() {    
    final availColors = [ Colors.black, Colors.grey, Colors.white, Colors.red, Colors.orange, Colors.yellow,
      Colors.green, Colors.blue, Colors.blueGrey, Colors.indigo, Colors.purple, Colors.brown ];
    
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick the team\'s color!'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
                child: BlockPicker(
                  availableColors: availColors,
                  pickerColor: _teamColor,
                  onColorChanged: (Color color) {
                    setState(() {
                      _teamColor = color;
                    });
                  },
                ),
              ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context)
                      .pop();
                },
              ),
            ],
          );
        });
    return;
  }

  void _getAbbreviation(String name) {
    String abbrev = '';
    int len = name.characters.length;
    if (len > 0) {
      if (len < 3) {
        abbrev = name;
      } else {
        bool hasSpaces = name.characters.contains(' ');
        if(!hasSpaces) {
          abbrev = name.substring(0, 3);
        } else {
          final word = RegExp(r'(\w+)');
          final words = word.allMatches(name);
          for ( final w in words) {
            String p = w[0]!;
            abbrev = abbrev + p[0];
          }
        }
      }
    }

    if (_abbrevController.text.isEmpty) {
      _abbrev = abbrev.toUpperCase();
      _abbrevController.text = _abbrev;
    }
    return;
  }  
  
  @override
  void initState(){
    _teamColor = widget.team.color != '' 
      ? widget.team.color.toColor()
       : Colors.black;
    _nameController = TextEditingController(text: widget.team.name);
    _abbrevController = TextEditingController(text: widget.team.abbrev);
    super.initState();
  }    

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {

      return  SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding (
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column (
                children: [
                  Text('Add Team',
                    style: 
                    Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  ),
                  const SizedBox(height: 20),      
                  Row(
                    children: [
                      Expanded (
                        child: Focus(
                          onFocusChange:(hasFocus) {
                            if(!hasFocus) {
                              _getAbbreviation(_nameController.text);
                            }
                          },
                          child: TextField(
                            // focusNode: nameFocusNode,
                            // onChanged: (text) {
                            //   _getAbbreviation(text);
                            // },
                            controller: _nameController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              label: Text('Team Name'),
                            ),
                            style: 
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              )
                          ),
                        ),
                      ),
                    ]
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 100,
                        child: 
                          TextField(
                            controller: _abbrevController,
                            maxLength: 4,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              label: Text('Abbrev'),
                            ),
                            style: 
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              )
                          ),
                      ),
                      const SizedBox(width: 40),
                      Column(
                        children: [   
                          Text("Team Color",
                            style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Theme.of(context).colorScheme.secondary
                              )
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _presentColorPicker,
                            style: FilledButton.styleFrom (
                              backgroundColor: const Color.fromARGB(0, 240, 240, 240),
                            ),
                            child: SizedBox(
                              height: 32,
                              width: 32,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _teamColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                                ),
                              ),
                            ),
                          ),
                          ],
                      ),
                    ],
                  ),      
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        style: TextButton.styleFrom (
                          textStyle:   
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                              // color: Theme.of(context).colorScheme.onSecondary
                            ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: _updateTeam,
                        style: TextButton.styleFrom (
                          textStyle:   
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).colorScheme.primary
                            ),
                        ),
                        child: const Text('Add Team'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
        );
    });
  }
}
