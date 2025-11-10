import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'studentprovider.dart';
import '../settingsprovider.dart';

class LectureDetailsPage extends StatelessWidget {
  final DateTime date;
  const LectureDetailsPage({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    final String key =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    List<Map<String, dynamic>> lectures = [];
    if (provider.historicLectures.containsKey(key)) {
      lectures = provider.historicLectures[key]!;
    } else {
      final weekdayIndex = date.weekday % 7;
      lectures = provider.weeklyTemplate[weekdayIndex]!
          .map((l) => Map<String, dynamic>.from(l)..addAll({"attended": -1}))
          .toList();
      if (provider.currentWeekLectures.containsKey(key)) {
        for (var cw in provider.currentWeekLectures[key]!) {
          final idx = cw["lecture_index"];
          if (idx >= 0 && idx < lectures.length) {
            lectures[idx]["attended"] = cw["attended"];
          }
        }
      }
    }

    final bgColor = settings.isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = settings.isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'تفاصيل اليوم ${date.day}/${date.month}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: settings.isDarkMode
            ? Colors.grey[850]
            : const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.separated(
          itemCount: lectures.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final lec = lectures[index];
            final attended = lec["attended"];
            final hasData = lec.isNotEmpty;

            final cardColor = settings.isDarkMode
                ? Colors.grey[800]
                : Colors.white;

            return Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: settings.isDarkMode
                        ? Colors.black54
                        : Colors.grey.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: hasData
                      ? provider.statusColor(attended)
                      : Colors.grey,
                  child: Text('${index + 1}'),
                ),
                title: Text(
                  hasData ? lec["subject"] ?? "" : "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                subtitle: hasData
                    ? Text(
                        '${lec["teacher"] ?? ""}\n${lec["start"] ?? ""} - ${lec["end"] ?? ""}',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: textColor,
                        ),
                      )
                    : Text("", style: TextStyle(color: textColor)),
                trailing: Text(
                  hasData ? provider.statusText(attended) : "",
                  style: TextStyle(
                    color: hasData
                        ? provider.statusColor(attended)
                        : Colors.transparent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
