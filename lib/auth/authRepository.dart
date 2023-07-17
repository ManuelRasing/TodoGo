import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/auth/authFailure.dart';
import 'package:todo_app/auth/login.dart';
import 'package:todo_app/offline_database/database.dart';
import 'package:todo_app/online_database/todogo_firebase.dart';
import 'package:todo_app/screens/home.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  final box = Hive.box('todogoBox');

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());

    ever(firebaseUser, _setInitialscreen);
    super.onReady();
  }

  syncshit(email) async {
    Get.snackbar('Syncing data', 'Please wait.',
        snackPosition: SnackPosition.TOP);
    final _todoGoFirebase = Get.put(SyncAppFirebase());
    _todoGoFirebase.syncDatabase(email);
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  }

  _setInitialscreen(User? user) {
    if (user == null) {
      Get.offAll(const loginPage());
    } else {
      Get.offAll(const MyHomePage());
      syncshit(user.email);
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(const MyHomePage())
          : Get.offAll(const loginPage());
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

  syncData(email) async {
    final userID = await getUserID(email);
    final snapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();
    final categoryRef = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .collection('TaskCategories')
        .get();
    var categories = <TodoCategory>[];

    categoryRef.docs.forEach((categoryDoc) {
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
            );
          }).toList();
        }

        categories.add(TodoCategory(name: categoryDoc.id, tasks: taskList));
      });
    });

    await Future.wait(categoryRef.docs
        .map((categoryDoc) => categoryDoc.reference.collection('Todos').get()));

    final _todoGo =
        TodoGo(username: snapshot.data()!['Username'], categories: categories);
    box.put('todoGoUser', _todoGo);

    print('Sync data completed');
  }

  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (firebaseUser.value != null) {
        Get.offAll(const MyHomePage());
      } else {
        Get.offAll(const loginPage());
      }
    } on FirebaseAuthException catch (e) {
      final ex = AuthFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      Get.snackbar(ex.message, 'Check your email/password and try again',
          snackPosition: SnackPosition.TOP);
      throw ex;
    } catch (_) {
      const ex = AuthFailure();
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      Get.snackbar(ex.message, 'Check your email/password and try again',
          snackPosition: SnackPosition.TOP);
      throw ex;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await box.clear();
  }
}
