import 'package:flutter/material.dart';
import '../models/grade_model.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GradeModel> grades = [
      GradeModel("الرياضيات", "أ. علي", 18, 20, 10, "تحسن واضح في المستوى."),
      GradeModel("العربية", "أ. نور", 17, 19, 9, "مشاركة جيدة في الصف."),
      GradeModel(
        "الإنكليزية",
        "أ. هدى",
        16,
        20,
        10,
        "نطق ممتاز وتحسن في الكتابة.",
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("الدرجات")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: grades.length,
        itemBuilder: (context, index) {
          final subject = grades[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                subject.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("المعلم: ${subject.teacher}"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(subject.name),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("المعلم: ${subject.teacher}"),
                        const SizedBox(height: 8),
                        Text("الامتحان الشهري: ${subject.monthly}"),
                        Text("الامتحان اليومي: ${subject.daily}"),
                        Text("الواجب: ${subject.homework}"),
                        const Divider(),
                        Text("ملاحظات المعلم: ${subject.comment}"),
                      ],
                    ),
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
