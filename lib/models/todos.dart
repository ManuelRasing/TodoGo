import 'package:cloud_firestore/cloud_firestore.dart';

class Todos {
  bool isDone;
  String doThis;
  String whatTimehr;
  String whatTimemin;
  String whatDay;
  String whatMonth;
  String whatYear;

  Todos({
    required this.isDone, 
    required this.doThis, 
    required this.whatTimehr, 
    required this.whatTimemin,
    required this.whatDay,
    required this.whatMonth,
    required this.whatYear
    });

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

  factory Todos.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc){
    return Todos(
      isDone: doc['isDone'], 
      doThis: doc['todo'], 
      whatTimehr: doc['whatTimehr'], 
      whatTimemin: doc['whatTimemin'],
      whatDay: doc['whatDay'],
      whatMonth: doc['whatMonth'],
      whatYear: doc['whatYear'],
      );
  }

}