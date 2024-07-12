// main.dart

import 'package:flutter/material.dart';
import 'package:id_quick/pages/display_id_card_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => const DisplayIDHomePage(),
      },
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
    );
  }
}