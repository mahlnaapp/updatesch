import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'studentprovider.dart';
import 'lecture_attendance.dart';
import '../settingsprovider.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});
  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<String> weekDays = [
    'سبت',
    'أحد',
    'ثنين',
    'ثلاثاء',
    'أربعاء',
    'خميس',
    'جمعة',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    final days = provider.currentDays;
    final currentMonth = provider.currentMonth;

    int weekday = days.isNotEmpty ? days.first.date.weekday : 6;
    int firstWeekdayOffset = (weekday + 1) % 7; // Saturday start
    List<AttendanceDay?> paddedDays =
        List<AttendanceDay?>.filled(firstWeekdayOffset, null) + days;

    final bgColor = settings.isDarkMode ? Colors.grey[900] : Colors.grey[100];
    final textColor = settings.isDarkMode
        ? Colors.white
        : const Color.fromARGB(221, 53, 53, 53);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Year / Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, color: textColor),
                onPressed: () => provider.changeYear(-1),
              ),
              Text(
                '${currentMonth.year}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right, color: textColor),
                onPressed: () => provider.changeYear(1),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, color: textColor),
                onPressed: () => provider.changeMonth(-1),
              ),
              Text(
                '${currentMonth.month} / ${currentMonth.year}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right, color: textColor),
                onPressed: () => provider.changeMonth(1),
              ),
            ],
          ),

          // Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Chip(
                label: Text(
                  'حضور: ${provider.attendedCount}',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: settings.isDarkMode
                    ? Colors.greenAccent
                    : Colors.green,
              ),
              const SizedBox(width: 12),
              Chip(
                label: Text(
                  'غياب: ${provider.missedCount}',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: settings.isDarkMode
                    ? Colors.redAccent
                    : Colors.red,
              ),
            ],
          ),

          // Weekdays
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays
                  .map(
                    (d) => Text(
                      d,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          // Grid of days
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
              ),
              itemCount: paddedDays.length,
              itemBuilder: (context, index) {
                final day = paddedDays[index];
                if (day == null) return const SizedBox.shrink();

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LectureDetailsPage(date: day.date),
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return CustomPaint(
                          painter: FluidAttendancePainter(
                            attendedLectures: day.attendedLectures,
                            missedLectures: day.missedLectures,
                            notYetTaken: day.notYetTaken,
                            waveValue: _controller.value,
                            isDarkMode: settings.isDarkMode,
                          ),
                          child: Center(
                            child: Text(
                              '${day.date.day}',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================
// 🔹 Fluid Attendance Painter
// ==========================
class FluidAttendancePainter extends CustomPainter {
  final int attendedLectures;
  final int missedLectures;
  final int notYetTaken;
  final double waveValue;
  final bool isDarkMode;

  FluidAttendancePainter({
    required this.attendedLectures,
    required this.missedLectures,
    required this.notYetTaken,
    required this.waveValue,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final totalHeight = 2 * radius;
    final total = attendedLectures + missedLectures + notYetTaken;

    // Background
    final basePaint = Paint()
      ..color = isDarkMode
          ? const Color.fromARGB(80, 80, 80, 80)
          : const Color.fromARGB(60, 128, 128, 128);
    canvas.drawCircle(center, radius, basePaint);

    if (total > 0) {
      canvas.save();
      canvas.clipPath(
        Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
      );

      final greenHeight = attendedLectures / total * totalHeight;
      final redHeight = missedLectures / total * totalHeight;

      // Red section
      if (missedLectures > 0) {
        final redPaint = Paint()
          ..color = isDarkMode
              ? Colors.redAccent
              : Colors.red; // keep original for light
        final topY = totalHeight - (greenHeight + redHeight);
        final waveAmplitude = 4.0;
        final wavelength = size.width / 1.2;
        final xShift = -waveValue * wavelength * 2;

        final redPath = Path()..moveTo(0, topY);
        for (double x = 0; x <= size.width; x++) {
          final y =
              topY + sin((x + xShift) / wavelength * 2 * pi) * waveAmplitude;
          redPath.lineTo(x, y);
        }
        redPath.lineTo(size.width, totalHeight);
        redPath.lineTo(0, totalHeight);
        redPath.close();
        canvas.drawPath(redPath, redPaint);
      }

      // Green section
      if (attendedLectures > 0) {
        final greenPaint = Paint()
          ..color = isDarkMode
              ? Colors.greenAccent
              : Colors.green; // keep original for light
        final topY = totalHeight - greenHeight;
        final waveAmplitude = 2.0;
        final wavelength = size.width / 1.2;
        final xShift = -waveValue * wavelength * 2;

        final greenPath = Path()..moveTo(0, topY);
        for (double x = 0; x <= size.width; x++) {
          final y =
              topY + sin((x + xShift) / wavelength * 2 * pi) * waveAmplitude;
          greenPath.lineTo(x, y);
        }
        greenPath.lineTo(size.width, totalHeight);
        greenPath.lineTo(0, totalHeight);
        greenPath.close();
        canvas.drawPath(greenPath, greenPaint);
      }

      canvas.restore();
    }

    // Rings
    final ringColor = isDarkMode ? Colors.white70 : Colors.white;

    final inner = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 3, inner);

    final outer = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, outer);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
