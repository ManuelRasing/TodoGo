import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/authFailure.dart';
import 'package:todo_app/auth/login.dart';
import 'package:todo_app/screens/home.dart';

class AuthRepository extends GetxController{
  static AuthRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());

    ever(firebaseUser, _setInitialscreen);
    super.onReady();
  }

  _setInitialscreen(User? user){
    user == null ? Get.offAll(const loginPage()): Get.offAll(const MyHomePage());
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(const MyHomePage()) : Get.offAll(const loginPage());
    }on FirebaseAuthException catch(e){
      final ex = AuthFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    }catch (_){
      const ex = AuthFailure();
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    }
  }
  
  Future<void> loginUserWithEmailAndPassword(String email, String password) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(const MyHomePage()) : Get.offAll(const loginPage());
    }on FirebaseAuthException catch(e){
      final ex = AuthFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    }catch (_){
      const ex = AuthFailure();
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<void> logout() async => await _auth.signOut();
}