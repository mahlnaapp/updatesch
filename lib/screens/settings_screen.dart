import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الإعدادات")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("الملف الشخصي"),
            subtitle: const Text("عرض وتعديل بياناتك"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text("تغيير المظهر"),
            subtitle: const Text("الوضع الداكن / الفاتح"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("حول التطبيق"),
            subtitle: const Text("إصدار 1.0.0"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("تسجيل الخروج"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
