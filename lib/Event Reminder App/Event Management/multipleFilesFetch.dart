import 'package:file_picker/file_picker.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
            allowMultiple: true,
          );
          if (result != null) {
            List<Map<String, String>> fileData = [];
            for (var file in result.files) {
              fileData.add({
                'path': file.path!,
                'extension': file.extension!,
              });
            }
            //insert more files
            await DatabaseHelper.instance.insertEventFiles(
              widget.eventId,
              fileData,
            );
            setState(() {
              _filesFuture =
                  DatabaseHelper.instance.fetchEventFiles(widget.eventId);
            });
          }
        },
        child: Icon(Icons.add),
      ),
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
                  trailing: Container(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete Confirmation'),
                                    content: const Text(
                                        'Are you sure you want to delete this file?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(
                                              context); // Close the dialog first
                                          // Delete the file from the database
                                          final fileId = file['id'];
                                          await DatabaseHelper.instance
                                              .deleteEventFiles(fileId);
                                          setState(() {
                                            _filesFuture = DatabaseHelper
                                                .instance
                                                .fetchEventFiles(
                                                    widget.eventId);
                                          });
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.deepPurple.shade200,
                            )),
                        IconButton(
                            onPressed: () async {
                              //First we store the new file and set to the file database
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf'],
                                      allowMultiple: false);
                              // Update the file in the database
                              await DatabaseHelper.instance.updatefilefunction(
                                  result!.files.single.path,
                                  result!.files.single.extension,
                                  file['id']);
                              setState(() {
                                _filesFuture = DatabaseHelper.instance
                                    .fetchEventFiles(widget.eventId);
                              });
                            },
                            icon: Icon(Icons.update,
                                color: Colors.deepPurple.shade200)),
                      ],
                    ),
                  ),
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
