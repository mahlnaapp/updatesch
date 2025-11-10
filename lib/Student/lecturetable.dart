import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'studentprovider.dart';
import '../settingsprovider.dart';

class LectureTablePage extends StatefulWidget {
  const LectureTablePage({super.key});

  @override
  State<LectureTablePage> createState() => _LectureTablePageState();
}

class _LectureTablePageState extends State<LectureTablePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int currentDayIndex;

  final List<String> days = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final weekday = (now.weekday % 7); // Dart: 1=Mon, 7=Sun
    currentDayIndex = (weekday + 1) % 7; // map Sat=0
    _tabController = TabController(
      length: days.length,
      vsync: this,
      initialIndex: currentDayIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  bool isCurrentLecture(String start, String end) {
    final now = TimeOfDay.now();
    final startTime = _parseTime(start);
    final endTime = _parseTime(end);
    bool afterStart =
        now.hour > startTime.hour ||
        (now.hour == startTime.hour && now.minute >= startTime.minute);
    bool beforeEnd =
        now.hour < endTime.hour ||
        (now.hour == endTime.hour && now.minute <= endTime.minute);
    return afterStart && beforeEnd;
  }

  bool isUpcomingLecture(String start) {
    final now = TimeOfDay.now();
    final startTime = _parseTime(start);
    return now.hour < startTime.hour ||
        (now.hour == startTime.hour && now.minute < startTime.minute);
  }

  bool isPassedLecture(String end) {
    final now = TimeOfDay.now();
    final endTime = _parseTime(end);
    return now.hour > endTime.hour ||
        (now.hour == endTime.hour && now.minute > endTime.minute);
  }

  Color getLectureColor(
    String start,
    String end,
    bool isToday,
    bool isDarkMode,
  ) {
    if (!isToday) return isDarkMode ? Colors.cyan[800]! : Colors.cyan[100]!;
    if (isCurrentLecture(start, end)) {
      return isDarkMode ? Colors.grey[800]! : Colors.white;
    }
    if (isUpcomingLecture(start)) {
      return isDarkMode ? Colors.yellow[700]! : Colors.yellow[200]!;
    }
    if (isPassedLecture(end)) {
      return isDarkMode
          ? Colors.greenAccent[400]!
          : const Color.fromARGB(132, 38, 255, 0);
    }
    return isDarkMode ? Colors.grey[700]! : Colors.grey[200]!;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final weeklyTemplate = provider.weeklyTemplate;
    final isDark = settings.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark
            ? Colors.grey[850]
            : const Color.fromARGB(255, 255, 255, 255),
        bottom: TabBar(
          indicatorColor: Colors.blueAccent,
          labelColor: Colors.blueAccent,
          unselectedLabelColor: isDark ? Colors.white70 : Colors.blue,
          controller: _tabController,
          isScrollable: true,
          tabs: days.map((day) => Tab(text: day)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(days.length, (dayIndex) {
          final dayLectures = weeklyTemplate[dayIndex] ?? [];

          if (dayLectures.isEmpty) {
            return Center(
              child: Text(
                'لا توجد محاضرات',
                style: TextStyle(color: textColor),
              ),
            );
          }

          final isToday = dayIndex == currentDayIndex;

          Map<String, dynamic>? nextLecture;
          if (isToday) {
            for (var lec in dayLectures) {
              if (isUpcomingLecture(lec['start'])) {
                nextLecture = lec;
                break;
              }
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: dayLectures.length,
            itemBuilder: (context, index) {
              final lec = dayLectures[index];
              final currentLecture =
                  isToday && isCurrentLecture(lec['start'], lec['end']);
              final upcomingLecture = nextLecture != null && lec == nextLecture;
              final passedLecture = isToday && isPassedLecture(lec['end']);
              final color = getLectureColor(
                lec['start'],
                lec['end'],
                isToday,
                isDark,
              );

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: currentLecture ? Colors.orange : Colors.black12,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black54 : Colors.black12,
                      offset: const Offset(2, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          lec['subject'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (currentLecture)
                          PulsingTag(
                            text: "المحاضرة الحالية",
                            color: Colors.orange,
                            icon: Icons.play_arrow,
                          ),
                        if (upcomingLecture)
                          PulsingTag(
                            text: "التالي",
                            color: Colors.yellow[800]!,
                            icon: Icons.arrow_forward,
                          ),
                        if (passedLecture)
                          PulsingTag(
                            text: "انتهت",
                            color: const Color.fromARGB(255, 38, 255, 0),
                            icon: Icons.check_circle_outline,
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lec['teacher'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lec['start']} - ${lec['end']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class PulsingTag extends StatefulWidget {
  final String text;
  final Color color;
  final IconData icon;

  const PulsingTag({
    super.key,
    required this.text,
    required this.color,
    required this.icon,
  });

  @override
  State<PulsingTag> createState() => _PulsingTagState();
}

class _PulsingTagState extends State<PulsingTag>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        return Transform.scale(scale: _scale.value, child: child);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 12, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              widget.text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
