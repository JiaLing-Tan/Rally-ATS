import 'dart:io';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rally/resources/layout.dart';
import 'package:rally/resources/theme.dart';
import 'package:rally/resources/utils.dart';
import 'package:rally/routes.dart';
import 'package:window_manager/window_manager.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();
  // // if (Platform.isWindows) {
  //   WindowManager.instance.setMinimumSize(const Size(1500, 800));
  //   // WindowManager.instance.setMaximumSize(Size.infinite);
  //   WindowManager.instance.setMaximizable(true);
  // // }
  // if (Platform.isWindows) {
  //   await windowManager.ensureInitialized();
  //   WindowOptions windowOptions = const WindowOptions(
  //     fullScreen: true,
  //     skipTaskbar: false,
  //     center: true,
  //     size: Size(double.infinity, double.infinity),
  //     // alwaysOnTop: true, // This hide the taskbar and appear the app on top
  //     titleBarStyle: TitleBarStyle.normal
  //   );
  //   windowManager.waitUntilReadyToShow(windowOptions, () async {
  //     await windowManager.show();
  //     await windowManager.focus();
  //   });
  //
  // }
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return 
      CalendarControllerProvider(
        controller: EventController(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: ThemeRally.newBlack),
            primarySwatch:generateMaterialColor(ThemeRally.newBlack),

            useMaterial3: true,
            textTheme: GoogleFonts.sourceSans3TextTheme(),
          ),
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
          routes: Routes.routes,
        ),
      );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Layout(),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: call_api,
      //   tooltip: 'call api',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
