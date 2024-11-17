// display_id_card_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:id_quick/pages/ids_manager_page.dart';
import 'package:id_quick/utils/data_manager.dart';
import 'package:id_quick/utils/helper_functions.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class DisplayIDHomePage extends StatefulWidget {
  const DisplayIDHomePage({Key? key}) : super(key: key);

  @override
  State<DisplayIDHomePage> createState() => _DisplayIDHomePageState();
}

class _DisplayIDHomePageState extends State<DisplayIDHomePage> {
  String? _imagePath;
  late DataManager _dataManager;

  @override
  void initState() {
    super.initState();
    _dataManager = DataManager(context);
    _loadDefaultImagePath();
    setupWindowFlags();
  }

  setupWindowFlags() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> _loadDefaultImagePath() async {
    int idCount = await _dataManager.getIdsCount();
    if (idCount > 0) {
      Map<String, String>? defaultId = await _dataManager.getDefaultId();
      setState(() {
        _imagePath = defaultId?['imagePath'];
      });
    } else {
      setState(() {
        _imagePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Builder(
        builder: (BuildContext context) {
          return SizedBox(
            width: screenWidth(context),
            height: screenHeight(context),
            child: Stack(
              children: [
                Center(
                  child: _imagePath != null
                      ? Image.file(File(_imagePath!))
                      : Image.asset(
                    'assets/images/placeholder.png',
                    height: screenHeight(context),
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  right: 20.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const IDsManagerPage()),
                      );
                    },
                    backgroundColor: Colors.red.shade200,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Icon(
                      Icons.menu,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}