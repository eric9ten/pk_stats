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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: const <int, TableColumnWidth>{
                          0: FixedColumnWidth(48),
                          1: FixedColumnWidth(24),
                          3: FixedColumnWidth(48),
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
                                  textAlign: TextAlign.end,
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
                                child: Text(
                                  game.teamB.abbrev,
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
                                  game.teamAStats?.goals as String,
                                  textAlign: TextAlign.end,
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
                                  child: Text( '-',),
                                ),
                              ),
                              TableCell(
                                child: Text(
                                  
                                  // game.teamBStats?.goals as String,
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
              ],
            )),
      ),
    );
  }
}
