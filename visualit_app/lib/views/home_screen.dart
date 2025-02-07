import 'package:flutter/material.dart';
import 'app_colours.dart' as AppColors;
import 'drawer_menu.dart';
import 'home.dart';
import 'profile_screen.dart';
import 'bottom_navigation_bar.dart';
import 'VisuaLit_appBar.dart'; // Import the custom app bar

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;

  static const List<Widget> _widgetOptions = <Widget>[
    ProfileScreen(),
    Text(
      'Add New Book Page',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
    Home(),
    Text(
      'Audiobook Page',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
    Text(
      'Settings Page',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'VisuaLit'),
      drawer: const Drawer(
        child: DrawerMenu(),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}