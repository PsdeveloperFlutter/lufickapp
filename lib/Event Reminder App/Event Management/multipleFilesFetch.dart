import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:lufickapp/Event%20Reminder%20App/Database/Main_Database_App.dart';

class FetchMultipleFile extends StatefulWidget {
  final int eventId;

  const FetchMultipleFile({super.key, required this.eventId});

  @override
  State<FetchMultipleFile> createState() => _FetchMultipleFileState();
}

class _FetchMultipleFileState extends State<FetchMultipleFile> {
  late Future<List<Map<String, dynamic>>> _filesFuture;

  @override
  void initState() {
    super.initState();
    _filesFuture = DatabaseHelper.instance.fetchEventFiles(widget.eventId);
    DatabaseHelper.instance.printAllFiles();
    print("\n" + "Event ID: ${widget.eventId} in multiple files fetch");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Future to fetch files
        future: _filesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No files found.'));
          } else {
            final files = snapshot.data!;
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                // Ensure the file path exists before rendering the PDF view
                if (file['path'] == null || file['path']!.isEmpty) {
                  return ListTile(
                    title: const Text('Invalid File Path'),
                    subtitle:
                        const Text('The file path is missing or incorrect'),
                  );
                }
                return ListTile(
                  title: Text('File ${index + 1}'),
                  onTap: () {
                    // On tapping, open PDF view for this file
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PdfViewerPage(filePath: file['path']!),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

// A separate page to view the PDF
class PdfViewerPage extends StatelessWidget {
  final String filePath;

  const PdfViewerPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View PDF'),
      ),
      body: PDFView(
        filePath: filePath,
        // Path to the PDF file
        enableSwipe: true,
        // Enable swipe gestures for navigation
        swipeHorizontal: true,
        // Horizontal swipe for page navigation
        autoSpacing: false,
        pageSnap: true,
        pageFling: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
        // Handle links inside PDF
        onRender: (pages) {
          print('PDF rendered with $pages pages');
        },
        onError: (error) {
          print('Error rendering PDF: $error');
          // You can show a more user-friendly error message here
        },
        onPageError: (page, error) {
          print('Error on page $page: $error');
          // Handle errors on specific page render
        },
      ),
    );
  }
}
