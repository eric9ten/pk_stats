import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pk_stats/views/game_setup.dart';
import 'package:uuid/uuid.dart';

import 'package:pk_stats/providers/providers.dart';
import 'package:pk_stats/models/game.dart';
import 'package:pk_stats/models/game_stats.dart';
import 'package:pk_stats/models/team.dart';
import 'package:pk_stats/views/game_pdf.dart';
import 'package:pk_stats/widgets/colored_title.dart';
import 'package:pk_stats/widgets/ad_banner.dart';


class GameReviewView extends ConsumerWidget {
  const GameReviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gameListProvider);
    final gameHalf = ref.watch(gameHalfProvider);
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final formatter = DateFormat.yMd();

    if (games.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Game Review')),
        body: const Center(child: Text('No game data available')),
      );
    }

    final game = games.first;
    final teamAStats = game.teamAStats ?? GameStats();
    final teamBStats = game.teamBStats ?? GameStats();

    String halfLabel = gameHalf == 1 ? 'Halftime' : 'Final';
    String buttonLabel = gameHalf == 1 ? 'Start 2nd Half' : 'Restart';

    void pdfReview() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GamePdfView()
        ),
      );
    }

    void resetGame() {
      ref.read(gameListProvider.notifier).update((state) => [
            Game(
              id: const Uuid().v4(),
              location: 'TBD',
              teamA: Team(name: '', abbrev: '', color: 'FF000000'),
              teamB: Team(name: '', abbrev: '', color: 'FFFFFFFF'),
              teamAStats: GameStats(),
              teamBStats: GameStats(),
              isAHome: false,
              date: null,
              time: null,
              aIsDefendingRight: true,
            )
          ]);
      ref.read(teamListProvider.notifier).update((state) => [
            Team(name: '', abbrev: '', color: 'FF000000'),
            Team(name: '', abbrev: '', color: 'FFFFFFFF'),
          ]);
      ref.read(isAHomeProvider.notifier).state = false;
      ref.read(aIsDefendingRightProvider.notifier).state = false;
      ref.read(gameHalfProvider.notifier).state = 1;
      ref.read(leftStatsProvider.notifier).state = GameStats();
      ref.read(rightStatsProvider.notifier).state = GameStats();
      ref.read(locationProvider.notifier).state = 'TBD';

    }

  void restartGame() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Restart'),
        content: const Text('Are you sure you want to restart the game?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.of(ctx).popUntil((route) => route.isFirst);
              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (context) => const GameSetupView(),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void continueGame(WidgetRef ref, int gameHalf, BuildContext context) {
    if (gameHalf == 1) {
      ref.read(gameHalfProvider.notifier).state = 2;
      ref.read(aIsDefendingRightProvider.notifier).state =
          !ref.read(aIsDefendingRightProvider);
      Navigator.pop(context, 2);
    } else {
      restartGame();
    }
  }
  
    return Scaffold(
      appBar: AppBar(
        title: Text(halfLabel),
      ),
      body: 
        LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints){
        return SingleChildScrollView(
          child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        game.date != null ? formatter.format(game.date!) : 'Date TBD',
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
                      Text(
                        game.time != null ? game.time!.format(context) : 'Time TBD',
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
                                          title: game.teamA != null ? game.teamA!.abbrev : 'TBD',
                                          color: game.teamA != null ? game.teamA!.color : 'FF000000',
                                        ),
                                      ),
                                      const TableCell(
                                        child: SizedBox(height: 24),
                                      ),
                                      TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child: 
                                        ColoredTitle(
                                          title: game.teamB != null ? game.teamB!.abbrev : 'TBD',
                                          color: game.teamB != null ? game.teamB!.color : 'FFFFFFFF',
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
                                            game.teamAStats!.goals.toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
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
                                            game.teamBStats!.goals.toString(),
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
                                            game.teamAStats!.passes.toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
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
                                            game.teamBStats!.passes.toString(),
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
                                            game.teamAStats!.shots.toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
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
                                            game.teamBStats!.shots.toString(),
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
                                            game.teamAStats!.tackles.toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
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
                                                  .titleMedium!
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
                                            game.teamBStats!.tackles.toString(),
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
                                            game.teamAStats!.corners.toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
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
                                                  .titleMedium!
                                                  .copyWith(
                                                    color: Theme.of(context).colorScheme.secondary,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            game.teamBStats!.corners.toString(),
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
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 165, 0, 0.2)
                                      ),
                                      children: <Widget>[
                                        TableCell(
                                          child: Text(
                                            game.teamAStats!.goalKicks.toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
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
                                                    .titleMedium!
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
                                            game.teamBStats!.goalKicks.toString(),
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
                                            game.teamAStats!.offsides.toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
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
                                                  .titleMedium!
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
                                            game.teamBStats!.offsides.toString(),
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
                                            game.teamAStats!.fouls.toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
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
                                                  .titleMedium!
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
                                            game.teamBStats!.fouls.toString(),
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
                                                  .titleMedium!
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
                                            game.teamAStats!.yellows.toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
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
                                            game.teamBStats!.yellows.toString(),
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
                                            game.teamAStats!.reds.toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
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
                                            game.teamBStats!.reds.toString(),
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
                              onPressed: () => continueGame(ref, gameHalf, context),  
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
                            IconButton(
                              onPressed: pdfReview, 
                              icon: const Icon(Icons.leaderboard_outlined),
                              color: Colors.amber[700],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        MyBannerAdWidget(),
                      ],
                    ),
                  ),
                ],
              )),
        )
      );
    })
    );
  }
}
