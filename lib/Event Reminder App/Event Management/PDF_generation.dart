import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfGenerator {
  static Future<void> generatePdf(Map<String, dynamic> event, String pdfName) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) => buildEventTable(event),
      ),
    );

    // Save to Downloads folder
    final directory = Directory("/storage/emulated/0/Download"); // Downloads Folder (Android)
    final filePath = "${directory.path}/$pdfName.pdf";
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());
    OpenFile.open(filePath); // Open the file automatically
  }
}

pw.Widget buildEventTable(Map<String, dynamic> event) {
  String getValue(dynamic value, {String defaultValue = 'Not set'}) {
    return value != null && value.toString().isNotEmpty ? value.toString() : defaultValue;
  }

  return pw.Table(
    border: pw.TableBorder.all(color: PdfColors.black, width: 2),
    columnWidths: {
      0: pw.FlexColumnWidth(4),
      1: pw.FlexColumnWidth(6),
    },
    children: [
      _buildTableRow('Event', getValue(event['name'])),
      _buildTableRow('Date & Time', getValue(event['date_time'])),
      _buildTableRow('Category', getValue(event['category'])),
      _buildTableRow('Location', getValue(event['location'])),
      _buildTableRow('Description', getValue(event['description'])),
    ],
  );
}

pw.TableRow _buildTableRow(String title, String value) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(12.0),
        child: pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(12.0),
        child: pw.Text(value, style: pw.TextStyle(fontSize: 18)),
      ),
    ],
  );
}
