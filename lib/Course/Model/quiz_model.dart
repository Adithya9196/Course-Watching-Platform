import 'package:hive/hive.dart';

part 'quiz_model.g.dart';

@HiveType(typeId: 3)
class Quiz {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  // Add more fields for quiz questions, options, etc.

  Quiz({required this.id, required this.title});
}
