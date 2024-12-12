import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';


class generatepdf {
 static Future<void> generateAndOpenPDF(dynamic texts ,dynamic description , dynamic date) async {
    final pdf = pw.Document(); // Create a new PDF document

    // Add a page with some content
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Text("Task :- $texts\nDescription :- $description\nDate :- $date ", style: pw.TextStyle(fontSize: 40));
        },
      ),
    );

    // Convert PDF to bytes
    final pdfBytes = await pdf.save();

    // Save the generated PDF to the device
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/example.pdf');
    await file.writeAsBytes(pdfBytes);

    print('PDF saved at: ${file.path}');

    // Open the PDF
    final result = await OpenFile.open(file.path);
    print('PDF open result: $result');
  }

}