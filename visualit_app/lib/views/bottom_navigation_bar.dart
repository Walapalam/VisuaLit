import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF0F0F0), Color(0xFFDEDEDE)], // Light grey gradient
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),  // Retaining bottom rounded edges
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 3,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: GNav(
              gap: 10,
              activeColor: Colors.black,
              color: Colors.black.withOpacity(0.5),
              iconSize: 20,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Reduced vertical padding
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.white.withOpacity(0.9), // Soft selection effect
              curve: Curves.easeInOut,
              rippleColor: Colors.black12,
              selectedIndex: selectedIndex,
              onTabChange: onItemTapped,
              tabs: [
                _buildTab(Icons.account_circle, "Profile", selectedIndex == 0),
                _buildTab(Icons.add, "Add", selectedIndex == 1),
                _buildTab(Icons.home, "Home", selectedIndex == 2),
                _buildTab(Icons.audiotrack, "Audiobook", selectedIndex == 3),
                _buildTab(Icons.settings, "Settings", selectedIndex == 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GButton _buildTab(IconData icon, String label, bool isSelected) {
    return GButton(
      icon: icon,
      iconSize: isSelected ? 32 : 24,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: isSelected ? 34 : 24,
            color: isSelected ? Colors.black : Colors.grey.shade700,
          ),
          if (isSelected) const SizedBox(height: 4),
          if (isSelected)
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}