import 'package:flutter/material.dart';
import 'app_colours.dart' as AppColors;

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text('User Name'),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.background,
                child: Text(
                  'U',
                  style: TextStyle(fontSize: 40.0, color: AppColors.subBackground),
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
              ),
              otherAccountsPictures: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: AppColors.subBackground),
                  onPressed: () {
                    // Handle edit profile button press
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.audiotrack, color: AppColors.background),
              title: Text('Audiobook', style: TextStyle(color: AppColors.background)),
              onTap: () {
                // Handle Audiobook tap
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: AppColors.background),
              title: Text('Help', style: TextStyle(color: AppColors.background)),
              onTap: () {
                // Handle Help tap
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: AppColors.background),
              title: Text('Settings', style: TextStyle(color: AppColors.background)),
              onTap: () {
                // Handle Settings tap
              },
            ),
          ],
        ),
        ListTile(
          leading: Icon(Icons.logout, color: AppColors.background),
          title: Text('Logout', style: TextStyle(color: AppColors.background)),
          onTap: () {
            // Handle Logout tap
          },
        ),
      ],
    );
  }
}