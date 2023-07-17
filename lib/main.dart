import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/auth/authRepository.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/screens/taskCategories.dart';
import 'offline_database/database.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  Hive.registerAdapter<TodoCategory>(TodoCategoryAdapter());
  Hive.registerAdapter<TodoGo>(TodoGoAdapter());
  await Hive.openBox('todogoBox');
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthRepository()));
  initializeTimezone();
  runApp(const MyApp());
}

Future<void> initializeTimezone() async {
  final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(timeZone));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Todo Go',
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 500),
      home: CircularProgressIndicator(),
    );
  }
}

Route homepageToToDoPage(categoryName) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Category(
      categoryName: categoryName,
    ),
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: SlideTransition(
          position: animation.drive(tween),
          child: child,
        ),
      );
    },
  );
}
