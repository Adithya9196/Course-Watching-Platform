import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview/Authentication/Ui/LoginPage.dart';
import 'package:interview/Authentication/Model/_authModel.dart';
import 'package:interview/Authentication/Provider/_authprovider.dart';
import 'package:interview/Course/Provider/course_provider.dart';
import 'package:interview/Course/Model/module_model.dart';
import 'package:interview/Course/Model/quiz_model.dart';
import 'package:interview/Course/Model/video_model.dart';
import 'package:interview/Homepage/homepage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(VideoAdapter());
  Hive.registerAdapter(QuizAdapter());
  Hive.registerAdapter(ModuleAdapter());

  // Open Boxes
  await Hive.openBox<Student>("student");
  await Hive.openBox<Module>("modules");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isLoggedIn) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
