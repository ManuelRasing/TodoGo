import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/authRepository.dart';
import 'package:todo_app/auth/taskCatRepository.dart';
import 'package:todo_app/auth/userRepo.dart';
import 'package:todo_app/models/userModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../online_database/todogo_firebase.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final _todoGoFirebase = Get.put(SyncAppFirebase());
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final _authRepo = Get.put(AuthRepository());
  final userRepo = Get.put(UserRepo());
  final taskCatRepo = Get.put(TaskCatRepo());

  createUser(UserModel user, userName) async {
    await userRepo.createUser(user, userName);
    Future.delayed(const Duration(milliseconds: 1000), () {
      registerUser(user.email, user.password);
    });
  }

  void registerUser(String email, String password) {
    AuthRepository.instance.createUserWithEmailAndPassword(email, password);
  }

  void loginUser(String email, String password) {
    _authRepo.syncData(email);
    Future.delayed(Duration(milliseconds: 1000), () {
      AuthRepository.instance.loginUserWithEmailAndPassword(email, password);
    });
  }

  logout() async {
    await _todoGoFirebase
        .syncDatabase(FirebaseAuth.instance.currentUser!.email);
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return _authRepo.logout();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return _authRepo.logout();
    } else {
      return Get.snackbar(
          'You are offline.', 'Please connect to an internet and try again.',
          snackPosition: SnackPosition.TOP,
          icon: Image.asset(
            'assets/images/noInternet.gif',
            height: 50,
            width: 50,
          ),
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
          duration: Duration(seconds: 5),
          borderRadius: 10,
          colorText: Color(0xffF5F3C1),
          backgroundColor: Color(0x830EA293));
    }
  }
}
