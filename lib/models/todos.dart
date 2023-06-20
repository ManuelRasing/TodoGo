class Todos {
  bool isDone;
  String doThis;
  int whatTimehr;
  String whatTimemin;

  Todos(this.isDone, this.doThis, this.whatTimehr, this.whatTimemin);

  static List myTodos = <dynamic>[
    Todos(false, "gusto ko tumae", 11, "02"),
    Todos(true, "gusto ko mag lato-lato", 11, "11"),
    Todos(false, "gusto ko kutusan si balong", 11, "08"),
    Todos(false, "bilan ako ni manuel ng iphone dwdqwdasd wqdasd", 11, "08"),
  ];

}