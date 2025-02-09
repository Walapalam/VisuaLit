import 'package:flutter/material.dart';
import 'package:visualit_app/views/settings_page.dart';
import 'package:visualit_app/views/help_support_page.dart';
import 'app_colours.dart' as AppColors;

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[50],
        child: Column(
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
                backgroundColor: Colors.white,
                child: Text(
                  'U',
                  style: TextStyle(fontSize: 40.0, color: AppColors.background),
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
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    // Handle edit profile button press
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpSupportPage()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    text: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.background),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: color ?? Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}