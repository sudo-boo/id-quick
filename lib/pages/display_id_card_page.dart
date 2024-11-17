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

  Future<void> _loadImagePath() async {
    String? path = await _dataManager.loadImagePath();
    setState(() {
      _imagePath = path;
    });
  }

  Future<void> _pickImage() async {
    String? path = await _dataManager.pickImage();
    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Builder(
        builder: (BuildContext context) {
          // Use Builder to get context for SnackBar if needed
          return SizedBox(
            // Ensure the container fills the entire screen
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
                    onPressed: () async {
                      await _pickImage();
                    },
                    backgroundColor: Colors.red.shade200,
                    elevation: 0.0,
                    // This removes the shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Icon(
                      Icons.add_circle_outline_rounded,
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