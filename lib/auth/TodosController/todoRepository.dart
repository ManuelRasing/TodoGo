
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/todos.dart';

class TodoRepository extends GetxController{
  static TodoRepository get instance => Get.find();

  final _userDb = FirebaseFirestore.instance.collection('Users');

  Future<List<Todos>> getAllTodos(userID, String categoryName) async{
    final snapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(userID)
      .collection('TaskCategories')
      .doc(categoryName)
      .collection('Todos')
      .get();

  final userTodos = snapshot.docs.map((e) => Todos.fromSnapshot(e)).toList();
  print('TODO REPOSITORY : $userID \n$categoryName');
  return userTodos;
  }
}