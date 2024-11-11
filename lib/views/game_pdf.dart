import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pk_stats/utils/colors.dart';
import 'package:printing/printing.dart';

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
        // pageFormat: format,
        // orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) {
          return pw.Center(
              child: 
                pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Row(
                      children: [
                        pw.Text(game.teamA.name,
                          style: const pw.TextStyle(
                            fontSize: 28,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 12),
                          child: pw.Text(game.teamAStats.goals.toString(),
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        pw.Text('-',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 12),
                          child: 
                          pw.Text(game.teamBStats.goals.toString(),
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        pw.Text(game.teamB.name,
                          style: const pw.TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ]
                    ),
                      ]
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(game.isAHome ? 'Home' : 'Away',
                          style: const pw.TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        pw.SizedBox(
                          width: 32,
                        ),
                        pw.Icon(
                          const pw.IconData(0xe530), 
                          size: 14,
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
                          const pw.IconData(0xe530), 
                          size: 14,
                        ),
                        pw.Text(game.time.toString(),
                          style: const pw.TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        pw.SizedBox(
                          width: 32,
                        ),
                        pw.Text(game.isAHome ? 'Away' : 'Home',
                          style: const pw.TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ]
                    ),
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.max,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            decoration: pw.BoxDecoration(
                              color: PdfColor.fromHex('#efefef'),
                              border: pw.Border.all (
                                width: 2, 
                                color: PdfColor.fromHex('#424242'),
                                style: pw.BorderStyle.solid,
                              )
                            ),
                            padding: const pw.EdgeInsets.all(8.0),
                            margin: const pw.EdgeInsets.all(32),
                            child: pw.Center(
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                crossAxisAlignment: pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Text(
                                    colorName[game.teamA.color.toString()] ??
                                    game.teamA.abbrev ),
                                  pw.SizedBox(
                                    width: 8,
                                  ),
                                  pw.Container(
                                    child: pw.Text(game.teamAStats.goals.toString()),
                                    decoration: pw.BoxDecoration(
                                      color: PdfColor.fromHex('#efefef'),
                                      border: pw.Border.all (
                                        width: 2, 
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
                                        width: 2, 
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
                                    colorName[game.teamB.color.toString()] ??
                                    game.teamB.abbrev
                                  ), 
                                ]
                              )
                            )
                        )
                        )
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
      
      format = format.applyMargin(
        left: 2.0 * PdfPageFormat.cm,
        top: 2.0 * PdfPageFormat.cm,
        right: 2.0 * PdfPageFormat.cm,
        bottom: 2.0 * PdfPageFormat.cm
      );

      return pw.PageTheme(
        pageFormat: format,
        orientation: pw.PageOrientation.landscape,
        theme: pw.ThemeData.withFont(
          base: await PdfGoogleFonts.latoRegular(),
          bold: await PdfGoogleFonts.latoBold(),
          icons: await PdfGoogleFonts.materialIcons(),
        )
      );
  }

  pw.Widget _buildScoreTable() {
    return pw.Expanded(
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [ pw.Column(
            children: [
              pw.Row(
                children:[
                  pw. Container(
                    height: 25,
                    width: 60,
                    alignment: pw.Alignment.centerLeft,
                    padding: const pw.EdgeInsets.all(4),
                    child: 
                      pw.Text("Scores"),
                    ),
                  pw. Container(
                    height: 25,
                    width: 40,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(4),
                    child: 
                      pw.Text("1st"),
                    ),
                  pw. Container(
                    height: 25,
                    width: 40,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(4),
                    child: 
                      pw.Text("2nd"),
                    ),
                  pw. Container(
                    height: 25,
                    width: 40,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(4),
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
                    padding: const pw.EdgeInsets.all(4),
                    child: 
                      pw.Text(game.teamA.abbrev),
                    ),
                  pw. Container(
                    height: 40,
                    width: 40,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#424242'),
                        width: 2,
                        style: pw.BorderStyle.solid
                      )
                    ),
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(4),
                    child: 
                      pw.Text('--'),
                    ),
                  pw. Container(
                    height: 40,
                    width: 40,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#424242'),
                        width: 2,
                        style: pw.BorderStyle.solid
                      )
                    ),
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(4),
                    child: 
                      pw.Text('--'),
                    ),
                  pw. Container(
                    height: 40,
                    width: 40,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#424242'),
                        width: 2,
                        style: pw.BorderStyle.solid
                      )
                    ),
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(4),
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
                    padding: const pw.EdgeInsets.all(4),
                    child: 
                      pw.Text(game.teamB.abbrev),
                    ),
                  pw. Container(
                    height: 40,
                    width: 40,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#424242'),
                        width: 2,
                        style: pw.BorderStyle.solid
                      )
                    ),
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(4),
                    child: 
                      pw.Text('--'),
                    ),
                  pw. Container(
                    height: 40,
                    width: 40,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#424242'),
                        width: 2,
                        style: pw.BorderStyle.solid
                      )
                    ),
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(4),
                    child: 
                      pw.Text('--'),
                    ),
                  pw. Container(
                    height: 40,
                    width: 40,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#424242'),
                        width: 2,
                        style: pw.BorderStyle.solid
                      )
                    ),
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(4),
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
    return pw.Expanded(
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 32),
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
                  _divergingBarGraph(context, 'Shots', game.teamAStats.shots, game.teamBStats.shots),
                  _divergingBarGraph(context, 'Passes', game.teamAStats.passes, game.teamBStats.passes),

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
                  _divergingBarGraph(context, 'Corner Kicks', game.teamAStats.goalKicks, game.teamBStats.goalKicks),
                  _divergingBarGraph(context, 'Fee Kicks', game.teamBStats.fouls, game.teamAStats.fouls),

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
                  _divergingBarGraph(context, 'Tackles', game.teamAStats.tackles, game.teamBStats.tackles),
                  _divergingBarGraph(context, 'Offsides', game.teamBStats.offsides, game.teamAStats.offsides),

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

}

pw.Widget _divergingBarGraph(pw.Context context, statName, teamAStat, teamBStat) {
  var statTotal = teamAStat + teamBStat;
  print(statTotal);
  var scale = 100 / statTotal;
  print(scale);
  var teamAWidth = teamAStat * scale as double;
  print(teamAWidth);
  var teamBWidth = 100 - teamAWidth;
  print(teamBWidth);

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
                        fontSize: 20,
                        letterSpacing: -0.2,
                    )
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.fromLTRB(10, 6, 10, 16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black)
                  ),
                  width: 100,
                  height: 24,
                  child: pw.Row(
                    children: [
                        pw.SizedBox(
                          width: teamAWidth,
                          height: 24,
                          child: pw.Container(
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(
                          width: teamBWidth,
                          height: 24,
                          child: pw.Container(
                            color: PdfColors.black,
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
                        fontSize: 20,
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