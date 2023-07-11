import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/authRepository.dart';
import 'package:todo_app/auth/taskCatRepository.dart';
import 'package:todo_app/auth/userRepo.dart';
import 'package:todo_app/models/userModel.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final userRepo = Get.put(UserRepo());
  final taskCatRepo = Get.put(TaskCatRepo());

  createUser(UserModel user) async {
    await userRepo.createUser(user);
    Future.delayed(const Duration(milliseconds: 1500), () {
      registerUser(user.email, user.password);
    });
  }

  void registerUser(String email, String password) {
    AuthRepository.instance.createUserWithEmailAndPassword(email, password);
  }

  void loginUser(String email, String password) {
    AuthRepository.instance.loginUserWithEmailAndPassword(email, password);
  }
}
