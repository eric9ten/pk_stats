import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pk_stats/utils/colors.dart';
import 'package:pk_stats/utils/strings.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

import 'package:pk_stats/utils/colors.dart';

import 'package:pk_stats/models/game.dart';

class GameViewPdf extends StatelessWidget {
  GameViewPdf({super.key, required this.game});
  
  final Game game;
  final PdfColor baseColor =  PdfColor.fromHex('#222222');
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Game Results'),
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          foregroundColor: const Color.fromRGBO(10, 10, 10, 1)
        ),
        body: PdfPreview(
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          previewPageMargin: const EdgeInsets.all(8),
          actionBarTheme: const PdfActionBarTheme(
            backgroundColor: Color.fromARGB(255, 255, 152, 0),
          ),
          build: (context) => buildPdf(context),
        ),
      ),
    );
  }

  Future<Uint8List> buildPdf(PdfPageFormat format) async {
    // Create the Pdf document
    final pw.Document doc = pw.Document();
    final pageTheme = await _gamePageTheme(format);

    doc.addPage(
      pw.Page(
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return pw.Center(
              child: 
                pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        _buildHeader(context),
                      ]
                    ),
                    pw.Row(
                      children: [
                        _buildScoreBar(),
                      ]
                    ),
                    pw.Row(
                      children: [
                        _buildScoreTable(),
                      ]
                    ),
                    pw.Row(
                      children: [
                        _buildStatComparisons(context),
                      ]
                    ),
                    pw.Row(
                      children: [
                        _buildStatsTable(context),
                      ]
                    ),
                    pw.Row(
                      children: [
                        _buildLegend(),
                      ]
                    ),
                    pw.Row(
                      children: [
                        _buildFooter(),
                      ]
                    ),
                  ]
                )
          );
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
          height: 8.5 * PdfPageFormat.inch,
          width: 11 * PdfPageFormat.inch
        ),
        orientation: pw.PageOrientation.landscape,
        theme: pw.ThemeData.withFont(
          base: await PdfGoogleFonts.latoRegular(),
          bold: await PdfGoogleFonts.latoBold(),
          icons: await PdfGoogleFonts.materialIcons(),
        )
      );
  }

  pw.Widget _buildHeader(pw.Context context) {
    final PdfColor teamAHexColor = PdfColor.fromHex(convertArgbToHex(game.teamA.color));
    final PdfColor teamBHexColor = PdfColor.fromHex(convertArgbToHex(game.teamB.color));

    return                         
      pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Container(
                // child: _coloredTitle(game.teamA.name, teamAHexColor),
                child: game.teamA.color == 'FFFFFFFF' ? 
                   _buildOutlinedText(game.teamA.name) : 
                  pw.Text(game.teamA.name,
                    style: pw.TextStyle(
                      fontSize: 20,
                      color: teamAHexColor,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  )
              ),
              pw.SizedBox(width: 12),
              pw.Container(
                width: 10,
                child: pw.Text(game.teamAStats.goals.toString(),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Center(
                child: 
                pw.Container(
                  width: 8,
                  child: 
                    pw.Center (
                      child: 
                        pw.Text('-',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 24,
                          ),
                        )
                    ),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Container(
                width: 10,
                child: 
                pw.Text(game.teamBStats.goals.toString(),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Container(
                child: game.teamB.color == 'FFFFFFFF' ? 
                   _buildOutlinedText(game.teamB.name) : 
                  pw.Text(game.teamB.name,
                    style: pw.TextStyle(
                      fontSize: 20,
                      color: teamBHexColor,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  )
              ),
            ]
          ),
          pw.Row( 
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(game.isAHome ? 'Away' : 'Home',
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
              pw.Text(DateFormat.yMMMd().format(game.date),
                style: const pw.TextStyle(
                  fontSize: 14,
                ),
              ),
              pw.SizedBox(
                width: 32,
              ),
              pw.Icon(
                const pw.IconData(0xe8b5), 
                size: 14,
              ),
              pw.SizedBox(
                width: 4,
              ),
              pw.Text('${game.time.hourOfPeriod}:${game.time.minute}',
                style: const pw.TextStyle(
                  fontSize: 14,
                ),
              ),
              pw.SizedBox(
                width: 32,
              ),
              pw.Text(game.isAHome ? 'Home' : 'Away',
                style: const pw.TextStyle(
                  fontSize: 14,
                ),
              ),
            ]
          ),
        ],
      );
  }

  pw.Widget _buildScoreBar() {
    return
      pw.Expanded(
        child: pw.Container(
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('#efefef'),
            border: pw.Border.all (
              width: 1, 
              color: PdfColor.fromHex('#424242'),
              style: pw.BorderStyle.solid,
            )
          ),
          padding: const pw.EdgeInsets.all(8.0),
          margin: const pw.EdgeInsets.fromLTRB(32, 16, 32, 16),
          child: pw.Center(
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  colorName[game.teamA.color.trim().toUpperCase()] ?? 
                  game.teamA.abbrev,
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#434343'),
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  )
                ),
                pw.SizedBox(
                  width: 8,
                ),
                pw.Container(
                  child: pw.Text(game.teamAStats.goals.toString()),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#efefef'),
                    border: pw.Border.all (
                      width: 1, 
                      color: PdfColor.fromHex('#424242'),
                      style: pw.BorderStyle.solid,
                    )
                  ),
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
                  )  
                ),
                pw.SizedBox(
                  width: 32,
                ),
                pw.Container(
                  child: pw.Text(game.teamBStats.goals.toString()),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#efefef'),
                    border: pw.Border.all (
                      width: 1, 
                      color: PdfColor.fromHex('#424242'),
                      style: pw.BorderStyle.solid,
                    )
                  ),
                  padding: const pw.EdgeInsets.fromLTRB(8, 4, 8, 4),
                ),
                pw.SizedBox(
                  width: 8,
                ),
                pw.Text(
                  colorName[game.teamB.color.trim().toUpperCase()] ??
                  game.teamB.abbrev,
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#434343'),
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ) 
                ), 
              ]
            )
          )
      )
    );
  }

  pw.Widget _buildScoreTable() {
    return pw.Expanded(
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [ 
            pw.Column(
            children: [
              pw.Row(
                children:[
                  pw. Container(
                    height: 25,
                    width: 60,
                    alignment: pw.Alignment.centerLeft,
                    padding: const pw.EdgeInsets.all(2),
                    child: 
                      pw.Text("Scores"),
                    ),
                  pw. Container(
                    height: 25,
                    width: 40,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(2),
                    child: 
                      pw.Text("1st"),
                    ),
                  pw. Container(
                    height: 25,
                    width: 40,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(2),
                    child: 
                      pw.Text("2nd"),
                    ),
                  pw. Container(
                    height: 25,
                    width: 40,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(2),
                    child: 
                      pw.Text("Final"),
                    ),
                ]
              ),
              pw.Row(
                children:[
                  pw. Container(
                    height: 25,
                    width: 60,
                    alignment: pw.Alignment.centerLeft,
                    padding: const pw.EdgeInsets.all(2),
                    child: 
                      pw.Text(game.teamA.abbrev),
                    ),
                  pw. Container(
                    height: 30,
                    width: 30,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#424242'),
                        width: 2,
                        style: pw.BorderStyle.solid
                      )
                    ),
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(2),
                    child: 
                      pw.Text('--'),
                    ),
                  pw. Container(
                    height: 30,
                    width: 30,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#424242'),
                        width: 2,
                        style: pw.BorderStyle.solid
                      )
                    ),
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(2),
                    child: 
                      pw.Text('--'),
                    ),
                  pw. Container(
                    height: 30,
                    width: 30,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#424242'),
                        width: 2,
                        style: pw.BorderStyle.solid
                      )
                    ),
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(2),
                    child: 
                      pw.Text(game.teamAStats.goals.toString()),
                    ),
                ]
              ),
              pw.Row(
                children:[
                  pw. Container(
                    height: 25,
                    width: 60,
                    alignment: pw.Alignment.centerLeft,
                    padding: const pw.EdgeInsets.all(2),
                    child: 
                      pw.Text(game.teamB.abbrev),
                    ),
                  pw. Container(
                    height: 30,
                    width: 30,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#424242'),
                        width: 2,
                        style: pw.BorderStyle.solid
                      )
                    ),
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(2),
                    child: 
                      pw.Text('--'),
                    ),
                  pw. Container(
                    height: 30,
                    width: 30,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#424242'),
                        width: 2,
                        style: pw.BorderStyle.solid
                      )
                    ),
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(2),
                    child: 
                      pw.Text('--'),
                    ),
                  pw. Container(
                    height: 30,
                    width: 30,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#424242'),
                        width: 2,
                        style: pw.BorderStyle.solid
                      )
                    ),
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(2),
                    child: 
                      pw.Text(game.teamBStats.goals.toString()),
                    ),
                ]
              ),
            ],
          )
          ]
        ),
    );
  }

  pw.Widget _buildStatComparisons(pw.Context context) {
    final PdfColor teamAHexColor = PdfColor.fromHex(convertArgbToHex(game.teamA.color));
    final PdfColor teamBHexColor = PdfColor.fromHex(convertArgbToHex(game.teamB.color));

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
                    textAlign: pw.TextAlign.center,
                    style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(
                        color: baseColor,
                        fontSize: 16,
                        letterSpacing: -0.2,
                    )
                  ),
                  _divergingBarGraph(context, 'Shots', game.teamAStats.shots, game.teamBStats.shots, teamAHexColor,
                    teamBHexColor),
                  _divergingBarGraph(context, 'Passes', game.teamAStats.passes, game.teamBStats.passes, teamAHexColor,
                    teamBHexColor),

                ],  
              )
            ),
            pw.Container(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('Set Pieces',
                    textAlign: pw.TextAlign.center,
                    style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(
                        color: baseColor,
                        fontSize: 16,
                        letterSpacing: -0.2,
                    )
                  ),
                  _divergingBarGraph(context, 'Corner Kicks', game.teamAStats.corners, game.teamBStats.corners, teamAHexColor,
                    teamBHexColor),
                    // stats flipped: fouls give free kicks
                  _divergingBarGraph(context, 'Free Kicks', game.teamBStats.fouls, game.teamAStats.fouls, teamBHexColor,
                    teamAHexColor),
                ],  
              )
            ),
            pw.Container(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('Defense',
                    textAlign: pw.TextAlign.center,
                    style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(
                        color: baseColor,
                        fontSize: 16,
                        letterSpacing: -0.2,
                    )
                  ),
                  _divergingBarGraph(context, 'Tackles', game.teamAStats.tackles, game.teamBStats.tackles, teamAHexColor,
                    teamBHexColor),
                  _divergingBarGraph(context, 'Offsides', game.teamBStats.offsides, game.teamAStats.offsides, teamAHexColor,
                    teamBHexColor),

                ],  
              )
            ),
          ]
        ),
      )
    );
  }

  pw.Widget _buildFooter() {
    return pw.Expanded(
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            children: [
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
            ]
          ),
          pw.Column(
            children: [
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
            ]
          ),
        ]
      ),
    );
  }

  pw.Widget _buildStatsTable(pw.Context context) {
    return pw.Expanded(
      child: 
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text('Team Totals',
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
                (col) => ['', 'SH', 'Pass', 'CK', 'GK', 'Tack', 'OS', 'FL', 'YC', 'RC'][col]
              ),
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
              data: <List<String>>[
                <String>[ game.teamA.name, game.teamAStats.shots.toString(),
                game.teamAStats.passes.toString(),
                game.teamAStats.corners.toString(),
                game.teamAStats.goalKicks.toString(),
                game.teamAStats.tackles.toString(),
                game.teamAStats.offsides.toString(),
                game.teamAStats.fouls.toString(),
                game.teamAStats.yellows.toString(),
                game.teamAStats.reds.toString()],
                <String>[ game.teamB.name, game.teamBStats.shots.toString(),
                game.teamBStats.passes.toString(),
                game.teamBStats.corners.toString(),
                game.teamBStats.goalKicks.toString(),
                game.teamBStats.tackles.toString(),
                game.teamBStats.offsides.toString(),
                game.teamBStats.fouls.toString(),
                game.teamBStats.yellows.toString(),
                game.teamBStats.reds.toString()],
              ],
              cellAlignments: {
                0: pw.Alignment.centerLeft,  // Align first column to the left
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
          ]
        )
    );

  }

  pw.Widget _buildLegend(){
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(16),
        margin: const pw.EdgeInsets.only(top: 16),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColor.fromHex('#E1E1E1'),
            width: 1,
            style: pw.BorderStyle.solid,
          ) 
        ),
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
              ]
            ),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _legendItem('CK', 'Corner Kicks'),
                pw.SizedBox(height: 8),
                _legendItem('GK', 'Goal Kicks'),
              ]
            ),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _legendItem('Tack', 'Tackles resulting in a turnover'),
              ]
            ),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _legendItem('OS', 'Offsides'),
                pw.SizedBox(height: 8),
                _legendItem('FL', 'Fouls committed'),
              ]
            ),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _legendItem('YC', 'Yellow Cards given'),
                pw.SizedBox(height: 8),
                _legendItem('RC', 'Red Cards given'),
              ]
            ),
          ]
        )
      )
    );
  }
}

pw.Widget _buildOutlinedText(String text) {
  return pw.Stack(
    children: [
      // Outline effect by creating multiple offset layers
      pw.Positioned(
        left: -0.5,
        top: -0.5,
        child: pw.Text(text, style: pw.TextStyle(fontSize: 20, color: PdfColors.black)),
      ),
      pw.Positioned(
        left: 0.5,
        top: -0.5,
        child: pw.Text(text, style: pw.TextStyle(fontSize: 20, color: PdfColors.black)),
      ),
      pw.Positioned(
        left: -0.5,
        top: 0.5,
        child: pw.Text(text, style: pw.TextStyle(fontSize: 20, color: PdfColors.black)),
      ),
      pw.Positioned(
        left: 0.5,
        top: 0.5,
        child: pw.Text(text, style: pw.TextStyle(fontSize: 20, color: PdfColors.black)),
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
pw.Widget _divergingBarGraph(pw.Context context, statName, teamAStat, teamBStat, teamAColor,
  teamBColor) {
  var statTotal = teamAStat + teamBStat;
  var scale = 100 / statTotal;
  var teamAWidth = teamAStat * scale as double;
  var teamBWidth = 100 - teamAWidth;
  const double barHeight = 20;
  const double statFontSize = 16;

  return pw.Container(
    width: 175,
    child: pw.Column(
      children: [
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
                )
              ),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(teamAStat.toString(),
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(
                        color: PdfColor.fromHex('#222222'),
                        fontSize: statFontSize,
                        letterSpacing: -0.2,
                    )
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.fromLTRB(10, 6, 10, 16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black)
                  ),
                  width: 100,
                  height: barHeight,
                  child: pw.Row(
                    children: [
                        pw.SizedBox(
                          width: teamAWidth,
                          height: barHeight,
                          child: pw.Container(
                            color: teamAColor, // PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(
                          width: teamBWidth,
                          height: barHeight,
                          child: pw.Container(
                            color: teamBColor, // PdfColors.black,
                          ),
                        ),
                    ],
                  ),
                ),
                pw.Text(teamBStat.toString(),
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(
                        color: PdfColor.fromHex('#222222'),
                        fontSize: statFontSize,
                        letterSpacing: -0.2,
                    )
                )
              ]
            )
          ]
        )
      ]
    )
  );
}

pw.Widget _legendItem(String statAbbrev, String statDesc){
  return 
    pw.Row(
      children: [
        pw.Text('$statAbbrev: ',
          style: pw.TextStyle(
            color: PdfColor.fromHex('#222222'),
            fontWeight: pw.FontWeight.bold,
            fontSize: 8,
          )
        ),
        pw.Text(statDesc,
          style: pw.TextStyle(
            color: PdfColor.fromHex('#222222'),
            fontSize: 8,
          ),
          softWrap: true,
          overflow: pw.TextOverflow.visible,
        )
      ]
    );
}