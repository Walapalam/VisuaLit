import 'package:flutter/material.dart';
import 'package:visualit_app/views/about_page.dart';
import 'package:visualit_app/views/account_settings_page.dart';
import 'package:visualit_app/views/privacy_settings_page.dart';
import 'help_support_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[50],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Column(
                  children: [
                    _buildSectionTitle('Preferences'),
                    _buildCustomTile('Dark Mode', Switch.adaptive(value: false, onChanged: (value) {})),
                    _buildCustomTile('Font Size', _buildDropdown({12: 'Small', 14: 'Medium', 16: 'Large'}, 14, (newValue) {})),
                    _buildCustomTile('Language', _buildDropdown({'en': 'English'}, 'en', (newValue) {})),
                    _buildCustomTile('Notifications', Switch.adaptive(value: true, onChanged: (value) {})),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Account'),
                    _buildNavTile(context, 'Account Settings', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSettingsPage()))),
                    _buildNavTile(context, 'Privacy Settings', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacySettingsPage()))),
                    const SizedBox(height: 20),
                    _buildSectionTitle('More'),
                    _buildNavTile(context, 'About', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()))),
                    _buildNavTile(context, 'Help & Support', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportPage()))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  Widget _buildCustomTile(String title, Widget trailing) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          trailing,
        ],
      ),
    );
  }

  Widget _buildDropdown<T>(Map<T, String> items, T value, Function(T?) onChanged) {
    return DropdownButton<T>(
      value: value,
      items: items.entries.map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value))).toList(),
      onChanged: onChanged,
      underline: Container(),
    );
  }

  Widget _buildNavTile(BuildContext context, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
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
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}