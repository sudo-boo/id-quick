// ids_manager_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:id_quick/utils/data_manager.dart';
import 'package:id_quick/pages/display_id_card_page.dart';


class IDsManagerPage extends StatefulWidget {
  const IDsManagerPage({super.key});

  @override
  State<IDsManagerPage> createState() => _IDsManagerPageState();
}

class _IDsManagerPageState extends State<IDsManagerPage> {
  late DataManager _dataManager;
  Map<String, String> _idMap = {};
  String? _defaultIdName;

  @override
  void initState() {
    super.initState();
    _dataManager = DataManager(context);
    _loadIds();
  }

  Future<void> _loadIds() async {
    Map<String, String> ids = await _dataManager.getAllIds();
    Map<String, String>? defaultId = await _dataManager.getDefaultId();
    setState(() {
      _idMap = ids;
      _defaultIdName = defaultId?['idName'];
    });
  }

  Future<void> _addNewId() async {
    String idName = await _promptForIdName();
    if (idName.isNotEmpty) {
      await _dataManager.pickAndAddId(idName);
      if (_idMap.isEmpty) {
        await _dataManager.setDefault(idName);
      }
      await _loadIds();
    }
  }

  Future<String> _promptForIdName() async {
    String idName = "";
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter ID Name'),
          content: TextField(
            onChanged: (value) {
              idName = value;
            },
            decoration: const InputDecoration(hintText: "ID Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return idName;
  }

  Widget _buildGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _idMap.length,
      itemBuilder: (context, index) {
        String idName = _idMap.keys.elementAt(index);
        String imagePath = _idMap[idName]!;
        bool isDefault = idName == _defaultIdName;

        return GestureDetector(
          onTap: () async {
            await _dataManager.setDefault(idName);
            await _loadIds();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isDefault ? Colors.green : Colors.grey,
                width: isDefault ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDefault ? Colors.green.shade100 : Colors.grey.shade300,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Text(
                        idName,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(10),
                          ),
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.fitHeight,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () async {
                          bool? confirmDelete = await _showDeleteConfirmation(idName);
                          if (confirmDelete == true) {
                            await _dataManager.deleteId(idName);
                            await _loadIds();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Show a confirmation dialog before deleting the ID
  Future<bool?> _showDeleteConfirmation(String idName) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete ID'),
          content: Text('Are you sure you want to delete the ID: $idName?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const DisplayIDHomePage()),
              );},
            icon: const Icon(Icons.arrow_back_ios_rounded)),
        title: const Text("IDs Manager"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _idMap.isEmpty
            ? const Center(
          child: Text(
            "No IDs added yet.",
            style: TextStyle(fontSize: 18,),
          ),
        )
            : _buildGrid(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewId,
        backgroundColor: Colors.green.shade200,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
