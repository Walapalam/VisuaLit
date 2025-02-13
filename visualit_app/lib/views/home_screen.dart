import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'drawer_menu.dart'; // Import the drawer menu
import 'home.dart';
import 'profile_screen.dart';
import 'bottom_navigation_bar.dart';
import 'VisuaLit_appBar.dart'; // Import the custom app bar
import 'settings_page.dart';
import 'audiobook_page.dart'; // Import the audiobook page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812), // Adjust based on your design reference
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}

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
    AudiobookPage(), // Add the AudiobookPage widget
    SettingsPage(),
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
