import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:interview/Course/Model/module_model.dart';
import 'package:interview/Course/Model/video_model.dart';
import 'package:interview/Course/Model/quiz_model.dart';

class CourseProvider with ChangeNotifier {
  final Box<Module> _moduleBox = Hive.box<Module>("modules");

  List<Module> get modules => _moduleBox.values.toList();

  CourseProvider() {
    if (_moduleBox.isEmpty) {
      _populateSampleData();
    }
  }

  Future<void> markVideoAsCompleted(String moduleId, String videoId) async {
    final module = _moduleBox.get(moduleId);
    if (module != null) {
      final videoIndex = module.videos.indexWhere((v) => v.id == videoId);
      if (videoIndex != -1) {
        module.videos[videoIndex].isCompleted = true;
        await _moduleBox.put(moduleId, module);
        notifyListeners();
      }
    }
  }

  void _populateSampleData() {
    final module1 = Module(
      id: '1',
      title: 'Module 1: Introduction to Flutter',
      videos: [
        Video(id: 'v1', title: 'What is Flutter?', youtubeUrl: 'https://www.youtube.com/watch?v=I9ceqw5Ny-4'),
        Video(id: 'v2', title: 'Setting up Flutter', youtubeUrl: 'https://www.youtube.com/watch?v=CD1Y2DmL5JM'),
      ],
      quizzes: [
        Quiz(id: 'q1', title: 'Quiz 1'),
      ],
    );

    final module2 = Module(
      id: '2',
      title: 'Module 2: Flutter Widgets',
      videos: [
        Video(id: 'v3', title: 'Stateless Widgets', youtubeUrl: 'https://www.youtube.com/watch?v=wE7khGHVkYY'),
        Video(id: 'v4', title: 'Stateful Widgets', youtubeUrl: 'https://www.youtube.com/watch?v=AqCMFXEmf3w')
      ],
      quizzes: [
        Quiz(id: 'q2', title: 'Quiz 2'),
        Quiz(id: 'q3', title: 'Quiz 3'),
      ],
    );

    final module3 = Module(
      id: '3',
      title: 'Module 3: State Management Basics',
      videos: [
        Video(id: 'v5', title: 'Introduction to State', youtubeUrl: 'https://www.youtube.com/watch?v=QlwiL_yLh6E'),
        Video(id: 'v6', title: 'Provider Basics', youtubeUrl: 'https://www.youtube.com/watch?v=vFxk_KJCqgk')
      ],
      quizzes: [
        Quiz(id: 'q4', title: 'Quiz 4'),
      ],
    );

    _moduleBox.put(module1.id, module1);
    _moduleBox.put(module2.id, module2);
    _moduleBox.put(module3.id, module3);
  }
}
