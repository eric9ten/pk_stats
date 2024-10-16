import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:pk_stats/models/game.dart';

class GameViewPdf extends StatelessWidget {
  const GameViewPdf({super.key, required this.game});
  
  final Game game;
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Demo'),
        ),
        body: PdfPreview(
          build: (context) => buildPdf(),
        ),
      ),
    );
  }

  /// This method takes a page format and generates the Pdf file data
  Future<Uint8List> buildPdf() async {
    // Create the Pdf document
    final pw.Document doc = pw.Document();

    // Add one page with centered text "Hello World"
    doc.addPage(
      pw.Page(
        // pageFormat: format,
        orientation: pw.PageOrientation.landscape,
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
                            fontSize: 32,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 12),
                          child: pw.Text(game.teamAStats.goals.toString(),
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                        ),
                        pw.Text('-',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 12),
                          child: 
                          pw.Text(game.teamBStats.goals.toString(),
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                        ),
                        pw.Text(game.teamB.name,
                          style: const pw.TextStyle(
                            fontSize: 32,
                          ),
                        ),
                      ]
                    ),
                      ]
                    ),
                    pw.Row(
                      children: [
                        pw.Text('Hello World'),
                      ]
                    ),
                    pw.Row(
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
                    )
                  ]
                )
          );
        },
      ),
    );

    // Build and return the final Pdf file data
    return await doc.save();
    
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              height: 50,
              padding: const pw.EdgeInsets.only(left: 20),
              child: pw.Text(
                'Pitch Keeper - Stats',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            )
          ]
        )
      ]
    );
  }

}