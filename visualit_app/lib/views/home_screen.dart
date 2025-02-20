import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'drawer_menu.dart'; // Import the drawer menu
import 'package:visualit_app/views/search_results_page.dart';
import 'app_colours.dart' as AppColors;
import 'drawer_menu.dart';
import 'home.dart';
import 'profile_screen.dart';
import 'bottom_navigation_bar.dart';
import 'VisuaLit_appBar.dart'; // Import the custom app bar
import 'settings_page.dart';
import 'text_to_speech_screen.dart';

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
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  static const List<Widget> _widgetOptions = <Widget>[
    ProfileScreen(),
    Home(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        } else {
          Scaffold.of(context).openDrawer();
          return false;
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: 'VisuaLit'),
        drawer: const Drawer(
          child: DrawerMenu(),
        ),
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.primaryDelta! < -20) {
              if (_selectedIndex < _widgetOptions.length - 1) {
                _onItemTapped(_selectedIndex + 1);
              }
            } else if (details.primaryDelta! > 20) {
              if (_selectedIndex > 0) {
                _onItemTapped(_selectedIndex - 1);
              }
            }
          },
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: _widgetOptions,
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
