// main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:id_quick/pages/verify_page.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    setupWindowFlags();
  }

  Future<void> setupWindowFlags() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ID Quick',
      theme: ThemeData(
        fontFamily: 'Inter',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const VerifyPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}