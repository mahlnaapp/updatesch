import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        "title": "امتحان مادة الرياضيات",
        "date": "الأحد 2 نوفمبر 2025",
        "details": "سيُجرى الامتحان في الساعة 9:00 صباحاً في القاعة (B).",
      },
      {
        "title": "امتحان مادة الفيزياء",
        "date": "الثلاثاء 4 نوفمبر 2025",
        "details": "سيُجرى الامتحان في الساعة 10:30 صباحاً في القاعة (A).",
      },
      {
        "title": "تسليم الواجب الأسبوعي",
        "date": "الخميس 6 نوفمبر 2025",
        "details":
            "يجب تسليم واجب اللغة العربية إلى المعلمة نور قبل الساعة 8:00 مساءً.",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("الرئيسية")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.notifications_active,
                color: Colors.indigo,
              ),
              title: Text(
                item["title"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item["date"]!),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(item["title"]!),
                    content: Text(item["details"]!),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("إغلاق"),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
