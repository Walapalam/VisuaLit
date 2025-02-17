// lib/views/listening_screen_nav_bar_page.dart
import 'package:flutter/material.dart';

class ListeningScreenNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const ListeningScreenNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 18),
      elevation: 0, // Remove shadow
      items: const [
        BottomNavigationBarItem(
          icon: SizedBox.shrink(),
          label: 'Chapters',
        ),
        BottomNavigationBarItem(
          icon: SizedBox.shrink(),
          label: 'Lyrics',
        ),
        BottomNavigationBarItem(
          icon: SizedBox.shrink(),
          label: 'Related',
        ),
      ],
    );
  }
}