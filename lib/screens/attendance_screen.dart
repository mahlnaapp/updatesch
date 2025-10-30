import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final Map<int, String> attendanceData = {
    1: "present",
    2: "absent",
    3: "holiday",
    4: "present",
    5: "absent",
    6: "present",
    10: "absent",
    13: "holiday",
    14: "present",
  };

  String? selectedStatus;
  String? subject = "الرياضيات";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الحضور والغيابات")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "شهر أكتوبر 2025",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(30, (index) {
                int day = index + 1;
                String? status = attendanceData[day];
                Color color = Colors.grey;
                if (status == "present") color = Colors.green;
                if (status == "absent") color = Colors.red;
                if (status == "holiday") color = Colors.grey.shade400;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStatus = status;
                    });
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "اليوم: $day أكتوبر",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("المادة: $subject"),
                            const SizedBox(height: 8),
                            Text(
                              status == "present"
                                  ? "الطالب حاضر بالكامل ✅"
                                  : status == "absent"
                                  ? "الطالب غائب بالكامل ❌"
                                  : "عطلة رسمية 💤",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: color.withOpacity(0.2),
                    child: Text(
                      "$day",
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
