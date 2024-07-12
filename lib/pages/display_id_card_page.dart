// display_id_card_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insti_id/utils/helper_functions.dart';
import 'package:insti_id/utils/data_manager.dart';

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
    _loadImagePath();
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
      backgroundColor: const Color(0xFFF1F1F5),
      body: Stack(
        children: [
          Center(
            child: _imagePath != null
                ? Image.file(File(_imagePath!))
                : Image.asset(
              'assets/images/placeholder_page.png',
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
              backgroundColor: const Color(0xFFC3CDEB),
              elevation: 0.0, // This removes the shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const Icon(
                Icons.add_circle_outline_rounded,
                size: 30,
                color: Color(0xFF121212),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
