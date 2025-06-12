import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pk_stats/models/game_stats.dart';
import 'package:pk_stats/models/team.dart';
import 'package:pk_stats/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pk_stats/providers/providers.dart';

class GamePdfView extends ConsumerWidget {
  GamePdfView({super.key});

  final PdfColor baseColor = PdfColor.fromHex('#222222');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gameListProvider);
    final teams = ref.watch(teamListProvider);
    final isAHome = ref.watch(isAHomeProvider);
    final aDefendingRight = ref.watch(aIsDefendingRightProvider);
    final half = ref.watch(gameHalfProvider);
    final leftStats = ref.watch(leftStatsProvider);
    final rightStats = ref.watch(rightStatsProvider);

    final teamA = teams[0];
    final teamB = teams[1];

    void continueGame() {
      Navigator.pop(context);
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: continueGame,
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text('Game Report'),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 250, 250, 250),
            foregroundColor: const Color.fromRGBO(10, 10, 10, 1)),
        body: games.isEmpty
            ? const Center(child: Text("No game data available."))
            : PdfPreview(
                canChangeOrientation: false,
                canChangePageFormat: false,
                canDebug: false,
                previewPageMargin: const EdgeInsets.all(8),
                actionBarTheme: const PdfActionBarTheme(
                  backgroundColor: Color.fromARGB(255, 255, 152, 0),
                ),
                build: (context) => buildPdf(context, ref),
              ),
      ),
    );
  }

  Future<Uint8List> buildPdf(PdfPageFormat format, WidgetRef ref) async {
    final games = ref.read(gameListProvider);
    final teams = ref.read(teamListProvider);
    final isAHome = ref.read(isAHomeProvider);
    final aDefendingRight = ref.read(aIsDefendingRightProvider);
    final half = ref.read(gameHalfProvider);
    final location = games.first.location ?? 'TBD';
    final teamA = teams[0];
    final teamB = teams[1];

    if (games.isEmpty) {
      throw Exception("No game data available.");
    }

    final game = games.first;
    final leftStats = game.teamAStats!;
    final rightStats = game.teamBStats!;

    final pw.Document doc = pw.Document();
    final pageTheme = await _gamePageTheme(format);

    doc.addPage(
      pw.Page(
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  _buildHeader(
                    teamA: teamA,
                    teamB: teamB,
                    teamAStats: leftStats,
                    teamBStats: rightStats,
                    isAHome: isAHome,
                    date: game.date!,
                    time: game.time!,
                    location: location,
                  ),
                ]),
            pw.Row(children: [
              _buildScoreBar(
                teamA: teamA,
                teamB: teamB,
                teamAStats: leftStats,
                teamBStats: rightStats,
              ),
            ]),
            pw.Row(children: [
              _buildScoreTable(
                teamAAbbrev: teamA.abbrev,
                teamBAbbrev: teamB.abbrev,
                teamAFinalGoals: leftStats.goals,
                teamBFinalGoals: rightStats.goals,
              ),
            ]),
            pw.Row(children: [
              _buildStatComparisons(
                context: context,
                teamAColor: PdfColor.fromHex(convertArgbToHex(teamA.color)),
                teamBColor: PdfColor.fromHex(convertArgbToHex(teamB.color)),
                teamAShots: leftStats.shots,
                teamBShots: rightStats.shots,
                teamAPasses: leftStats.passes,
                teamBPasses: rightStats.passes,
                teamACorners: leftStats.corners,
                teamBCorners: rightStats.corners,
                teamAFouls: leftStats.fouls,
                teamBFouls: rightStats.fouls,
                teamATackles: leftStats.tackles,
                teamBTackles: rightStats.tackles,
                teamAOffsides: leftStats.offsides,
                teamBOffsides: rightStats.offsides,
              ),
            ]),
            pw.Row(children: [
              _buildStatsTable(
                context: context,
                teamAName: game.teamA!.name,
                teamAStats: game.teamAStats!,
                teamBName: game.teamB!.name,
                teamBStats: game.teamBStats!,
              ),
            ]),
            pw.Row(children: [
              _buildLegend(),
            ]),
            pw.Row(children: [
              _buildFooter(),
            ]),
          ]));
        },
      ),
    );
    // Build and return the final Pdf file data
    return await doc.save();
  }

  Future<pw.PageTheme> _gamePageTheme(PdfPageFormat format) async {
    format = format.copyWith(
      marginLeft: 32,
      marginTop: 16,
      marginRight: 32,
      marginBottom: 16,
    );

    return pw.PageTheme(
        pageFormat: format.copyWith(
            height: 8.5 * PdfPageFormat.inch, width: 11 * PdfPageFormat.inch),
        orientation: pw.PageOrientation.landscape,
        theme: pw.ThemeData.withFont(
          base: await PdfGoogleFonts.latoRegular(),
          bold: await PdfGoogleFonts.latoBold(),
          icons: await PdfGoogleFonts.materialIcons(),
        ));
  }

  pw.Widget _buildHeader({
    required Team teamA,
    required Team teamB,
    required GameStats teamAStats,
    required GameStats teamBStats,
    required bool isAHome,
    required DateTime date,
    required TimeOfDay time,
    required String location,
  }) {
    final PdfColor teamAHexColor =
        PdfColor.fromHex(convertArgbToHex(teamA.color));
    final PdfColor teamBHexColor =
        PdfColor.fromHex(convertArgbToHex(teamB.color));

    return pw.Column(
      children: [
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Container(
                  child: teamA.color == 'FFFFFFFF'
                      ? _buildOutlinedText(teamA.name)
                      : pw.Text(
                          teamA.name,
                          style: pw.TextStyle(
                            fontSize: 20,
                            color: teamAHexColor,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        )),
              pw.SizedBox(width: 12),
              pw.Container(
                width: 10,
                child: pw.Text(
                  teamAStats.goals.toString(),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Center(
                child: pw.Container(
                  width: 8,
                  child: pw.Center(
                      child: pw.Text(
                    '-',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 24,
                    ),
                  )),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Container(
                width: 10,
                child: pw.Text(
                  teamBStats.goals.toString(),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              pw.SizedBox(width: 14),
              pw.Container(
                  child: teamB.color == 'FFFFFFFF'
                      ? _buildOutlinedText(teamB.name)
                      : pw.Text(
                          teamB.name,
                          style: pw.TextStyle(
                            fontSize: 20,
                            color: teamBHexColor,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        )),
            ]),
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Icon(
                pw.IconData(0xea2f),
                size: 14,
              ),
              pw.SizedBox(
                width: 2,
              ),
              pw.Text(
                isAHome ? 'Away' : 'Home',
                style: const pw.TextStyle(
                  fontSize: 14,
                ),
              ),
              pw.SizedBox(
                width: 32,
              ),
              pw.Icon(
                pw.IconData(0xe935),
                size: 14,
              ),
              pw.SizedBox(
                width: 4,
              ),
              pw.Text(
                DateFormat.yMMMd().format(date),
                style: const pw.TextStyle(
                  fontSize: 14,
                ),
              ),
              pw.SizedBox(
                width: 8,
              ),
              // pw.Icon(
              //   const pw.IconData(0xe8b5),
              //   size: 14,
              // ),
              // pw.SizedBox(
              //   width: 4,
              // ),
              pw.Text(
                '${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}',
                overflow: pw.TextOverflow.visible,
                style: const pw.TextStyle(
                  fontSize: 14,
                ),
              ),
              // pw.SizedBox(
              //   width: 32,
              // ),
              // pw.Text(
              //   isAHome ? 'Home' : 'Away',
              //   style: const pw.TextStyle(
              //     fontSize: 14,
              //   ),
              // ),
              pw.SizedBox(
                width: 32,
              ),
              pw.Icon(
                pw.IconData(0xe0c8),
                  color: PdfColor.fromHex('#434343'),
                  size: 14,
              ),
              pw.SizedBox(
                width: 4,
              ),
              pw.Text(
                location,
                style: const pw.TextStyle(
                  fontSize: 14,
                ),
              ),
            ]),
      ],
    );
  }

  pw.Widget _buildScoreBar({
    required Team teamA,
    required Team teamB,
    required GameStats teamAStats,
    required GameStats teamBStats,
  }) {
    var teamAColor = teamA.color.substring(2);
    var teamBColor = teamB.color.substring(2);

    return pw.Expanded(
        child: pw.Container(
            decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#efefef'),
                border: pw.Border.all(
                  width: 1,
                  color: PdfColor.fromHex('#434343'),
                  style: pw.BorderStyle.solid,
                )),
            padding: const pw.EdgeInsets.all(8.0),
            margin: const pw.EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: pw.Center(
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                  pw.Text(
                      colorName[teamA.color.trim().toUpperCase()] ??
                          teamA.abbrev,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#434343'),
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  pw.SizedBox(
                    width: 8,
                  ),
                  pw.Container(
                    child: pw.Text(
                      teamAStats.goals.toString(),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                        color: teamA.color == 'FF000000' ? PdfColor.fromHex('#ffffff') : PdfColor.fromHex('#434343'),
                      ),
                    ),
                    decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex(teamAColor), // PdfColor.fromHex('#efefef'),
                        border: pw.Border.all(
                          width: 1,
                          color: PdfColor.fromHex(teamAColor), //PdfColor.fromHex('#434343'),
                          style: pw.BorderStyle.solid,
                        )),
                    padding: const pw.EdgeInsets.fromLTRB(8, 4, 8, 4),
                  ),
                  pw.SizedBox(
                    width: 32,
                  ),
                  pw.Text('Game Stats',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#434343'),
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  pw.SizedBox(
                    width: 32,
                  ),
                  pw.Container(
                    child: pw.Text(
                      teamBStats.goals.toString(),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                        color: teamB.color == 'FF000000' ? PdfColor.fromHex('#ffffff') : PdfColor.fromHex('#434343'),
                      ),
                    ),
                    decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex(teamBColor), //PdfColor.fromHex('#efefef'),
                        border: pw.Border.all(
                          width: 1,
                          color: PdfColor.fromHex(teamBColor), //PdfColor.fromHex('#434343'),
                          style: pw.BorderStyle.solid,
                        )),
                    padding: const pw.EdgeInsets.fromLTRB(8, 4, 8, 4),
                  ),
                  pw.SizedBox(
                    width: 8,
                  ),
                  pw.Text(
                      colorName[teamB.color.trim().toUpperCase()] ??
                          teamB.abbrev,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#434343'),
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      )),
                ]))));
  }

  pw.Widget _buildScoreTable({
    required String teamAAbbrev,
    required String teamBAbbrev,
    required int teamAFinalGoals,
    required int teamBFinalGoals,
  }) {
    return pw.Expanded(
      child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
        pw.Column(
          children: [
            pw.Row(children: [
              pw.Container(
                height: 25,
                width: 60,
                alignment: pw.Alignment.centerLeft,
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text("Scores"),
              ),
              pw.Container(
                height: 25,
                width: 40,
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text("1st"),
              ),
              pw.Container(
                height: 25,
                width: 40,
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text("2nd"),
              ),
              pw.Container(
                height: 25,
                width: 40,
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text("Final"),
              ),
            ]),
            pw.Row(children: [
              pw.Container(
                height: 25,
                width: 60,
                alignment: pw.Alignment.centerLeft,
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(teamAAbbrev),
              ),
              pw.Container(
                height: 30,
                width: 30,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: PdfColor.fromHex('#434343'),
                        width: 2,
                        style: pw.BorderStyle.solid)),
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text('--'),
              ),
              pw.Container(
                height: 30,
                width: 30,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: PdfColor.fromHex('#434343'),
                        width: 2,
                        style: pw.BorderStyle.solid)),
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text('--'),
              ),
              pw.Container(
                height: 30,
                width: 30,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: PdfColor.fromHex('#434343'),
                        width: 2,
                        style: pw.BorderStyle.solid)),
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(teamAFinalGoals.toString()),
              ),
            ]),
            pw.Row(children: [
              pw.Container(
                height: 25,
                width: 60,
                alignment: pw.Alignment.centerLeft,
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(teamBAbbrev),
              ),
              pw.Container(
                height: 30,
                width: 30,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: PdfColor.fromHex('#434343'),
                        width: 2,
                        style: pw.BorderStyle.solid)),
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text('--'),
              ),
              pw.Container(
                height: 30,
                width: 30,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: PdfColor.fromHex('#434343'),
                        width: 2,
                        style: pw.BorderStyle.solid)),
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text('--'),
              ),
              pw.Container(
                height: 30,
                width: 30,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: PdfColor.fromHex('#434343'),
                        width: 2,
                        style: pw.BorderStyle.solid)),
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(teamBFinalGoals.toString()),
              ),
            ]),
          ],
        )
      ]),
    );
  }

  pw.Widget _buildStatComparisons({
    required pw.Context context,
    required PdfColor teamAColor,
    required PdfColor teamBColor,
    required int teamAShots,
    required int teamBShots,
    required int teamAPasses,
    required int teamBPasses,
    required int teamACorners,
    required int teamBCorners,
    required int teamAFouls,
    required int teamBFouls,
    required int teamATackles,
    required int teamBTackles,
    required int teamAOffsides,
    required int teamBOffsides,
  }) {
    final sectionTitleStyle = pw.Theme.of(context).defaultTextStyle.copyWith(
          color: baseColor,
          fontSize: 16,
          letterSpacing: -0.2,
        );

    return pw.Expanded(
        child: pw.Padding(
      padding: const pw.EdgeInsets.fromLTRB(0, 32, 0, 16),
      child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(
                child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Offense',
                    textAlign: pw.TextAlign.center, style: sectionTitleStyle),
                _divergingBarGraph(context, 'Shots', teamAShots, teamBShots,
                    teamAColor, teamBColor),
                _divergingBarGraph(context, 'Passes', teamAPasses, teamBPasses,
                    teamAColor, teamBColor),
              ],
            )),
            pw.Container(
                child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Set Pieces',
                    textAlign: pw.TextAlign.center, style: sectionTitleStyle),
                _divergingBarGraph(context, 'Corner Kicks', teamACorners,
                    teamBCorners, teamAColor, teamBColor),
                _divergingBarGraph(context, 'Free Kicks', teamBFouls,
                    teamAFouls, teamAColor, teamBColor), // flipped
              ],
            )),
            pw.Container(
                child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Defense',
                    textAlign: pw.TextAlign.center, style: sectionTitleStyle),
                _divergingBarGraph(context, 'Tackles', teamATackles,
                    teamBTackles, teamAColor, teamBColor),
                _divergingBarGraph(context, 'Offsides', teamBOffsides,
                    teamAOffsides, teamAColor, teamBColor), // flipped
              ],
            )),
          ]),
    ));
  }

  pw.Widget _buildFooter() {
    return pw.Expanded(
      child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(children: [
              pw.Container(
                height: 20,
                child: pw.Text(
                  'Pitch Keeper - Stats',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 8,
                  ),
                ),
              )
            ]),
            pw.Column(children: [
              pw.Container(
                height: 20,
                child: pw.Text(
                  'pitchkeepr.com',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 8,
                  ),
                ),
              )
            ]),
          ]),
    );
  }

  pw.Widget _buildStatsTable({
    required pw.Context context,
    required String teamAName,
    required GameStats teamAStats,
    required String teamBName,
    required GameStats teamBStats,
  }) {
    return pw.Expanded(
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
          pw.Text(
            'Team Totals',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 16,
            ),
          ),
          pw.TableHelper.fromTextArray(
            headerDecoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#bebebe'),
            ),
            headers: List<String>.generate(
                10,
                (col) => [
                      '',
                      'SH',
                      'Pass',
                      'CK',
                      'GK',
                      'Tack',
                      'OS',
                      'FL',
                      'YC',
                      'RC'
                    ][col]),
            cellAlignment: pw.Alignment.center,
            border: pw.TableBorder.all(width: 0, style: pw.BorderStyle.none),
            oddRowDecoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#EFEFEF'),
            ),
            columnWidths: {
              0: const pw.FixedColumnWidth(100),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1),
              4: const pw.FlexColumnWidth(1),
              5: const pw.FlexColumnWidth(1),
              6: const pw.FlexColumnWidth(1),
              7: const pw.FlexColumnWidth(1),
              8: const pw.FlexColumnWidth(1),
              9: const pw.FlexColumnWidth(1),
            },
            data: [
              [
                teamAName,
                teamAStats.shots.toString(),
                teamAStats.passes.toString(),
                teamAStats.corners.toString(),
                teamAStats.goalKicks.toString(),
                teamAStats.tackles.toString(),
                teamAStats.offsides.toString(),
                teamAStats.fouls.toString(),
                teamAStats.yellows.toString(),
                teamAStats.reds.toString(),
              ],
              [
                teamBName,
                teamBStats.shots.toString(),
                teamBStats.passes.toString(),
                teamBStats.corners.toString(),
                teamBStats.goalKicks.toString(),
                teamBStats.tackles.toString(),
                teamBStats.offsides.toString(),
                teamBStats.fouls.toString(),
                teamBStats.yellows.toString(),
                teamBStats.reds.toString(),
              ],
            ],
            cellAlignments: {
              0: pw.Alignment.centerLeft, // Align first column to the left
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
              5: pw.Alignment.center,
              6: pw.Alignment.center,
              7: pw.Alignment.center,
              8: pw.Alignment.center,
              9: pw.Alignment.center,
            },
            cellStyle: const pw.TextStyle(fontSize: 12),
          )
        ]));
  }

  pw.Widget _buildLegend() {
    return pw.Expanded(
        child: pw.Container(
            padding: const pw.EdgeInsets.all(16),
            margin: const pw.EdgeInsets.only(top: 16),
            decoration: pw.BoxDecoration(
                border: pw.Border.all(
              color: PdfColor.fromHex('#E1E1E1'),
              width: 1,
              style: pw.BorderStyle.solid,
            )),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _legendItem('SH', 'Shots'),
                        pw.SizedBox(height: 8),
                        _legendItem('Pass', 'Completed passes'),
                      ]),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _legendItem('CK', 'Corner Kicks'),
                        pw.SizedBox(height: 8),
                        _legendItem('GK', 'Goal Kicks'),
                      ]),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _legendItem('Tack', 'Tackles resulting in a turnover'),
                      ]),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _legendItem('OS', 'Offsides'),
                        pw.SizedBox(height: 8),
                        _legendItem('FL', 'Fouls committed'),
                      ]),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _legendItem('YC', 'Yellow Cards given'),
                        pw.SizedBox(height: 8),
                        _legendItem('RC', 'Red Cards given'),
                      ]),
                ])));
  }
}

pw.Widget _buildOutlinedText(String text) {
  return pw.Stack(
    children: [
      // Outline effect by creating multiple offset layers
      pw.Positioned(
        left: -0.5,
        top: -0.5,
        child: pw.Text(text,
            style: pw.TextStyle(fontSize: 20, color: PdfColors.black)),
      ),
      pw.Positioned(
        left: 0.5,
        top: -0.5,
        child: pw.Text(text,
            style: pw.TextStyle(fontSize: 20, color: PdfColors.black)),
      ),
      pw.Positioned(
        left: -0.5,
        top: 0.5,
        child: pw.Text(text,
            style: pw.TextStyle(fontSize: 20, color: PdfColors.black)),
      ),
      pw.Positioned(
        left: 0.5,
        top: 0.5,
        child: pw.Text(text,
            style: pw.TextStyle(fontSize: 20, color: PdfColors.black)),
      ),

      // Main text on top
      pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 20,
          color: PdfColors.white,
        ),
      ),
    ],
  );
}

pw.Widget _divergingBarGraph(
    pw.Context context,
    statName, 
    teamAStat,
    teamBStat,
    teamAColor,
    teamBColor
  ) {
  const double barHeight = 20;
  const double statFontSize = 16;
  const double totalWidth = 100;

  final statTotal = teamAStat + teamBStat;

  final teamAWidth = statTotal == 0
    ? totalWidth / 2
    : (teamAStat / statTotal) * totalWidth;
  final teamBWidth = totalWidth - teamAWidth;

  return pw.Container(
      width: 175,
      child: pw.Column(children: [
        pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                width: double.infinity,
                child: pw.Text(statName,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: 12,
                      letterSpacing: -0.2,
                    )),
              ),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      teamAStat.toString(),
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            color: PdfColor.fromHex('#222222'),
                            fontSize: statFontSize,
                            letterSpacing: -0.2,
                          )),
                    pw.Container(
                      margin: const pw.EdgeInsets.fromLTRB(10, 6, 10, 16),
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black)),
                      width: 100,
                      height: barHeight,
                      child: pw.Row(
                        children: [
                          pw.SizedBox(
                            width: teamAWidth,
                            height: barHeight,
                            child: pw.Container(
                              color: teamAColor,
                            ),
                          ),
                          pw.SizedBox(
                            width: teamBWidth,
                            height: barHeight,
                            child: pw.Container(
                              color: teamBColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Text(teamBStat.toString(),
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(
                              color: PdfColor.fromHex('#222222'),
                              fontSize: statFontSize,
                              letterSpacing: -0.2,
                            ))
                  ])
            ])
      ]));
}

pw.Widget _legendItem(String statAbbrev, String statDesc) {
  return pw.Row(children: [
    pw.Text('$statAbbrev: ',
        style: pw.TextStyle(
          color: PdfColor.fromHex('#222222'),
          fontWeight: pw.FontWeight.bold,
          fontSize: 8,
        )),
    pw.Text(
      statDesc,
      style: pw.TextStyle(
        color: PdfColor.fromHex('#222222'),
        fontSize: 8,
      ),
      softWrap: true,
      overflow: pw.TextOverflow.visible,
    )
  ]);
}
