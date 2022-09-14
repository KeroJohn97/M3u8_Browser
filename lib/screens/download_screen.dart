import 'dart:developer';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
// import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../helpers/text_helper.dart';
import '../widgets/mime_icon.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  String? directory;
  List<io.File> files = [];

  @override
  void initState() {
    super.initState();
    _getFiles();
  }

  void _getFiles() async {
    directory = (io.Platform.isAndroid
            ? await getExternalStorageDirectory() ??
                await getApplicationDocumentsDirectory()
            : await getApplicationSupportDirectory())
        .absolute
        .path;
    setState(() {
      final List fileSystemEntities = io.Directory('$directory').listSync();
      for (int a = 0; a < fileSystemEntities.length; a++) {
        if (fileSystemEntities[a] is io.File) {
          log('File name: ${basename(fileSystemEntities[a].path)}');
          files.add((fileSystemEntities[a] as io.File));
        }
      }
    });
  }

  // TODO install apk
  void _openFile(io.File file) async {
    OpenFilex.open(file.path);
  }

  // TODO
  void _share() async {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(TextHelper.downloads.tr),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight,
            child: Column(
              children: <Widget>[
                // your Content if there
                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: files.length,
                      separatorBuilder: (context, index) {
                        return const Divider(height: 2.0);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () => _openFile(files[index]),
                              child: Container(
                                // color: ColorHelper.secondaryColor,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: MimeIcon(
                                        mimeType:
                                            lookupMimeType(files[index].path),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 100,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          basename(files[index].path),
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _share,
                                      icon: const Icon(
                                        Icons.share_outlined,
                                        // color: ColorHelper.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (index == files.length - 1)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  TextHelper.reachTheEnd.tr,
                                  style: const TextStyle(fontSize: 20.0),
                                ),
                              )
                          ],
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
