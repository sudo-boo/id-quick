// data-manager.dart

import 'package:flutter/material.dart';
import 'package:id_quick/utils/helper_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  final BuildContext context;

  DataManager(this.context);

  Future<String?> loadImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('imagePath');
  }

  Future<void> saveImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagePath', path);
    _showSnackBar('ID locked and loaded!');
  }

  Future<String?> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        await saveImagePath(image.path);
        return image.path;
      } else {
        _showSnackBar('No image selected.');
        return null;
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e');
      return null;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: screenHeight(context) * 0.1,
          right: screenWidth(context) * 0.25,
          left: screenWidth(context) * 0.25,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }


}
