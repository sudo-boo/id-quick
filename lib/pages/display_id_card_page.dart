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
  int _quarterTurns = 0; // Tracks the number of 90-degree rotations

  @override
  void initState() {
    super.initState();
    _dataManager = DataManager(context);
    _loadDefaultImagePath();
    setupWindowFlags();
  }

  Future<void> setupWindowFlags() async {
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

  void _rotateImage() {
    setState(() {
      _quarterTurns = (_quarterTurns + 1) % 4;
    });
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
                  child: RotatedBox(
                    quarterTurns: _quarterTurns,
                    child: _imagePath != null
                        ? Image.file(
                      File(_imagePath!),
                      fit: BoxFit.contain,
                    )
                        : Image.asset(
                      'assets/images/placeholder.png',
                      height: screenHeight(context),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  right: 20.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        heroTag: 'rotate_button',
                        onPressed: _rotateImage,
                        backgroundColor: Colors.red.shade200,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: const Icon(
                          Icons.rotate_right_rounded,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        heroTag: 'menu_button',
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
                    ],
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
