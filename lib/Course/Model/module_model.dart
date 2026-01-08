import 'package:hive/hive.dart';
import 'package:interview/Course/Model/video_model.dart';
import 'package:interview/Course/Model/quiz_model.dart';

part 'module_model.g.dart';

@HiveType(typeId: 4)
class Module {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  List<Video> videos;

  @HiveField(3)
  List<Quiz> quizzes;

  Module({
    required this.id,
    required this.title,
    required this.videos,
    required this.quizzes,
  });
}
