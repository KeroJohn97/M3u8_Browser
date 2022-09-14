import 'dart:collection';
import 'dart:developer';
// import 'dart:convert';
import 'dart:io';
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/show_snack_bar.dart';
import '../helpers/text_helper.dart';
import '../views/video_view.dart';
import '../widgets/app_bar_bottom_line.dart';
import 'about_me_screen.dart';
import 'download_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  final scrollController = ScrollController();

  // TODO for loop for m3u8, catch for m3u8 410 error
  Future<void> catchVideo() async {
    late int numberOfVideos;
    final String? html = await webViewController?.getHtml();
    if (html == null) {
      showSnackBar(context: context, content: TextHelper.noVideoFound.tr);
      return;
    }
    // log('html: $html');
    // numberOfVideos = html.allMatches('m3u8').length;
    // log('message: $numberOfVideos');
    // if (numberOfVideos <= 0) {
    //   showSnackBar(context: context, content: TextHelper.noVideoFound.tr);
    //   return;
    // }
    // final List<String> availableVideoUrls = [];
    // for (int a = 0; a < availableVideoUrls.length; a++) {
    final List<String> first = html.split('.m3u8');
    final int firstIndex = first[0].lastIndexOf('"');
    final String firstHalf = first[0].substring(firstIndex + 1);
    final int lastIndex = first[1].indexOf('"');
    final String lastHalf = first[1].substring(0, lastIndex);
    String url = '$firstHalf.m3u8$lastHalf';
    url = url.replaceAll('&amp;', '&');
    log('get url: $url');
    // }
    showBarModalBottomSheet(
        context: context,
        builder: (context) {
          return PageView(
            children: [
              ListView(
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoView(videoUrl: url)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 125.0,
                        child: Text(
                          url,
                          style: const TextStyle(fontSize: 24.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future<void> navigateToChewie() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VideoView(
          videoUrl: 'https://new.iskcd.com/20220420/XNihn9Om/index.m3u8',
        ),
      ),
    );
  }

  Future<void> retrieveVideoUrl(InAppWebViewController controller) async {
    final String html = await controller.getHtml() ?? '';
    if (html.contains('source src=')) {
      final List<String> htmlList = html.split('source src=');
      final List<String> htmlList2 = htmlList[1].split('type="application/');
      String videoUrl = htmlList2[0];
      videoUrl = videoUrl.replaceAll('"', '');
      videoUrl = videoUrl.replaceAll('&amp;', '&');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoView(videoUrl: videoUrl),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print(
              "onContextMenuActionItemClicked: $id ${contextMenuItemClicked.title}");
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
          // color: Colors.blue,
          ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
        // if (webViewController != null) {
        //   retrieveVideoUrl(webViewController!);
        // }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: catchVideo,
          child: const Icon(Icons.download),
        ),
        body: SafeArea(
            child: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          child: Column(children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration:
                          const InputDecoration(prefixIcon: Icon(Icons.search)),
                      controller: urlController,
                      keyboardType: TextInputType.url,
                      onSubmitted: (value) {
                        var url = Uri.parse(value);
                        if (url.scheme.isEmpty) {
                          url = Uri.parse(
                              "https://www.google.com/search?q=$value");
                        }
                        webViewController?.loadUrl(
                            urlRequest: URLRequest(url: url));
                      },
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(FontAwesome.arrow_left),
                        onPressed: () => webViewController?.goBack(),
                      ),
                      const AppBarBottomLine(),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(FontAwesome.arrow_right),
                        onPressed: () => webViewController?.goForward(),
                      ),
                      const AppBarBottomLine(),
                    ],
                  ),
                  Column(
                    children: [
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text('Refresh'),
                            onTap: () => webViewController?.reload(),
                          ),
                          const PopupMenuItem(
                            value: 'Downloads',
                            child: Text('Downloads'),
                          ),
                          PopupMenuItem(
                            child: const Text('Settings'),
                            onTap: () => webViewController?.reload(),
                          ),
                          const PopupMenuItem(
                            value: 'About Me',
                            child: Text('About Me'),
                          ),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 'About Me':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AboutMeScreen(),
                                ),
                              );
                              break;
                            case 'Downloads':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DownloadScreen(),
                                ),
                              );
                              break;
                          }
                        },
                      ),
                      const AppBarBottomLine(),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    // contextMenu: contextMenu,
                    initialUrlRequest: URLRequest(
                        url: Uri.parse("https://github.com/flutter")),
                    // initialFile: "assets/index.html",
                    initialUserScripts: UnmodifiableListView<UserScript>([]),
                    initialOptions: options,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(uri.scheme)) {
                        if (await canLaunchUrl(Uri.parse(url))) {
                          // Launch the App
                          await launchUrl(
                            Uri.parse(url),
                          );
                          // and cancel the request
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      // <source src="https://cdn.bigcloud.bond/hls/684616/index.m3u8?t=1662566760&amp;m=f5UxT85N1eHlfqvXSzR4VA"
                      pullToRefreshController.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                      // retrieveVideoUrl(controller);
                    },
                    onLoadError: (controller, url, code, message) {
                      pullToRefreshController.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                  progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container(),
                ],
              ),
            ),
          ]),
        )));
  }
}
