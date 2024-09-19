import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';

import 'package:pk_stats/models/game.dart';


class GameReviewView extends StatelessWidget {
  const GameReviewView({super.key, required this.gameHalf, required this.game});

  final int gameHalf;
  final Game game;

  @override
  Widget build(BuildContext context) {
    String halfLabel = 'Halftime';

    if (gameHalf == 2) {
      halfLabel = 'Final';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(halfLabel),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
            constraints: const BoxConstraints(
                minHeight: 0,
                maxHeight: double.infinity,
                minWidth: double.infinity,
                maxWidth: double.infinity),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(formatter.format(game.date),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            )),
                  ],
                ),const Row(
                  children: [
                    SizedBox(
                      height: 2,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(game.time.format(context),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            )
                      ),
                  ],
                ),
                const Row(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(44),
                            1: FixedColumnWidth(32),
                            3: FixedColumnWidth(44),
                          },
                          defaultColumnWidth: const FixedColumnWidth(24),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: Text(
                                    game.teamA.abbrev,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: game.teamA.color.toColor(),
                                        )
                                  ),
                                ),
                                const TableCell(
                                  child: SizedBox(height: 24),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Text(
                                    game.teamB.abbrev,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: game.teamB.color.toColor(),
                                        )
                                  ),
                                )
                              ],
                            ),                          
                            TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: Text(
                                    game.teamBStats!.goals.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                ),
                                const TableCell(
                                  child: SizedBox(
                                    height: 24,
                                    child: Text( '--',
                                    textAlign: TextAlign.center,),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    game.teamAStats!.goals.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                )
                              ],
                            ),                          
                            TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: Text(
                                    game.teamBStats!.passes.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                ),
                                const TableCell(
                                  child: SizedBox(
                                    height: 24,
                                    child: Text( 'Passes',
                                    textAlign: TextAlign.center,),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    game.teamAStats!.passes.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                )
                              ],
                            ),                         
                            TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: Text(
                                    game.teamBStats!.shots.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                ),
                                const TableCell(
                                  child: SizedBox(
                                    height: 24,
                                    child: Text( 'Shots',
                                    textAlign: TextAlign.center,),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    game.teamAStats!.shots.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                )
                              ],
                            ),                          
                            TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: Text(
                                    game.teamBStats!.corners.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                ),
                                TableCell(
                                  child: SizedBox(
                                    height: 24,
                                    child: Text( 'Corner Kicks',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    game.teamAStats!.corners.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                )
                              ],
                            ),                          
                            TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: Text(
                                    game.teamBStats!.goalKicks.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                ),
                                const TableCell(
                                  child: SizedBox(
                                    height: 24,
                                    child: Text( 'Goal Kicks',
                                    textAlign: TextAlign.center,),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    game.teamAStats!.goalKicks.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                )
                              ],
                            ),                          
                            TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: Text(
                                    game.teamBStats!.tackles.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                ),
                                const TableCell(
                                  child: SizedBox(
                                    height: 24,
                                    child: Text( 'Tackles',
                                    textAlign: TextAlign.center,),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    game.teamAStats!.tackles.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                )
                              ],
                            ),                          
                            TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: Text(
                                    game.teamBStats!.offsides.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                ),
                                const TableCell(
                                  child: SizedBox(
                                    height: 24,
                                    child: Text( 'Offsides',
                                    textAlign: TextAlign.center,),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    game.teamAStats!.offsides.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                )
                              ],
                            ),                          
                            TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: Text(
                                    game.teamBStats!.fouls.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                ),
                                const TableCell(
                                  child: SizedBox(
                                    height: 24,
                                    child: Text( 'Fouls',
                                    textAlign: TextAlign.center,),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    game.teamAStats!.fouls.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                )
                              ],
                            ),
                            const TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: SizedBox(
                                    height: 24,
                                  ),
                                ),
                                TableCell(
                                  child: SizedBox(
                                    height: 24,
                                    child: Text( 'Cards',
                                    textAlign: TextAlign.center,),
                                  ),
                                ),
                                TableCell(
                                  child: SizedBox(
                                    height: 24,
                                  ),
                                ),
                              ]
                            ),                         
                            TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: Text(
                                    game.teamBStats!.yellows.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                ),
                                const TableCell(
                                  child: SizedBox(
                                    height: 24,
                                    child: Text( 'Yellows',
                                    textAlign: TextAlign.center,),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    game.teamAStats!.yellows.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                )
                              ],
                            ),                          
                            TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: Text(
                                    game.teamBStats!.reds.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                ),
                                const TableCell(
                                  child: SizedBox(
                                    height: 24,
                                    child: Text( 'Reds',
                                    textAlign: TextAlign.center,),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    game.teamAStats!.reds.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
