import 'dart:developer';

import 'package:flutter/material.dart';

import '../helpers/asset_helper.dart';

/// <a href="https://www.flaticon.com/free-icons/mp4" title="mp4 icons">Mp4 icons created by Roman Káčerek - Flaticon</a>
/// TODO add to websites
class MimeIcon extends StatelessWidget {
  final String? mimeType;
  const MimeIcon({Key? key, required this.mimeType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('Mime Type: $mimeType');
    return Container(
      height: 100.0,
      padding: const EdgeInsets.all(16.0),
      child: Builder(
        builder: (context) {
          if (mimeType == null) return Image.asset(AssetHelper.unknownIcon);
          if (mimeType!.contains('apk')) {
            return Image.asset(AssetHelper.apkIcon);
          }
          if (mimeType!.contains('image')) {
            return Image.asset(AssetHelper.imageIcon);
          }
          if (mimeType!.contains('music')) {
            return Image.asset(AssetHelper.musicIcon);
          }
          if (mimeType!.contains('pdf')) {
            return Image.asset(AssetHelper.pdfIcon);
          }
          if (mimeType!.contains('text')) {
            return Image.asset(AssetHelper.textIcon);
          }
          if (mimeType!.contains('video')) {
            return Image.asset(AssetHelper.videoIcon);
          }
          if (mimeType!.contains('zip')) {
            return Image.asset(AssetHelper.zipIcon);
          }
          if (mimeType!.contains('json')) {
            return Image.asset(AssetHelper.jsonIcon);
          }
          if (mimeType!.contains('application')) {
            return Image.asset(AssetHelper.apkIcon);
          }
          return Image.asset(AssetHelper.unknownIcon);
        },
      ),
    );
  }
}
