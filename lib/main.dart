import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:m3u8_browser/color_schemes.g.dart';
import 'package:m3u8_browser/providers/cubit/app_config_cubit.dart';
import 'package:m3u8_downloader/m3u8_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'helpers/custom_behavior.dart';
import 'helpers/simple_bloc_observer.dart';
import 'helpers/unfocus.dart';
import 'screens/home_screen.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// InAppLocalhostServer localhostServer = new InAppLocalhostServer();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request();
  await FlutterDownloader.initialize(debug: true);
  if (FlutterDownloader.initialized) {
    // TODO configuration
    await FlutterDownloader.loadTasks();
    // await FlutterDownloader.cancelAll();
  }
  try {
    final AppUpdateInfo info = await InAppUpdate.checkForUpdate();
    bool appVersionIsTooLow = false;
    // ignore: dead_code
    if (appVersionIsTooLow) {
      if (info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      }
      // ignore: dead_code
    } else {
      if (info.flexibleUpdateAllowed) {
        await InAppUpdate.startFlexibleUpdate();
      }
    }
  } catch (e) {
    log('InAppUpdate Error: $e');
  }

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      await serviceWorkerController
          .setServiceWorkerClient(AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      ));
    }
  }
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _initM3u8Downloader() async {
    final folder = Platform.isAndroid
        ? await getExternalStorageDirectory() ??
            await getApplicationDocumentsDirectory()
        : await getApplicationSupportDirectory();
    M3u8Downloader.initialize(onSelect: () async {
      log('Download successfully click');
      return null;
    });
    log('Video path: ${folder.path}');
    M3u8Downloader.config(
      saveDir: folder.path,
      threadCount: 2,
      convertMp4: true,
      debugMode: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _initM3u8Downloader();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppConfigCubit>(create: (context) => AppConfigCubit()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'M3u8 Browser',
        theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoWillPopScopePageTransionsBuilder(),
            },
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoWillPopScopePageTransionsBuilder(),
            },
          ),
        ),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: CustomBehavior(),
            child: Unfocus(
              child: ResponsiveWrapper.builder(
                child,
                maxWidth: 1200,
                minWidth: 480,
                defaultScale: true,
                breakpoints: [
                  const ResponsiveBreakpoint.resize(600, name: MOBILE),
                  const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                  const ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
                ],
                // background: Container(color: const Color(0xFFF5F5F5)),
              ),
            ),
          );
        },
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
        },
      ),
    );
  }
}
