import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'studentprovider.dart';
import '../settingsprovider.dart';

class ExamsPage extends StatelessWidget {
  const ExamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final exams = provider.fakeMessages
        .where((msg) => msg['tag'] == 'امتحان')
        .toList();

    Widget buildExamCard(Map<String, dynamic> exam) {
      final iconData = provider.subjectIcons[exam['subject']] ?? Icons.school;

      final dueDate = exam['due'] as DateTime?;
      final dueDateText = dueDate != null
          ? '${dueDate.day}/${dueDate.month}/${dueDate.year}'
          : '';

      final subTag = (exam['subTag'] ?? '').toString().toLowerCase();
      final isFinal = subTag.contains('نهائي');
      final isMid = subTag.contains('نصفي');
      final isDaily = subTag.contains('يومي');

      final cardColor = settings.isDarkMode ? Colors.grey[850] : Colors.white;
      final textColor = settings.isDarkMode ? Colors.white : Colors.black87;
      final subTextColor = settings.isDarkMode
          ? Colors.grey[400]!
          : Colors.black54;
      final detailCardColor = settings.isDarkMode
          ? Colors.grey[800]
          : Colors.grey[100];

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: settings.isDarkMode
                  ? Colors.black54
                  : Colors.grey.withAlpha(30),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          color: cardColor,
        ),
        child: Row(
          children: [
            // Left strip for Final & Mid
            if (isFinal)
              Container(
                width: 6,
                height: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.redAccent, Colors.orangeAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              )
            else if (isMid)
              Container(
                width: 4,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withAlpha(120),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Icon + Title + SubTag
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isFinal
                                ? Colors.redAccent
                                : isMid
                                ? Colors.orangeAccent
                                : const Color.fromARGB(255, 0, 179, 255),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              iconData,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exam['title'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isFinal
                                      ? Colors.redAccent
                                      : isMid
                                      ? Colors.orangeAccent
                                      : textColor,
                                ),
                              ),
                              if (subTag.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isFinal
                                        ? Colors.redAccent.withAlpha(180)
                                        : isMid
                                        ? Colors.orangeAccent.withAlpha(150)
                                        : Colors.greenAccent.withAlpha(250),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isFinal || isMid)
                                        Icon(
                                          isFinal ? Icons.star : Icons.circle,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      if (isFinal || isMid)
                                        const SizedBox(width: 4),
                                      Text(
                                        exam['subTag'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Message + publish date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            exam['message'] ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: subTextColor,
                            ),
                          ),
                        ),
                        if (dueDateText.isNotEmpty)
                          Text(
                            dueDateText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: subTextColor,
                            ),
                          ),
                      ],
                    ),
                    if ((exam['details'] ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: detailCardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          exam['details'],
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    // 3-field row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _ExamField(
                            title: 'نهائي',
                            color: Colors.redAccent,
                            active: isFinal,
                            icon: isFinal ? Icons.star : null,
                            isDarkMode: settings.isDarkMode,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _ExamField(
                            title: 'نصفي',
                            color: Colors.orangeAccent,
                            active: isMid,
                            icon: isMid ? Icons.circle : null,
                            isDarkMode: settings.isDarkMode,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _ExamField(
                            title: 'يومي',
                            color: Colors.green,
                            active: isDaily,
                            isDarkMode: settings.isDarkMode,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: settings.isDarkMode ? Colors.grey[900] : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: exams.isEmpty
            ? Center(
                child: Text(
                  'لا توجد امتحانات حالياً',
                  style: TextStyle(
                    fontSize: 16,
                    color: settings.isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              )
            : ListView(
                children: exams.map((exam) => buildExamCard(exam)).toList(),
              ),
      ),
    );
  }
}

class _ExamField extends StatelessWidget {
  final String title;
  final Color color;
  final bool active;
  final IconData? icon;
  final bool isDarkMode;

  const _ExamField({
    required this.title,
    required this.color,
    this.active = false,
    this.icon,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = active
        ? color.withAlpha(180)
        : isDarkMode
        ? Colors.grey[700]
        : Colors.grey[200];

    final textColor = active
        ? Colors.white
        : isDarkMode
        ? Colors.grey[300]
        : Colors.grey[600];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: active ? Border.all(color: color, width: 1.5) : null,
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 4),
            ],
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
