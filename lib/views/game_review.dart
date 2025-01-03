import 'package:flutter/material.dart';

import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/views/game_pdf.dart';
import 'package:pk_stats/widgets/colored_title.dart';
import 'package:pk_stats/widgets/ad_banner.dart';


class GameReviewView extends StatelessWidget {
  const GameReviewView({super.key, required this.gameHalf, required this.game});

  final int gameHalf;
  final Game game;

  @override
  Widget build(BuildContext context) {
    String halfLabel = 'Halftime';
    String buttonLabel = 'Start 2nd Half';
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    if (gameHalf == 2) {
      halfLabel = 'Final';
      buttonLabel = 'End Game';
    }

    void continueGame() {
      final Game gameInfo = game;

      if (gameHalf == 1) {
        Navigator.pop(context, 2);
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GameViewPdf(game: game)
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(halfLabel),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(8, 4 , 8, keyboardSpace + 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                ),
                const Row(
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
                      height: 10,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Table(
                              columnWidths: const <int, TableColumnWidth>{
                                0: FixedColumnWidth(36),
                                1: FixedColumnWidth(52),
                                3: FixedColumnWidth(36),
                              },
                              defaultColumnWidth: const FixedColumnWidth(24),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: <TableRow>[
                                TableRow(
                                  children: <Widget>[
                                    TableCell(
                                      child: 
                                      ColoredTitle(
                                        title: game.teamA.abbrev,
                                        color: game.teamA.color
                                      ),
                                    ),
                                    const TableCell(
                                      child: SizedBox(height: 24),
                                    ),
                                    TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: 
                                      ColoredTitle(
                                        title: game.teamB.abbrev,
                                        color: game.teamB.color
                                      ),
                                    )
                                  ],
                                ), 
                              ], 
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Table(
                                border: TableBorder(
                                  horizontalInside: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1,
                                  ),
                                ),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FixedColumnWidth(36),
                                  1: FixedColumnWidth(52),
                                  3: FixedColumnWidth(36),
                                },
                                defaultColumnWidth: const FixedColumnWidth(24),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: <TableRow>[
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Text(
                                          game.teamAStats.goals.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 24,
                                              )
                                        ),
                                      ),
                                      const TableCell(
                                        child: SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text( 
                                              '--',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          game.teamBStats.goals.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 24,
                                              )
                                        ),
                                      )
                                    ],
                                  ),                          
                                  TableRow(
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 165, 0, 0.2)
                                    ),
                                    children: <Widget>[
                                      TableCell(
                                        child: Text(
                                          game.teamAStats.passes.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      ),
                                      const TableCell(
                                        child: SizedBox(
                                          height: 45,
                                          child: Center(
                                            child: Text( 'PASSES',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          game.teamBStats.passes.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      )
                                    ],
                                  ),                         
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Text(
                                          game.teamAStats.shots.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      ),
                                      const TableCell(
                                        child: SizedBox(
                                          height: 45,
                                          child: Center(
                                            child: Text( 'SHOTS',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          game.teamBStats.shots.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      )
                                    ],
                                  ),                          
                                  TableRow(
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 165, 0, 0.2)
                                    ),
                                    children: <Widget>[
                                      TableCell(
                                        child: Text(
                                          game.teamAStats.corners.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 45,
                                          child: Center(
                                            child: Text( 
                                              'CORNER KICKS',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          game.teamBStats.corners.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              ),
                                        ),
                                      )
                                    ],
                                  ),                          
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Text(
                                          game.teamAStats.goalKicks.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 45,
                                          child: Center(
                                            child: Text( 
                                                'GOAL KICKS',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Theme.of(context).colorScheme.secondary,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          game.teamBStats.goalKicks.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      )
                                    ],
                                  ),                          
                                  TableRow(
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 165, 0, 0.2)
                                    ),
                                    children: <Widget>[
                                      TableCell(
                                        child: Text(
                                          game.teamAStats.tackles.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 45,
                                          child: Center(
                                            child: Text( 'TACKLES',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          game.teamBStats.tackles.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      )
                                    ],
                                  ),                          
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Text(
                                          game.teamAStats.offsides.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 45,
                                          child: Center(
                                            child: Text( 'OFFSIDES',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          game.teamBStats.offsides.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      )
                                    ],
                                  ),                          
                                  TableRow(
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 165, 0, 0.2)
                                    ),
                                    children: <Widget>[
                                      TableCell(
                                        child: Text(
                                          game.teamAStats.fouls.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 45,
                                          child: Center(
                                            child: Text( 'FOULS',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          game.teamBStats.fouls.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      )
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      const TableCell(
                                        child: SizedBox(
                                          height: 24,
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 45,
                                          child: Center(
                                            child: Text( 'CARDS',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const TableCell(
                                        child: SizedBox(
                                          height: 24,
                                        ),
                                      ),
                                    ]
                                  ),                         
                                  TableRow(
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 165, 0, 0.2)
                                    ),
                                    children: <Widget>[
                                      TableCell(
                                        child: Text(
                                          game.teamAStats.yellows.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 45,
                                          child: Center(
                                            child:
                                              Image.asset(
                                                'assets/images/yellow-card.png',
                                              ),
                                          )
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          game.teamBStats.yellows.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      )
                                    ],
                                  ),                          
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Text(
                                          game.teamAStats.reds.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
                                              )
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 45,
                                          child: Center(
                                            child:
                                              Image.asset(
                                                'assets/images/red-card.png',
                                              ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          game.teamBStats.reds.toString(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 20,
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
                      const Row(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: continueGame,  
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                            ),
                            child: Text(
                              buttonLabel,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const Spacer(
                      //   flex: 1,
                      // ),
                      const SizedBox(
                        height: 16,
                      ),
                      MyBannerAdWidget(),
                    ],
                  ),
                ),
              ],
            )),
    );
  }
}
