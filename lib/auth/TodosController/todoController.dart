import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:todo_app/auth/TodosController/todoRepository.dart';
import 'package:todo_app/models/todos.dart';

import '../authRepository.dart';

class TodoController extends GetxController{
  static TodoController get instance => Get.find();

  final _authRepo = Get.put(AuthRepository());
  final _todoRepo = Get.put(TodoRepository());

  final _db = FirebaseFirestore.instance.collection('Users');

  Future<List<Todos>> getAllTodos(categoryName) async{
    final email = _authRepo.firebaseUser.value?.email;
    QuerySnapshot snapshot = await _db.where('Email', isEqualTo: email).get();
    String userID = snapshot.docs[0].id;
    print('TODO CONTROLLER : $categoryName \n$userID');
    return await _todoRepo.getAllTodos(userID, categoryName);
  }
}