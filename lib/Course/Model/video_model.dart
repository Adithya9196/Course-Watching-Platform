import 'package:hive/hive.dart';

part 'video_model.g.dart';

@HiveType(typeId: 2)
class Video extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String youtubeUrl;

  @HiveField(3)
  bool isCompleted;

  Video({
    required this.id,
    required this.title,
    required this.youtubeUrl,
    this.isCompleted = false,
  });
}
