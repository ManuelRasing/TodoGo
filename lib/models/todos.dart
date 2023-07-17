import 'package:timezone/timezone.dart' as tz;

class Todos {
  String categoryName;
  String todos;
  tz.TZDateTime reminderTime;

  Todos(
      {required this.categoryName,
      required this.todos,
      required this.reminderTime});

  // static List myTodos = <dynamic>[
  //   Todos(false, "gusto ko tuma", 11, "02"),
  //   Todos(true, "gusto ko mag lato-lato", 11, "11"),
  //   Todos(false, "gusto ko kutusan si balong", 11, "08"),
  //   Todos(false, "bilan ako ni manuel ng iphone dwdqwdasd wqdasd", 11, "08"),
  //   Todos(false, "gusto ko tumae", 11, "02"),
  //   Todos(true, "gusto ko mag lato-lato", 11, "11"),
  //   Todos(false, "gusto ko kutusan si balong", 11, "08"),
  //   Todos(false, "bilan ako ni manuel ng iphone dwdqwdasd wqdasd", 11, "08"),
  //   Todos(false, "gusto ko tumae", 11, "02"),
  //   Todos(true, "gusto ko mag lato-lato", 11, "11"),
  //   Todos(false, "gusto ko kutusan si balong", 11, "08"),
  //   Todos(false, "bilan ako ni manuel ng iphone dwdqwdasd wqdasd", 11, "08"),
  //   Todos(false, "gusto ko kutusan si balong", 11, "08"),
  // ];
}
