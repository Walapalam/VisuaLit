import 'package:flutter/material.dart';
import 'app_colours.dart' as AppColors;

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text(
              'User Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text(
              'user@example.com',
              style: TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.background,
              child: Text(
                'U',
                style: TextStyle(fontSize: 40.0, color: AppColors.subBackground),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.background, AppColors.subBackground],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            otherAccountsPictures: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  // Handle edit profile button press
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildDrawerItem(
            icon: Icons.audiotrack,
            text: 'Audiobook',
            onTap: () {
              // Handle Audiobook tap
            },
          ),
          _buildDrawerItem(
            icon: Icons.help_outline,
            text: 'Help & Support',
            onTap: () {
              // Handle Help tap
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () {
              // Handle Settings tap
            },
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            color: Colors.redAccent,
            onTap: () {
              // Handle Logout tap
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.background),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: color ?? AppColors.background,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
