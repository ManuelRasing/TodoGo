import 'package:hive/hive.dart';

part 'database.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  Task(
      {required this.todos,
      required this.isDone,
      required this.hour,
      required this.minute,
      required this.isAM,
      required this.day,
      required this.month,
      required this.year,
      required this.todoID});
  @HiveField(0)
  String todos;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  String hour;

  @HiveField(3)
  bool isAM;

  @HiveField(4)
  String minute;

  @HiveField(5)
  String day;

  @HiveField(6)
  String month;

  @HiveField(7)
  String year;

  @HiveField(8)
  int todoID;
}

@HiveType(typeId: 1)
class TodoCategory extends HiveObject {
  TodoCategory({required this.name, required this.tasks});
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Task> tasks;
}

@HiveType(typeId: 2)
class TodoGo extends HiveObject {
  TodoGo({required this.username, required this.categories});

  @HiveField(0)
  String username;

  @HiveField(1)
  List<TodoCategory> categories;
}
