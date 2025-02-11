import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Prevents default back button
      title: Padding(
        padding: const EdgeInsets.only(top: 16.0), // Add padding on top
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Jersey',
            fontSize: 35,
          ),
        ),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(top: 14.0), // Aligns the menu button with the title
        child: IconButton(
          icon: const Icon(Icons.menu, size: 28), // Drawer menu icon
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Opens the DrawerMenu
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}