import 'package:hive/hive.dart';
part '_authModel.g.dart';

@HiveType(typeId: 1)
class Student{

  @HiveField(0)
  String studentId;

  @HiveField(1)
  String name;

  @HiveField(2)
  String password;

  Student({
    required this.studentId,
    required this.name,
    required this.password,
  });


}