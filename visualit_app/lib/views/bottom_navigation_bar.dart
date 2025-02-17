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
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.r),
          bottomRight: Radius.circular(15.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.r,
            spreadRadius: 1.r,
            offset: Offset(0, -3.h),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: GNav(
        gap: 1.w,
        activeColor: Colors.black,
        color: Colors.black.withOpacity(0.5),
        iconSize: 22.sp,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        duration: const Duration(milliseconds: 300),
        tabBackgroundColor: Colors.black12,
        curve: Curves.easeInOut,
        rippleColor: Colors.black12,
        selectedIndex: selectedIndex,
        onTabChange: onItemTapped,
        tabs: [
          _buildTab(CupertinoIcons.person, "    Profile", selectedIndex == 0),
          _buildTab(CupertinoIcons.home, "  Home", selectedIndex == 1),
          _buildTab(CupertinoIcons.settings, "Settings", selectedIndex == 2),
        ],
      ),
    );
  }

  GButton _buildTab(IconData icon, String label, bool isSelected) {
    return GButton(
      icon: icon,
      iconSize: isSelected ? 26.sp : 20.sp,
      text: label,
      textStyle: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: isSelected ? Colors.black : Colors.grey.shade700,
      ),
    );
  }
}