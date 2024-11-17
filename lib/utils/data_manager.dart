// data_manager.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:id_quick/utils/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  final BuildContext context;

  DataManager(this.context);

  // Add ID (name and image path)
  Future<void> addId(String idName, String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> ids = await getAllIds();
    ids[idName] = imagePath;

    await prefs.setString('ids', jsonEncode(ids));
    _showSnackBar('ID "$idName" added successfully!');
  }

  // Get all IDs
  Future<Map<String, String>> getAllIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idsString = prefs.getString('ids');
    if (idsString == null) {
      return {};
    } else {
      return Map<String, String>.from(jsonDecode(idsString));
    }
  }

  // Get specific ID image path by name
  Future<String?> getId(String idName) async {
    Map<String, String> ids = await getAllIds();
    return ids[idName];
  }

  // Delete a specific ID
  Future<void> deleteId(String idName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> ids = await getAllIds();

    if (ids.containsKey(idName)) {
      ids.remove(idName);
      await prefs.setString('ids', jsonEncode(ids));

      // If the deleted ID is the default, clear the default
      String? defaultIdName = await getDefaultIdName();
      if (defaultIdName == idName) {
        await clearDefault();
      }

      _showSnackBar('ID "$idName" deleted successfully!');
    } else {
      _showSnackBar('ID "$idName" not found.');
    }
  }

  // Get the count of stored IDs
  Future<int> getIdsCount() async {
    Map<String, String> ids = await getAllIds();
    return ids.length;
  }

  // Pick an image from the gallery or capture a new picture and add a new ID
  Future<String?> pickAndAddId(String idName) async {
    try {
      final ImagePicker picker = ImagePicker();

      final String? source = await _showImageSourceDialog();
      if (source == null) {
        _showSnackBar('No option selected.');
        return null;
      }

      final XFile? image = await picker.pickImage(
        source: source == 'Camera' ? ImageSource.camera : ImageSource.gallery,
      );

      if (image != null) {
        await addId(idName, image.path);
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

  // Show a dialog to let the user choose between Camera and Gallery
  Future<String?> _showImageSourceDialog() async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context, 'Camera');
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context, 'Gallery');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Set a specific ID as the default
  Future<void> setDefault(String idName) async {
    Map<String, String> ids = await getAllIds();
    if (ids.containsKey(idName)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('defaultId', idName);
      _showSnackBar('ID "$idName" set as default!');
    } else {
      _showSnackBar('ID "$idName" not found. Cannot set as default.');
    }
  }

  // Get the default ID name
  Future<String?> getDefaultIdName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('defaultId');
  }

  // Get the default ID details (name and image path)
  Future<Map<String, String>?> getDefaultId() async {
    String? defaultIdName = await getDefaultIdName();
    if (defaultIdName != null) {
      String? imagePath = await getId(defaultIdName);
      if (imagePath != null) {
        return {'idName': defaultIdName, 'imagePath': imagePath};
      }
    }
    return null;
  }

  // Clear the default ID
  Future<void> clearDefault() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('defaultId');
    _showSnackBar('Default ID cleared!');
  }

  // Show a snackbar for messages
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
