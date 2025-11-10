import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Student/studentprovider.dart';
import 'Teacher/teacherprovider.dart';
import 'Student/student.dart';
import 'Teacher/teacher.dart';
import 'secure_storage.dart';
import 'settingsprovider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'نظام الدخول',
            theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: settings.isDarkMode
                  ? Colors.grey[900]
                  : Colors.grey[100],
              fontFamily: 'Arial',
              brightness: settings.isDarkMode
                  ? Brightness.dark
                  : Brightness.light,
              inputDecorationTheme: InputDecorationTheme(
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
                    : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.blueAccent,
                    width: 0.8,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.8),
                ),
              ),
            ),
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isTeacher = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final idController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final id = idController.text.trim();
    final password = passwordController.text.trim();

    // 🔹 Fake accounts
    const fakeTeacherEmail = "rk@gmail.com";
    const fakeTeacherPass = "1234";

    const fakeStudentId = "0010001";
    const fakeStudentPass = "1234";

    bool valid = false;

    if (isTeacher && email == fakeTeacherEmail && password == fakeTeacherPass) {
      valid = true;
    } else if (!isTeacher &&
        id == fakeStudentId &&
        password == fakeStudentPass) {
      valid = true;
    }

    if (!valid) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('بيانات الدخول غير صحيحة')));
      return;
    }

    await SecureStorageService.saveCredentials(
      isTeacher: isTeacher,
      accountId: isTeacher ? null : id,
      email: isTeacher ? email : null,
      password: password,
    );

    if (!mounted) return;

    final teacherProvider = Provider.of<TeacherProvider>(context);
    teacherProvider.setEmail(email);

    if (isTeacher) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Teacher()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Student()),
      );
    }
  }

  void bypass() {
    if (!mounted) return;
    if (isTeacher) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Teacher()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Student()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
        centerTitle: true,
        backgroundColor: settings.isDarkMode ? Colors.blueAccent : Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Icon(
              Icons.school,
              color: settings.isDarkMode ? Colors.white70 : Colors.blue[700],
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'مرحبا بك في النظام',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: settings.isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 40),

            // 🔘 Toggle Student / Teacher
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: settings.isDarkMode ? Colors.blue : Colors.blueAccent,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
                color: settings.isDarkMode ? Colors.grey[800] : Colors.white,
              ),
              child: ToggleButtons(
                isSelected: [!isTeacher, isTeacher],
                onPressed: (index) {
                  setState(() => isTeacher = index == 1);
                },
                borderRadius: BorderRadius.circular(10),
                selectedColor: Colors.white,
                color: settings.isDarkMode ? Colors.white : Colors.blue,
                fillColor: settings.isDarkMode
                    ? Colors.blueAccent
                    : Colors.blue,
                renderBorder: false,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Text('طالب', style: TextStyle(fontSize: 16)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Text('معلم', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🧾 Login Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  if (isTeacher)
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: const Icon(Icons.email),
                        fillColor: settings.isDarkMode
                            ? Colors.grey[800]
                            : Colors.white,
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? 'أدخل البريد الإلكتروني'
                          : null,
                    )
                  else
                    TextFormField(
                      controller: idController,
                      decoration: InputDecoration(
                        labelText: 'رقم الحساب',
                        prefixIcon: const Icon(Icons.perm_identity),
                        fillColor: settings.isDarkMode
                            ? Colors.grey[800]
                            : Colors.white,
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'أدخل رقم الحساب' : null,
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock),
                      fillColor: settings.isDarkMode
                          ? Colors.grey[800]
                          : Colors.white,
                    ),
                    obscureText: true,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'أدخل كلمة المرور' : null,
                  ),
                  const SizedBox(height: 28),

                  // 🔹 Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: settings.isDarkMode
                            ? Colors.blueAccent
                            : Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ⏩ Bypass
                  TextButton(
                    onPressed: bypass,
                    child: Text(
                      'تخطي مؤقتاً',
                      style: TextStyle(
                        color: settings.isDarkMode
                            ? Colors.blueAccent
                            : Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
