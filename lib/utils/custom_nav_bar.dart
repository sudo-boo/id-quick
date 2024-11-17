// nav_bar.dart

import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isTransparent;

  const CustomNavBar({super.key, required this.title, this.isTransparent = false});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 23,
        ),
      ),
      backgroundColor: isTransparent ? Colors.transparent : Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }
}
