import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../settingsprovider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    setState(() {
      appVersion = "1.0"; // Replace with package_info_plus if needed
    });
  }

  Future<void> _signOut() async {
    final storage = const FlutterSecureStorage();
    await storage.deleteAll();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainApp()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),

          // Dark Mode Toggle
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Consumer<SettingsProvider>(
              builder: (context, settings, _) => SwitchListTile(
                activeColor: Colors.blue,
                title: const Text('الوضع الليلي'),
                value: settings.isDarkMode,
                onChanged: (v) => settings.toggleTheme(v),
                secondary: const Icon(Icons.dark_mode),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Privacy Settings
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('سياسة الخصوصية'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPage()),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Terms of Use
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.description),
              title: const Text('شروط الاستخدام'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TermsPage()),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Sign Out
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('تسجيل الخروج'),
              onTap: _signOut,
            ),
          ),
          const SizedBox(height: 30),

          // App Version
          Center(
            child: Text(
              'الإصدار: $appVersion',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================
// Privacy Page
// =====================
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سياسة الخصوصية')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'هنا سيتم عرض سياسة الخصوصية.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// =====================
// Terms Page
// =====================
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شروط الاستخدام')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'هنا سيتم عرض شروط الاستخدام.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
