import 'package:flutter/material.dart';

class TeacherProvider extends ChangeNotifier {
  // Fake server data
  final Map<String, Map<String, List<String>>> schools = {
    "ثانوية الأمل للبنين": {
      "الصف السادس العلمي": ["A", "B", "C"],
      "الصف الخامس الأدبي": ["A", "B"],
    },
    "ثانوية النجاح للبنات": {
      "الصف السابع العلمي": ["A", "B"],
      "الصف السادس الأدبي": ["A"],
    },
  };

  // Teacher info (set from server according to email)
  String teachername = "أحمد";
  String subject = "رياضيات";
  String teacheremail = "rk@email.com";
  String selectedSchool;
  String selectedClass;
  String selectedSubClass;

  List<Map<String, dynamic>> sentHomeworks = [];
  final List<Map<String, dynamic>> homeworkList = [];

  void setEmail(String email) {
    teacheremail = email;
    notifyListeners();
  }

  TeacherProvider()
    : selectedSchool = "ثانوية الأمل للبنين",
      selectedClass = "الصف السادس العلمي",
      selectedSubClass = "A";

  String generateHomeworkId() {
    final emailPart = teacheremail.split('@').first;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$emailPart-$timestamp';
  }

  // =====================
  // Selection methods
  // =====================
  void setSchool(String school) {
    selectedSchool = school;
    selectedClass = schools[school]?.keys.first ?? "";
    selectedSubClass = schools[selectedSchool]?[selectedClass]?.first ?? "";
    notifyListeners();
  }

  void setClass(String cls) {
    selectedClass = cls;
    selectedSubClass = schools[selectedSchool]?[cls]?.first ?? "";
    notifyListeners();
  }

  void setSubClass(String sub) {
    selectedSubClass = sub;
    notifyListeners();
  }

  void addHomework(Map<String, dynamic> hw) {
    sentHomeworks.add(hw);
    notifyListeners();
  }

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
