
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'About_Section.dart';
import 'Animation_Background.dart';
import 'Contact_File.dart';
import 'Project_Screen.dart';
class SimplePdfViewer extends StatefulWidget {
  const SimplePdfViewer({super.key});

  @override
  State<SimplePdfViewer> createState() => _SimplePdfViewerState();
}

class _SimplePdfViewerState extends State<SimplePdfViewer> {
  String? localPath;

  PDFViewController? _pdfViewController;
  int _totalPages = 0;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    loadPDF();
  }
  //for going to next page
  void gotonextpage(){
    if(_currentPage<_totalPages){
      _currentPage++;
      _pdfViewController?.setPage(_currentPage);
    }
  }
  //set this going for the previous page
  void gotopreviouspage(){
    if(_currentPage>0){
      _currentPage--;
      _pdfViewController?.setPage(_currentPage);
    }
  }

  Future<void> loadPDF() async {
    final bytes = await rootBundle.load('assets/New Resume PRIYANSHU SATIJA.pdf');
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/New Resume PRIYANSHU SATIJA.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(title: const Text("Resume")),
      body: Column(
        children: [

          Expanded(
            child: localPath != null
                ? PDFView(filePath: localPath!,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,

              onRender: (pages) {
                setState(() {
                  _totalPages = pages!;
                });
              },
              onViewCreated: (PDFViewController vc) {
                _pdfViewController = vc;
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  _currentPage = page!;
                });
              },
            )
                : const Center(child: CircularProgressIndicator()),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  gotopreviouspage();
                },
                icon: const Icon(Icons.arrow_back_ios),
                label: const Text('Back'),
              ),
              const Spacer(),


              InkWell(
                  onTap: (){
                   Share.shareXFiles([XFile(localPath!)]);
                  },
                  child: Icon(Icons.share,)),
              const Spacer(),

              InkWell(
                  onTap: ()async{
                    Uint8List bytes = (await rootBundle.load('assets/New Resume PRIYANSHU SATIJA.pdf')).buffer.asUint8List() as Uint8List;
                    final downloadsDir = await getApplicationDocumentsDirectory();
                    final filepath = File("${downloadsDir.path}/New Resume PRIYANSHU SATIJA.pdf");
                    File file = File(filepath.path);
                    await file.writeAsBytes(bytes as List<int>, flush: true);
                    OpenFile.open(filepath.path);
                  },
                  child: Icon(Icons.download,)),
              const Spacer(),

              ElevatedButton.icon(
                onPressed: () async {
                 gotonextpage();
                  },
                icon: const Icon(Icons.arrow_forward_ios),
                label: const Text('Next'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
