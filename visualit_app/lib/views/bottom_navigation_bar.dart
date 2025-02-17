import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6.r, // Reduced blur for subtle effect
            spreadRadius: 1.5.r, // Slightly smaller spread
            offset: Offset(0, -1.5.h), // Reduced shadow height
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h), // Reduced padding
      child: GNav(
        gap: 5.w, // Slightly reduced spacing
        activeColor: Colors.black,
        color: Colors.black.withOpacity(0.6),
        iconSize: 22.sp, // Reduced icon size by 1-2 sp
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h), // Smaller button padding
        duration: const Duration(milliseconds: 300),
        tabBackgroundColor: Colors.black.withOpacity(0.1),
        curve: Curves.easeInOut,
        rippleColor: Colors.black12,
        selectedIndex: selectedIndex,
        onTabChange: onItemTapped,
        tabs: [
          _buildTab(CupertinoIcons.person, "Profile", selectedIndex == 0),
          _buildTab(CupertinoIcons.home, "Home", selectedIndex == 1),
          _buildTab(CupertinoIcons.settings, "Settings", selectedIndex == 2),
        ],
      ),
    );
  }

  GButton _buildTab(IconData icon, String label, bool isSelected) {
    return GButton(
      icon: icon,
      iconSize: isSelected ? 26.sp : 20.sp, // Reduced both selected and default sizes
      text: label,
      textStyle: TextStyle(
        fontSize: 13.sp, // Reduced text size slightly
        fontWeight: FontWeight.w600,
        color: isSelected ? Colors.black : Colors.grey.shade700,
      ),
    );
  }
}
