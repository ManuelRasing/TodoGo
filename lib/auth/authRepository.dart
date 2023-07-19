import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/auth/authFailure.dart';
import 'package:todo_app/auth/login.dart';
import 'package:todo_app/offline_database/database.dart';
import 'package:todo_app/online_database/todogo_firebase.dart';
import 'package:todo_app/screens/home.dart';

import '../notificationService.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  final box = Hive.box('todogoBox');

  NotifyTask notifyTask = NotifyTask();
  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());

    ever(firebaseUser, _setInitialscreen);
    super.onReady();
  }

  syncshit(email) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      Get.snackbar(
          'Syncing data', 'Please wait and don\'t turn off your internet.',
          snackPosition: SnackPosition.TOP,
          icon: Image.asset(
            'assets/images/loading.gif',
            height: 50,
            width: 50,
          ),
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
          duration: Duration(seconds: 10),
          borderRadius: 10,
          colorText: Color(0xffF5F3C1),
          backgroundColor: Color(0x830EA293));
      final _todoGoFirebase = Get.put(SyncAppFirebase());
      _todoGoFirebase.syncDatabase(email);
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      Get.snackbar(
          'Syncing data', 'Please wait and don\'t turn off your internet.',
          snackPosition: SnackPosition.TOP,
          icon: Image.asset(
            'assets/images/loading.gif',
            height: 50,
            width: 50,
          ),
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
          duration: Duration(seconds: 10),
          borderRadius: 10,
          colorText: Color(0xffF5F3C1),
          backgroundColor: Color(0x830EA293));
      final _todoGoFirebase = Get.put(SyncAppFirebase());
      _todoGoFirebase.syncDatabase(email);
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
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

  _setInitialscreen(User? user) {
    if (user == null) {
      Get.offAll(() => const loginPage());
    } else {
      Get.offAll(() => const MyHomePage());
      notifyTask.initFirebaseMessaging();
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => const MyHomePage())
          : Get.offAll(() => const loginPage());
    } on FirebaseAuthException catch (e) {
      final ex = AuthFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      Get.snackbar(ex.message, 'Please try again',
          snackPosition: SnackPosition.BOTTOM);
      throw ex;
    } catch (_) {
      const ex = AuthFailure();
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      Get.snackbar(ex.message, 'Please try again',
          snackPosition: SnackPosition.BOTTOM);
      throw ex;
    }
  }

  Future<String> getUserID(email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get();
    String userID = snapshot.docs[0].id;
    return userID;
  }

  Future<void> syncData(email) async {
    final userID = await getUserID(email);
    final snapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();
    final categoryRef = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .collection('TaskCategories')
        .get();
    var categories = <TodoCategory>[];

    await Future.delayed(Duration(seconds: 10));

    for (var categoryDoc in categoryRef.docs) {
      var taskList = <Task>[];
      categoryDoc.reference.collection('Todos').get().then((todosSnapshot) {
        if (todosSnapshot.docs.isNotEmpty) {
          taskList = todosSnapshot.docs.map((todoDoc) {
            return Task(
              todos: todoDoc.get('todos'),
              isDone: todoDoc.get('isDone'),
              hour: todoDoc.get('hour'),
              minute: todoDoc.get('minute'),
              isAM: todoDoc.get('isAM'),
              day: todoDoc.get('day'),
              month: todoDoc.get('month'),
              year: todoDoc.get('year'),
              todoID: todoDoc.get('todoID'),
            );
          }).toList();
        }

        categories.add(TodoCategory(name: categoryDoc.id, tasks: taskList));
      });
    }

    await Future.wait(categoryRef.docs
        .map((categoryDoc) => categoryDoc.reference.collection('Todos').get()));

    final _todoGo =
        TodoGo(username: snapshot.data()!['Username'], categories: categories);
    box.put('todoGoUser', _todoGo);
  }

  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (firebaseUser.value != null) {
        Get.offAll(() => const MyHomePage());
      } else {
        Get.offAll(() => const loginPage());
      }
    } on FirebaseAuthException catch (e) {
      final ex = AuthFailure.code(e.code);
      Get.snackbar(ex.message, 'Check your email/password and try again',
          snackPosition: SnackPosition.TOP, duration: Duration(seconds: 4));
      throw ex;
    } catch (_) {
      const ex = AuthFailure();
      Get.snackbar(ex.message, 'Check your email/password and try again',
          snackPosition: SnackPosition.TOP, duration: Duration(seconds: 4));
      throw ex;
    }
  }

  Future<void> logout() async {
    await box.clear();
    await _auth.signOut();
  }
}
