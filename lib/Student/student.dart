import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'studentprovider.dart';
import 'attendance.dart';
import 'homework.dart';
import 'exams.dart';
import 'lecturetable.dart';
import 'settings.dart';
import '../settingsprovider.dart';

class Student extends StatelessWidget {
  const Student({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'نظام الطالب',
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
            home: const MainPage(),
          );
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final List<Widget> pages = [
      const HomePage(),
      const HomeworkPage(),
      const AttendancePage(),
      const ExamsPage(),
      const LectureTablePage(),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Consumer<StudentProvider>(
          builder: (context, provider, _) => AppBar(
            backgroundColor: Colors.transparent,
            elevation: 1,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.schoolName,
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${provider.studentClass} : ${provider.subClass}",
                  style: TextStyle(
                    color: settings.isDarkMode
                        ? Colors.white70
                        : Colors.black87,
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
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
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
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Map<String, dynamic>> filteredData;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<StudentProvider>(context, listen: false);
    filteredData = provider.fakeMessages;
  }

  void filterSearch(String query) {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    setState(() {
      filteredData = provider.filterMessages(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final mainState = context.findAncestorStateOfType<_MainPageState>();
    final settings = Provider.of<SettingsProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'ابحث في الرسائل...',
              prefixIcon: Icon(
                Icons.search,
                color: settings.isDarkMode ? Colors.blue : Colors.blueAccent,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: settings.isDarkMode ? Colors.blue : Colors.blueAccent,
                ),
              ),
              filled: true,
              fillColor: settings.isDarkMode ? Colors.grey[800] : Colors.white,
              hintStyle: TextStyle(
                color: settings.isDarkMode ? Colors.white60 : Colors.grey[600],
              ),
            ),
            onChanged: filterSearch,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredData.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد نتائج',
                      style: TextStyle(
                        fontSize: 16,
                        color: settings.isDarkMode
                            ? Colors.white70
                            : Colors.black54,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final data = filteredData[index];
                      final tagInfo = provider.tagDictionary[data['tag']]!;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CardButton(
                          teacher: data['teacher'],
                          subject: data['subject'],
                          title: data['title'],
                          date: data['date'],
                          tag: data['tag'],
                          subTag: data['subTag'],
                          message: data['message'],
                          details: data['details'],
                          color: tagInfo.color,
                          onTap: () {
                            if (mainState != null) {
                              if (data['tag'] == 'غياب') {
                                mainState.setState(
                                  () => mainState.currentIndex = 2,
                                );
                              } else if (data['tag'] == 'الواجب') {
                                mainState.setState(
                                  () => mainState.currentIndex = 1,
                                );
                              } else {
                                mainState.setState(
                                  () => mainState.currentIndex = 3,
                                );
                              }
                            }
                          },
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

class CardButton extends StatelessWidget {
  final String teacher;
  final String subject;
  final String title;
  final String date;
  final String tag;
  final String subTag;
  final String message;
  final String details;
  final Color color;
  final VoidCallback onTap;

  const CardButton({
    super.key,
    required this.teacher,
    required this.subject,
    required this.title,
    required this.date,
    required this.tag,
    required this.subTag,
    required this.message,
    required this.details,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: settings.isDarkMode ? Colors.grey[850] : Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: settings.isDarkMode
                    ? Colors.blue.withAlpha(20)
                    : Colors.blueAccent.withAlpha(20),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Text(
                '$teacher - $subject',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: settings.isDarkMode ? Colors.blue : Colors.blueAccent,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: color.withAlpha(40),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: color, width: 1.2),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            date,
                            style: TextStyle(
                              color: settings.isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: settings.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: settings.isDarkMode
                          ? Colors.white70
                          : Colors.black87,
                    ),
                  ),
                  if (subTag.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: subTag == 'نهائي'
                              ? Colors.redAccent.withAlpha(50)
                              : subTag == 'نصفي'
                              ? Colors.yellow.withAlpha(50)
                              : subTag == 'يومي'
                              ? Colors.green.withAlpha(50)
                              : settings.isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          subTag,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: subTag == 'نهائي'
                                ? Colors.redAccent
                                : subTag == 'نصفي'
                                ? Colors.orange[800]
                                : subTag == 'يومي'
                                ? Colors.green[800]
                                : settings.isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
