// main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:id_quick/pages/verify_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const VerifyPage());
}