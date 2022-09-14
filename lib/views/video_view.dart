import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:m3u8_downloader/m3u8_downloader.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class VideoView extends StatefulWidget {
  final String videoUrl;
  const VideoView({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  final ReceivePort _port = ReceivePort();

  Future<void> _download() async {
    log('video source: ${widget.videoUrl}');
    // TODO pass video title
    M3u8Downloader.download(
      url: widget.videoUrl,
      name: "video title",
      progressCallback: progressCallback,
      successCallback: successCallback,
      errorCallback: errorCallback,
    );
    Navigator.maybePop(context);
  }

  void listenToSendPort() async {
    // 注册监听器
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      // 监听数据请求
      print(data);
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  static progressCallback(dynamic args) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    if (send != null) {
      args["status"] = 1;
      send.send(args);
    }
  }

  static successCallback(dynamic args) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    if (send != null) {
      send.send({
        "status": 2,
        "url": args["url"],
        "filePath": args["filePath"],
        "dir": args["dir"]
      });
    }
  }

  static errorCallback(dynamic args) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    if (send != null) {
      send.send({"status": 3, "url": args["url"]});
    }
  }

  void _addVideoListener() async {
    _videoController.addListener(() async {
      if (_videoController.value.isPlaying)
        await Wakelock.enable();
      else
        await Wakelock.disable();
    });
  }

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) async {
        _addVideoListener();
        if (mounted)
          setState(() {
            _chewieController = ChewieController(
              videoPlayerController: _videoController,
              allowedScreenSleep: false,
              autoPlay: true,
              additionalOptions: (context) => <OptionItem>[
                OptionItem(
                  onTap: _download,
                  iconData: Icons.download,
                  title: 'Download',
                ),
              ],
              placeholder: Center(child: CircularProgressIndicator.adaptive()),
            );
            _chewieController?.addListener(() {
              if (_chewieController != null) {
                if (!_chewieController!.isFullScreen) {
                  SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp],
                  );
                }
              }
            });
          });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null)
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      );
    return SafeArea(
      child: Scaffold(
        body: Chewie(controller: _chewieController!),
      ),
    );
  }
}
