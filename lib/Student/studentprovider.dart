import 'package:flutter/material.dart';

// ==========================
// 🔹 App Data Provider
// ==========================
class StudentProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  set isDarkMode(bool v) {
    _isDarkMode = v;
    notifyListeners();
  }

  String schoolName = "ثانوية الأمل للبنين";
  String studentClass = "الصف السادس العلمي";
  String subClass = "A";

  void updateStudentInfo({
    String? schoolName,
    String? studentClass,
    String? subClass,
  }) {
    if (schoolName != null) this.schoolName = schoolName;
    if (studentClass != null) this.studentClass = studentClass;
    if (subClass != null) this.subClass = subClass;
    notifyListeners();
  }

  // ==========================
  // 🔹 Weekly Lectures Template
  // ==========================
  final Map<int, List<Map<String, dynamic>>> weeklyTemplate = {
    0: [
      // Sunday
      {
        "start": "08:00",
        "end": "08:45",
        "subject": "رياضيات",
        "teacher": "أ. أحمد",
      },
      {
        "start": "08:50",
        "end": "09:35",
        "subject": "عربية",
        "teacher": "أ. منى",
      },
      {
        "start": "09:40",
        "end": "10:25",
        "subject": "فيزياء",
        "teacher": "أ. خالد",
      },
      {
        "start": "10:40",
        "end": "11:25",
        "subject": "إنكليزي",
        "teacher": "أ. سامي",
      },
      {
        "start": "11:30",
        "end": "12:15",
        "subject": "كيمياء",
        "teacher": "أ. فاطمة",
      },
    ],

    1: [
      // Monday
      {
        "start": "08:00",
        "end": "08:45",
        "subject": "أحياء",
        "teacher": "أ. أحمد",
      },
      {
        "start": "08:50",
        "end": "09:35",
        "subject": "تاريخ",
        "teacher": "أ. خالد",
      },
      {
        "start": "09:40",
        "end": "10:25",
        "subject": "رياضيات",
        "teacher": "أ. أحمد",
      },
      {
        "start": "10:40",
        "end": "11:25",
        "subject": "عربية",
        "teacher": "أ. منى",
      },
      {
        "start": "11:30",
        "end": "12:15",
        "subject": "دين",
        "teacher": "أ. يوسف",
      },
      {
        "start": "12:20",
        "end": "13:05",
        "subject": "حاسوب",
        "teacher": "أ. ليلى",
      },
    ],

    2: [
      // Tuesday
      {
        "start": "08:00",
        "end": "08:45",
        "subject": "كيمياء",
        "teacher": "أ. فاطمة",
      },
      {
        "start": "08:50",
        "end": "09:35",
        "subject": "رياضيات",
        "teacher": "أ. أحمد",
      },
      {
        "start": "09:40",
        "end": "10:25",
        "subject": "فيزياء",
        "teacher": "أ. خالد",
      },
      {
        "start": "10:40",
        "end": "11:25",
        "subject": "إنكليزي",
        "teacher": "أ. سامي",
      },
      {"start": "11:30", "end": "12:15", "subject": "فن", "teacher": "أ. مريم"},
      {
        "start": "12:20",
        "end": "13:05",
        "subject": "رياضة",
        "teacher": "أ. عمر",
      },
    ],

    3: [
      // Wednesday
      {
        "start": "08:00",
        "end": "08:45",
        "subject": "تاريخ",
        "teacher": "أ. خالد",
      },
      {
        "start": "08:50",
        "end": "09:35",
        "subject": "دين",
        "teacher": "أ. يوسف",
      },
      {
        "start": "09:40",
        "end": "10:25",
        "subject": "رياضيات",
        "teacher": "أ. أحمد",
      },
      {
        "start": "10:40",
        "end": "11:25",
        "subject": "كيمياء",
        "teacher": "أ. فاطمة",
      },
      {
        "start": "11:30",
        "end": "12:15",
        "subject": "أحياء",
        "teacher": "أ. أحمد",
      },
      {
        "start": "12:20",
        "end": "13:05",
        "subject": "عربية",
        "teacher": "أ. منى",
      },
    ],

    4: [
      // Thursday
      {
        "start": "08:00",
        "end": "08:45",
        "subject": "إنكليزي",
        "teacher": "أ. سامي",
      },
      {
        "start": "08:50",
        "end": "09:35",
        "subject": "حاسوب",
        "teacher": "أ. ليلى",
      },
      {
        "start": "09:40",
        "end": "10:25",
        "subject": "كيمياء",
        "teacher": "أ. فاطمة",
      },
      {
        "start": "10:40",
        "end": "11:25",
        "subject": "رياضة",
        "teacher": "أ. عمر",
      },
      {
        "start": "11:30",
        "end": "12:15",
        "subject": "دين",
        "teacher": "أ. يوسف",
      },
      {"start": "12:20", "end": "13:05", "subject": "فن", "teacher": "أ. مريم"},
    ],

    5: [
      // Friday
      {
        "start": "08:00",
        "end": "08:45",
        "subject": "رياضيات",
        "teacher": "أ. أحمد",
      },
      {
        "start": "08:50",
        "end": "09:35",
        "subject": "عربية",
        "teacher": "أ. منى",
      },
      {
        "start": "09:40",
        "end": "10:25",
        "subject": "فيزياء",
        "teacher": "أ. خالد",
      },
      {
        "start": "10:40",
        "end": "11:25",
        "subject": "أحياء",
        "teacher": "أ. أحمد",
      },
      {
        "start": "11:30",
        "end": "12:15",
        "subject": "دين",
        "teacher": "أ. يوسف",
      },
    ],

    6: [
      // Saturday
      {
        "start": "08:00",
        "end": "08:45",
        "subject": "كيمياء",
        "teacher": "أ. فاطمة",
      },
      {
        "start": "08:50",
        "end": "09:35",
        "subject": "تاريخ",
        "teacher": "أ. خالد",
      },
      {
        "start": "09:40",
        "end": "10:25",
        "subject": "إنكليزي",
        "teacher": "أ. سامي",
      },
      {
        "start": "10:40",
        "end": "11:25",
        "subject": "رياضيات",
        "teacher": "أ. أحمد",
      },
      {
        "start": "11:30",
        "end": "12:15",
        "subject": "عربية",
        "teacher": "أ. منى",
      },
      {
        "start": "12:20",
        "end": "13:05",
        "subject": "رياضة",
        "teacher": "أ. عمر",
      },
      {
        "start": "13:10",
        "end": "13:55",
        "subject": "حاسوب",
        "teacher": "أ. ليلى",
      },
    ],
  };

  // ==========================
  // 🔹 Historic Lectures (saved on device)
  // ==========================
  Map<String, List<Map<String, dynamic>>> historicLectures = {
    "2025-11-02": [
      {
        "start": "08:00",
        "end": "08:45",
        "subject": "رياضيات",
        "teacher": "أ. أحمد",
        "attended": 1,
      },
      {
        "start": "08:50",
        "end": "09:35",
        "subject": "عربية",
        "teacher": "أ. منى",
        "attended": 0,
      },
    ],
    "2025-11-03": [
      {
        "start": "08:00",
        "end": "08:45",
        "subject": "فيزياء",
        "teacher": "أ. خالد",
        "attended": 1,
      },
    ],
  };

  // ==========================
  // 🔹 Current Week Server Data (override)
  // ==========================
  Map<String, List<Map<String, dynamic>>> currentWeekLectures = {
    "2025-11-04": [
      {"lecture_index": 0, "attended": 1},
      {"lecture_index": 1, "attended": 0},
    ],
    "2025-11-05": [
      {"lecture_index": 0, "attended": 1},
    ],
  };

  // ==========================
  // 🔹 Fake Messages / Homework
  // ==========================
  final List<Map<String, dynamic>> fakeMessages = [
    {
      'teacher': 'أستاذ أحمد',
      'subject': 'رياضيات',
      'title': 'واجب الرياضيات',
      'date': 'منذ ٣ أيام',
      'tag': 'الواجب',
      'subTag': '',
      'edited': true,
      'message': 'حل مسائل الفصل الرابع في الجبر.',
      'details': 'الواجب يجب تسليمه قبل يوم الجمعة.',
      'due': DateTime.now().add(const Duration(days: 2)),
    },
    {
      'teacher': 'أستاذة سارة',
      'subject': 'فيزياء',
      'title': 'امتحان الفيزياء',
      'date': 'منذ 5 أيام',
      'tag': 'امتحان',
      'subTag': 'نهائي',
      'edited': false,
      'message': 'التحضير للاختبار القادم حول قوانين الحركة.',
      'details': 'سيكون الامتحان شامل لجميع المواضيع السابقة.',
      'due': DateTime.now().add(const Duration(days: 4)),
    },
    {
      'teacher': 'أستاذة سارة',
      'subject': 'عربي',
      'title': 'امتحان الاستفهام',
      'date': 'منذ 5 أيام',
      'tag': 'امتحان',
      'subTag': 'نصفي',
      'edited': false,
      'message': 'امتحان في موضوع الاستفهام',
      'details':
          'الامتحان سيكون في موضوع الاستفهام والانشاء الثالث والرابع مع أول 5 صفحات من الأدب',
      'due': DateTime.now().add(const Duration(days: 4)),
    },
    {
      'teacher': 'أستاذة سارة',
      'subject': 'كيمياء',
      'title': 'امتحان يومي',
      'date': 'منذ 5 أيام',
      'tag': 'امتحان',
      'subTag': 'يومي',
      'edited': true,
      'message': 'امتحان في العضوية',
      'details': 'الامتحان سيكون في أول 7 أنواع فقط',
      'due': DateTime.now().add(const Duration(days: 4)),
    },
    {
      'teacher': 'أستاذة منى',
      'subject': 'عربي',
      'title': 'واجب تمارين',
      'date': 'منذ ١٠ أيام',
      'tag': 'الواجب',
      'subTag': '',
      'edited': false,
      'message': 'حل تمارين صفحة 12',
      'details': '',
      'due': DateTime.now().subtract(const Duration(days: 5)),
    },
  ];

  // ==========================
  // 🔹 Current month & reactive attendance
  // ==========================
  DateTime currentMonth = DateTime.now();
  late List<AttendanceDay> currentDays;

  StudentProvider() {
    currentDays = generateMonthData(currentMonth);
  }

  void changeMonth(int delta) {
    currentMonth = DateTime(currentMonth.year, currentMonth.month + delta, 1);
    currentDays = generateMonthData(currentMonth);
    notifyListeners();
  }

  void changeYear(int delta) {
    currentMonth = DateTime(currentMonth.year + delta, currentMonth.month, 1);
    currentDays = generateMonthData(currentMonth);
    notifyListeners();
  }

  int get attendedCount => currentDays
      .where(
        (d) =>
            d.totalLectures > 0 &&
            d.missedLectures == 0 &&
            d.attendedLectures > 0,
      )
      .length;

  int get missedCount => currentDays.where((d) => d.missedLectures > 0).length;

  // ==========================
  // 🔹 Generate Month Data
  // ==========================
  List<AttendanceDay> generateMonthData(DateTime month) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    return List.generate(daysInMonth, (i) {
      final date = DateTime(month.year, month.month, i + 1);
      return AttendanceDay.fromProvider(
        date,
        historicLectures,
        currentWeekLectures,
        weeklyTemplate,
      );
    });
  }

  // ==========================
  // 🔹 Filtered Messages & Search
  // ==========================
  String _searchQuery = '';
  List<Map<String, dynamic>> get filteredMessages =>
      filterMessages(_searchQuery);

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Map<String, dynamic>> filterMessages(String query) {
    if (query.isEmpty) return fakeMessages;
    return fakeMessages.where((item) {
      final message = item['message'].toString().toLowerCase();
      final subject = item['subject'].toString().toLowerCase();
      final tag = item['tag'].toString().toLowerCase();
      final searchQuery = query.toLowerCase();
      return message.contains(searchQuery) ||
          subject.contains(searchQuery) ||
          tag.contains(searchQuery);
    }).toList();
  }

  // ==========================
  // 🔹 Homework Helpers
  // ==========================
  List<Map<String, dynamic>> get activeHomeworks => fakeMessages.where((msg) {
    return msg['tag'] == 'الواجب' &&
        msg['due'] != null &&
        (msg['due'] as DateTime).isAfter(DateTime.now());
  }).toList();

  List<Map<String, dynamic>> get archivedHomeworks => fakeMessages.where((msg) {
    return msg['tag'] == 'الواجب' &&
        msg['due'] != null &&
        (msg['due'] as DateTime).isBefore(DateTime.now());
  }).toList();

  // ==========================
  // 🔹 Helpers
  // ==========================
  Color statusColor(int attended) {
    switch (attended) {
      case 1:
        return Colors.green;
      case 0:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String statusText(int attended) {
    switch (attended) {
      case 1:
        return "حضر";
      case 0:
        return "غاب";
      default:
        return "غير محدد";
    }
  }

  // ==========================
  // 🔹 Tag Dictionary
  // ==========================
  final Map<String, TagInfo> tagDictionary = {
    'الواجب': const TagInfo(color: Colors.orange),
    'غياب': const TagInfo(color: Colors.redAccent),
    'امتحان': const TagInfo(color: Colors.green),
  };

  // ==========================
  // 🔹 Subject Icon Mapping
  // ==========================
  final Map<String, IconData> subjectIcons = {
    'عربي': Icons.menu_book,
    'كيمياء': Icons.science,
    'فيزياء': Icons.science_outlined,
    'أحياء': Icons.biotech,
    'إنكليزي': Icons.language,
    'رياضيات': Icons.calculate,
    'فرنسي': Icons.translate,
  };
}

// ==========================
// 🔹 Attendance Day
// ==========================
class AttendanceDay {
  final DateTime date;
  final int attendedLectures;
  final int missedLectures;
  final int notYetTaken;

  AttendanceDay({
    required this.date,
    required this.attendedLectures,
    required this.missedLectures,
    required this.notYetTaken,
  });

  int get totalLectures => attendedLectures + missedLectures + notYetTaken;

  factory AttendanceDay.fromProvider(
    DateTime date,
    Map<String, List<Map<String, dynamic>>> historic,
    Map<String, List<Map<String, dynamic>>> currentWeek,
    Map<int, List<Map<String, dynamic>>> weeklyTemplate,
  ) {
    final key =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    List<Map<String, dynamic>> lectures = [];

    // 1️⃣ Use historic if available
    if (historic.containsKey(key)) {
      lectures = historic[key]!;
    } else {
      // 2️⃣ If today/future → use weekly template + currentWeek data
      final weekdayIndex = (date.weekday % 7); // Saturday=0
      final template = weeklyTemplate[weekdayIndex] ?? [];
      lectures = template
          .map((l) => Map<String, dynamic>.from(l)..addAll({"attended": -1}))
          .toList();

      // Apply currentWeek overrides if any
      if (currentWeek.containsKey(key)) {
        for (var cw in currentWeek[key]!) {
          final idx = cw["lecture_index"];
          if (idx >= 0 && idx < lectures.length) {
            lectures[idx]["attended"] = cw["attended"];
          }
        }
      }
    }

    int attended = 0, missed = 0, notTaken = 0;
    for (var lec in lectures) {
      if (!lec.containsKey("attended") || lec["attended"] == -1) {
        notTaken++;
      } else if (lec["attended"] == 1) {
        attended++;
      } else if (lec["attended"] == 0) {
        missed++;
      }
    }

    return AttendanceDay(
      date: date,
      attendedLectures: attended,
      missedLectures: missed,
      notYetTaken: notTaken,
    );
  }
}

// ==========================
// 🔹 Tag Info
// ==========================
class TagInfo {
  final Color color;
  const TagInfo({required this.color});
}
