import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settingsprovider.dart';
import 'teacherprovider.dart';
import 'settings.dart';
import 'homework.dart';

class Teacher extends StatelessWidget {
  const Teacher({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'نظام المعلمين',
            theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.blue,
              fontFamily: 'Arial',
              brightness: settings.isDarkMode
                  ? Brightness.dark
                  : Brightness.light,
              scaffoldBackgroundColor: settings.isDarkMode
                  ? Colors.grey[900]
                  : Colors.grey[100],
              appBarTheme: AppBarTheme(
                backgroundColor: settings.isDarkMode
                    ? Colors.grey[850]
                    : Colors.blue[50],
                foregroundColor: settings.isDarkMode
                    ? Colors.blue
                    : Colors.blueAccent,
              ),
            ),
            home: const TeacherMainPage(),
          );
        },
      ),
    );
  }
}

class TeacherMainPage extends StatefulWidget {
  const TeacherMainPage({super.key});

  @override
  State<TeacherMainPage> createState() => _TeacherMainPageState();
}

class _TeacherMainPageState extends State<TeacherMainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final provider = Provider.of<TeacherProvider>(context);

    final List<Widget> pages = [
      const TeacherHomePage(),
      const TeacherHomeworkPage(),
      const TeacherAttendancePage(),
      const TeacherExamsPage(),
      const TeacherSchedulePage(),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 1,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.selectedSchool,
                style: TextStyle(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                "${provider.selectedClass} : ${provider.selectedSubClass}",
                style: TextStyle(
                  color: settings.isDarkMode ? Colors.white70 : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: settings.isDarkMode ? Colors.blue : Colors.blueAccent,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TeacherSettingsPage(),
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {
                _showChangeDialog(context, provider, settings);
              },
              child: Text(
                "تغيير",
                style: TextStyle(
                  color: settings.isDarkMode ? Colors.blue : Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: settings.isDarkMode
            ? Colors.blue
            : Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: settings.isDarkMode ? Colors.grey[850] : Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'الواجبات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_busy),
            label: 'الحضور',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'الامتحانات',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'الجدول'),
        ],
      ),
    );
  }

  void _showChangeDialog(
    BuildContext context,
    TeacherProvider provider,
    SettingsProvider settings,
  ) {
    String tempSchool = provider.selectedSchool;
    String tempClass = provider.selectedClass;
    String tempSub = provider.selectedSubClass;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final classes = provider.schools[tempSchool]?.keys.toList() ?? [];
            final subs = provider.schools[tempSchool]?[tempClass] ?? [];

            return AlertDialog(
              title: const Text("تغيير المدرسة / الصف / الشعبة"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: tempSchool,
                    isExpanded: true,
                    items: provider.schools.keys
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        tempSchool = val;
                        tempClass = provider.schools[val]?.keys.first ?? "";
                        tempSub =
                            provider.schools[val]?[tempClass]?.first ?? "";
                        setStateDialog(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: tempClass,
                    isExpanded: true,
                    items: classes
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        tempClass = val;
                        tempSub =
                            provider.schools[tempSchool]?[val]?.first ?? "";
                        setStateDialog(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: tempSub,
                    isExpanded: true,
                    items: subs
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        tempSub = val;
                        setStateDialog(() {});
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "إلغاء",
                    style: TextStyle(
                      color: settings.isDarkMode
                          ? Colors.blue
                          : Colors.blueAccent,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: settings.isDarkMode
                        ? Colors.blue
                        : Colors.blueAccent,
                  ),
                  onPressed: () {
                    provider.setSchool(tempSchool);
                    provider.setClass(tempClass);
                    provider.setSubClass(tempSub);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "تأكيد",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ============ PAGES ============

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final teacherProvider = Provider.of<TeacherProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "الصفحة الرئيسية للمعلمين",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: settings.isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // === Homework Card ===
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: settings.isDarkMode ? Colors.grey[850] : Colors.white,
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'إرسال واجب جديد',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: settings.isDarkMode
                            ? Colors.blueAccent
                            : Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          teacherProvider.selectedSubClass,
                          style: TextStyle(
                            color: settings.isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                        const Text(" : "),
                        Text(
                          teacherProvider.selectedClass,
                          style: TextStyle(
                            color: settings.isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            showChangeClassDialog(
                              context,
                              teacherProvider,
                              settings,
                            );
                          },
                          child: Text(
                            "تغيير الصف",
                            style: TextStyle(
                              color: settings.isDarkMode
                                  ? Colors.blue
                                  : Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: titleController,
                      cursorColor: settings.isDarkMode
                          ? Colors.blueAccent
                          : Colors.blue,
                      decoration: InputDecoration(
                        labelText: 'عنوان الواجب',
                        filled: true,
                        focusColor: settings.isDarkMode
                            ? Colors.blueAccent
                            : Colors.blue,
                        hoverColor: settings.isDarkMode
                            ? const Color.fromARGB(125, 68, 137, 255)
                            : const Color.fromARGB(125, 33, 149, 243),
                        labelStyle: TextStyle(
                          color: settings.isDarkMode
                              ? const Color.fromARGB(255, 57, 128, 210)
                              : const Color.fromARGB(255, 29, 131, 215),
                        ),
                        fillColor: settings.isDarkMode
                            ? Colors.grey[800]
                            : Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 0.8,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 1.8,
                          ),
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'أدخل عنوان الواجب' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: messageController,
                      cursorColor: settings.isDarkMode
                          ? Colors.blueAccent
                          : Colors.blue,
                      decoration: InputDecoration(
                        labelText: 'محتوى الواجب',
                        filled: true,
                        hoverColor: settings.isDarkMode
                            ? const Color.fromARGB(125, 68, 137, 255)
                            : const Color.fromARGB(125, 33, 149, 243),
                        labelStyle: TextStyle(
                          color: settings.isDarkMode
                              ? const Color.fromARGB(255, 57, 128, 210)
                              : const Color.fromARGB(255, 29, 131, 215),
                        ),
                        fillColor: settings.isDarkMode
                            ? Colors.grey[800]
                            : Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 0.8,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 1.8,
                          ),
                        ),
                      ),
                      maxLines: 6,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'أدخل محتوى الواجب' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            dueDate == null
                                ? 'اختر تاريخ التسليم'
                                : 'تاريخ التسليم: ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}',
                            style: TextStyle(
                              color: settings.isDarkMode
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  dueDate ??
                                  DateTime.now().add(const Duration(days: 1)),
                              firstDate: DateTime.now().add(
                                const Duration(days: 1),
                              ),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData(
                                    useMaterial3: true,
                                    primarySwatch: Colors.blue,
                                    fontFamily: 'Arial',
                                    brightness: settings.isDarkMode
                                        ? Brightness.dark
                                        : Brightness.light,
                                    colorScheme: settings.isDarkMode
                                        ? const ColorScheme.dark(
                                            primary: Colors.blueAccent,
                                          )
                                        : const ColorScheme.light(
                                            primary: Colors.blue,
                                          ),
                                    scaffoldBackgroundColor: settings.isDarkMode
                                        ? Colors.grey[900]
                                        : Colors.grey[100],
                                    appBarTheme: AppBarTheme(
                                      backgroundColor: settings.isDarkMode
                                          ? Colors.grey[850]
                                          : Colors.blue[50],
                                      foregroundColor: settings.isDarkMode
                                          ? Colors.blue
                                          : Colors.blueAccent,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() => dueDate = picked);
                            }
                          },
                          child: Text(
                            'اختر التاريخ',
                            style: TextStyle(
                              color: settings.isDarkMode
                                  ? Colors.blueAccent
                                  : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        if (dueDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'اختر تاريخ التسليم',
                                style: TextStyle(
                                  color: settings.isDarkMode
                                      ? Colors.blueAccent
                                      : Colors.blue,
                                ),
                              ),
                            ),
                          );
                          return;
                        }
                        final hwId = teacherProvider.generateHomeworkId();
                        final hwData = {
                          'id': hwId,
                          'tag': 'الواجب',
                          'title': titleController.text,
                          'message': messageController.text,
                          'teacher': teacherProvider.teachername,
                          'subject': teacherProvider.subject,
                          'class': teacherProvider.selectedClass,
                          'subclass': teacherProvider.selectedSubClass,
                          'date':
                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          'due': dueDate,
                        };
                        teacherProvider.addHomework(hwData);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم إرسال الواجب إلى ${teacherProvider.selectedClass} : ${teacherProvider.selectedSubClass}',
                              style: TextStyle(
                                color: settings.isDarkMode
                                    ? Colors.blueAccent
                                    : Colors.blue,
                              ),
                            ),
                          ),
                        );

                        titleController.clear();
                        messageController.clear();
                        setState(() => dueDate = null);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: settings.isDarkMode
                            ? Colors.blueAccent
                            : Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'إرسال الواجب',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======= Show Change Class Dialog =======
void showChangeClassDialog(
  BuildContext context,
  TeacherProvider provider,
  SettingsProvider settings,
) {
  String tempSchool = provider.selectedSchool;
  String tempClass = provider.selectedClass;
  String tempSub = provider.selectedSubClass;

  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          final classes = provider.schools[tempSchool]?.keys.toList() ?? [];
          final subs = provider.schools[tempSchool]?[tempClass] ?? [];

          return AlertDialog(
            title: const Text("تغيير المدرسة / الصف / الشعبة"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: tempSchool,
                  isExpanded: true,
                  items: provider.schools.keys
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      tempSchool = val;
                      tempClass = provider.schools[val]?.keys.first ?? "";
                      tempSub = provider.schools[val]?[tempClass]?.first ?? "";
                      setStateDialog(() {});
                    }
                  },
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: tempClass,
                  isExpanded: true,
                  items: classes
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      tempClass = val;
                      tempSub = provider.schools[tempSchool]?[val]?.first ?? "";
                      setStateDialog(() {});
                    }
                  },
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: tempSub,
                  isExpanded: true,
                  items: subs
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      tempSub = val;
                      setStateDialog(() {});
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "إلغاء",
                  style: TextStyle(
                    color: settings.isDarkMode
                        ? Colors.blue
                        : Colors.blueAccent,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: settings.isDarkMode
                      ? Colors.blue
                      : Colors.blueAccent,
                ),
                onPressed: () {
                  provider.setSchool(tempSchool);
                  provider.setClass(tempClass);
                  provider.setSubClass(tempSub);
                  Navigator.pop(context);
                },
                child: const Text(
                  "تأكيد",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class TeacherAttendancePage extends StatelessWidget {
  const TeacherAttendancePage({super.key});
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Center(
      child: Text(
        "صفحة الحضور (تجريبية)",
        style: TextStyle(
          fontSize: 18,
          color: settings.isDarkMode ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }
}

class TeacherExamsPage extends StatelessWidget {
  const TeacherExamsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Center(
      child: Text(
        "صفحة الامتحانات (تجريبية)",
        style: TextStyle(
          fontSize: 18,
          color: settings.isDarkMode ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }
}

class TeacherSchedulePage extends StatelessWidget {
  const TeacherSchedulePage({super.key});
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Center(
      child: Text(
        "صفحة الجدول (تجريبية)",
        style: TextStyle(
          fontSize: 18,
          color: settings.isDarkMode ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }
}

class TeacherSettingsPage extends StatelessWidget {
  const TeacherSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const SettingsPage();
  }
}
