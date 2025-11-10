import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'teacherprovider.dart';
import '../settingsprovider.dart';

class TeacherHomeworkPage extends StatefulWidget {
  const TeacherHomeworkPage({super.key});

  @override
  State<TeacherHomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<TeacherHomeworkPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Refresh every second for live countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    final now = DateTime.now();
    final List<Map<String, dynamic>> activeHomework = [];
    final List<Map<String, dynamic>> archivedHomework = [];

    for (var hw in provider.sentHomeworks) {
      final dueDate = hw['due'] as DateTime?;
      if (dueDate != null && dueDate.isAfter(now)) {
        activeHomework.add(hw);
      } else {
        archivedHomework.add(hw);
      }
    }

    Widget buildHomeworkCard(Map<String, dynamic> hw) {
      final iconData = provider.subjectIcons[hw['subject']] ?? Icons.school;

      // Countdown calculation
      String countdownText = '';
      Color countdownColor = const Color.fromARGB(255, 62, 143, 65);
      final dueDate = hw['due'] as DateTime?;
      if (dueDate != null) {
        final diff = dueDate.difference(DateTime.now());
        if (diff.inSeconds <= 0) {
          final ago = DateTime.now().difference(dueDate);
          countdownText = 'انتهى منذ ${ago.inDays} يوم';
          countdownColor = Colors.redAccent;
        } else if (diff.inHours < 1) {
          countdownText =
              '${diff.inMinutes.remainder(60)}m ${diff.inSeconds.remainder(60)}s';
          countdownColor = Colors.redAccent;
        } else if (diff.inHours < 24) {
          countdownText =
              '${diff.inHours}h ${diff.inMinutes.remainder(60)}m ${diff.inSeconds.remainder(60)}s';
          countdownColor = Colors.orangeAccent;
        } else {
          countdownText =
              '${diff.inDays}d ${diff.inHours.remainder(24)}h ${diff.inMinutes.remainder(60)}m';
          countdownColor = Colors.greenAccent;
        }
      }

      final cardColor = settings.isDarkMode ? Colors.grey[850] : Colors.white;
      final textColor = settings.isDarkMode ? Colors.white : Colors.black87;
      final subTextColor = settings.isDarkMode
          ? Colors.grey[400]!
          : Colors.black54;

      return Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: settings.isDarkMode
                  ? Colors.black54
                  : Colors.grey.withAlpha(40),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 179, 255),
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(iconData, color: Colors.white, size: 20)),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Title and Teacher/Subject
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      hw['title'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                  ),
                  Text(
                    '${hw['teacher']} | ${hw['subject']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: subTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Row 2: Message and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      hw['message'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: subTextColor,
                      ),
                    ),
                  ),
                  if (hw['edited'] == true)
                    Text(
                      " تم التعديل عليه |",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: subTextColor,
                      ),
                    ),
                  if (hw['date'] != null)
                    Text(
                      hw['date'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: subTextColor,
                      ),
                    ),
                ],
              ),
              // Countdown below
              if (countdownText.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  countdownText,
                  style: TextStyle(
                    color: countdownColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: settings.isDarkMode ? Colors.grey[900] : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: provider.sentHomeworks.isEmpty
            ? Center(
                child: Text(
                  'لم ترسل أي واجبات بعد',
                  style: TextStyle(
                    fontSize: 16,
                    color: settings.isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              )
            : ListView(
                children: [
                  if (activeHomework.isNotEmpty) ...[
                    Text(
                      'واجبات حالية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: settings.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...activeHomework.map(
                      (hw) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: buildHomeworkCard(hw),
                      ),
                    ),
                  ],
                  if (archivedHomework.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ExpansionTile(
                      title: Text(
                        'واجبات منتهية',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: settings.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      initiallyExpanded: false,
                      children: archivedHomework
                          .map(
                            (hw) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: buildHomeworkCard(hw),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
