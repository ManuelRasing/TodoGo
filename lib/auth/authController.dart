import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/authRepository.dart';
import 'package:todo_app/auth/taskCatRepository.dart';
import 'package:todo_app/auth/userRepo.dart';
import 'package:todo_app/models/userModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final _authRepo = Get.put(AuthRepository());
  final userRepo = Get.put(UserRepo());
  final taskCatRepo = Get.put(TaskCatRepo());

  createUser(UserModel user, userName) async {
    await userRepo.createUser(user, userName);
    Future.delayed(const Duration(milliseconds: 3000), () {
      registerUser(user.email, user.password);
    });
  }

  void registerUser(String email, String password) {
    AuthRepository.instance.createUserWithEmailAndPassword(email, password);
  }

  void loginUser(String email, String password) {
    _authRepo.syncData(email);
    Future.delayed(Duration(milliseconds: 2000), () {
      AuthRepository.instance.loginUserWithEmailAndPassword(email, password);
    });
  }

  logout() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return _authRepo.logout();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return _authRepo.logout();
    } else {
      return Get.snackbar(
          'You are offline.', 'Please connect to an internet and try again.',
          snackPosition: SnackPosition.TOP);
    }
  }
}
