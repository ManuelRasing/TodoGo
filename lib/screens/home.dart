import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_app/auth/authController.dart';
import 'package:todo_app/auth/authRepository.dart';
import 'package:todo_app/auth/taskCatController.dart';
import 'package:todo_app/notificationService.dart';
import 'package:todo_app/screens/addCategory.dart';
import 'dart:convert';

import '../main.dart';
import '../offline_database/database.dart';
import '../online_database/todogo_firebase.dart';

Future<String> fetchData() async {
  const url = 'https://api.api-ninjas.com/v1/quotes?category=happiness';
  const apiKey =
      '1+PpC2J6tJpucOHYp7z9LQ==cN31nKX8Si9qxA6j'; // Replace with your actual API key from https://api-ninjas.com/

  final response = await http.get(
    Uri.parse(url),
    headers: {'X-Api-Key': apiKey, 'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    var quote = responseData[0];
    // print(quote["quote"]);
    return quote["quote"];
  } else {
    // Error handling
    return 'You are currently offline. \nConnect to an internet to get happiness quotes.';
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controllers
  final taskController = Get.put(TaskCatController());
  final authController = Get.put(AuthController());
  NotifyTask tasknotification = NotifyTask();
  final _todoGoFirebase = Get.put(SyncAppFirebase());
// Hive
  final box = Hive.box('todogoBox');
  var fcmToken;

  String quote = '';
  final containerKey = GlobalKey();
  Size? containerSize;
  double? categoryHeight;
  double catHeight = 0.0;
  DateTime dateNow = DateTime.now();
  var formattedDate;
  var formattedTime;
  String timeOfTheDay = '';
  String dayOrNight = '';
  var todogo;
  String userName = "User";
  var categories = <TodoCategory>[];
  @override
  void initState() {
    todogo = box.get('todoGoUser');
    userName = todogo.username;
    for (var category in todogo.categories) {
      categories.add(category);
    }
    formattedDate = DateFormat('dd MMMM yyyy').format(dateNow);
    formattedTime = DateFormat('HH').format(dateNow);
    if (dateNow.hour >= 18 && dateNow.hour <= 24) {
      timeOfTheDay = 'Good Evening';
      dayOrNight = 'assets/images/cloudy.png';
    } else if (dateNow.hour >= 12 && dateNow.hour < 18) {
      timeOfTheDay = 'Good Afternoon';
      dayOrNight = 'assets/images/afternoon.png';
    } else if (dateNow.hour >= 01 && dateNow.hour < 12) {
      timeOfTheDay = 'Good Morning';
      dayOrNight = 'assets/images/autumn.png';
    }

    fetchData().then((response) {
      setState(() {
        quote = response;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getContainerSize();
        categoryHeight = containerSize?.height;
        catHeight =
            MediaQuery.of(context).size.height - categoryHeight!.toDouble();
        catHeight = catHeight - 247;
      });
    }).catchError((error) {
      quote = 'Failed to fetch data';
    });

    requestPermissionExactAlarm();
    getToken();
    super.initState();
  }

  requestPermissionExactAlarm() async {
    var exact_alarm = await Permission.scheduleExactAlarm.status;
    if (exact_alarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    } else if (exact_alarm.isPermanentlyDenied) {
      openAppSettings();
    } else if (exact_alarm.isGranted) {
      print("EXACT ALARM GRANTED");
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        fcmToken = value;
        print(fcmToken);
        saveToken(fcmToken, FirebaseAuth.instance.currentUser);
      });
    });
  }

  Future<void> saveToken(String token, User? user) async {
    final userID = await AuthRepository.instance.getUserID(user!.email);
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userID)
        .update({"fcmToken": token});
  }

  void getContainerSize() {
    final RenderBox? containerRenderBox =
        containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (containerRenderBox != null) {
      setState(() {
        containerSize = containerRenderBox.size;
      });
    }
  }

  @override
  void dispose() {
    categories.clear();
    super.dispose();
  }

  void showLoading(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            insetPadding: EdgeInsets.all(15),
            backgroundColor: Color(0x830EA293),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/loading.gif',
                  width: 80,
                  height: 80,
                ),
                const Text(
                  'Signing out,\nJust a moment....',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffF5F3C1)),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    String truncateText(String text, int maxLength) {
      if (text.length <= maxLength) {
        return text;
      } else {
        return '${text.substring(0, maxLength)}...';
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F3C1),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDate,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Apollo',
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF0EA293),
                          ),
                        ),
                        Text(
                          timeOfTheDay,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontFamily: 'Apollo',
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF0EA293)),
                        ),
                        Text(
                          userName,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontFamily: 'Aylafs',
                              fontSize: 64,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF0EA293),
                              shadows: [
                                Shadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.2),
                                    offset: const Offset(5, 5),
                                    blurRadius: 5),
                              ]),
                        )
                      ],
                    ),
                    Image.asset(
                      dayOrNight,
                      width: 173,
                      height: 141,
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                child: Tooltip(
                  message: 'Logout account',
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding: const EdgeInsets.all(0),
                          backgroundColor: const Color(0xffD9D7A9),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25)))),
                      onPressed: () async {
                        showLoading(context);
                        await _todoGoFirebase.syncDatabase(
                            FirebaseAuth.instance.currentUser!.email);
                        Navigator.of(context).pop();
                        authController.logout();
                        // AuthRepository.instance.logout();
                      },
                      child: Image.asset('assets/images/logout.png')),
                ),
              )
            ],
          ),
          Container(
            key: containerKey,
            width: MediaQuery.of(context).size.width - 30,
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
            decoration: BoxDecoration(
                color: const Color.fromARGB(131, 14, 162, 147),
                border: Border.all(
                    color: const Color.fromARGB(131, 14, 162, 147), width: 1.0),
                borderRadius: BorderRadius.circular(15)),
            child: Text(
              '" $quote "',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'PatrickHand',
                  color: Color(0xff270564)),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 30, 0, 0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Task Categories',
              style: TextStyle(
                  fontFamily: 'Anton', color: Color(0xff0EA293), fontSize: 20),
            ),
          ),
          const Divider(
            color: Color(0xff0EA293),
            thickness: 1.0,
            indent: 15.0,
            endIndent: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0), // Set the desired padding
            child: SingleChildScrollView(
              child: Container(
                height: catHeight, // Set the desired height of the container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    children: [
                      ...List.generate(categories.length, (index) {
                        String catIcon = 'assets/images/other_task.png';
                        switch (categories[index].name) {
                          case 'Personal':
                            catIcon = "assets/images/personal.png";
                            break;
                          case 'Health and Fitness':
                            catIcon = "assets/images/Health.png";
                            break;
                          case 'Educational':
                            catIcon = "assets/images/academic.png";
                            break;
                          case 'Work':
                            catIcon = "assets/images/work.png";
                            break;
                          case 'Home':
                            catIcon = "assets/images/chores.png";
                            break;
                          case 'Finance':
                            catIcon = "assets/images/finance.png";
                            break;
                          case 'Shopping':
                            catIcon = "assets/images/shopping.png";
                            break;
                          case 'Social':
                            catIcon = "assets/images/social.png";
                            break;
                          case 'Hobbies':
                            catIcon = "assets/images/hobbies.png";
                            break;
                          case 'Travel':
                            catIcon = "assets/images/travel.png";
                            break;
                          default:
                            catIcon;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(homepageToToDoPage(
                                      categories[index].name.toString()))
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            onLongPress: () {
                              _editDeleteCat(context, categories[index].name);
                              categories.clear();
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                              decoration: BoxDecoration(
                                  color: const Color(0xff27E1C1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 1,
                                      offset: const Offset(3, 3),
                                    )
                                  ],
                                  border: Border.all(
                                      color: const Color(0xff27E1C1),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // isLongPressed ? null : _editDeleteCat(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        catIcon,
                                        height: 50,
                                        width: 50,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            truncateText(
                                                categories[index].name, 7),
                                            style: const TextStyle(
                                              color: Color(0xff270564),
                                              fontSize: 18,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Text('Task',
                                              style: TextStyle(
                                                color: Color(0xff270564),
                                                fontSize: 18,
                                                fontFamily: 'Poppins',
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset(
                                          'assets/images/list.png',
                                          width: 25,
                                          height: 25,
                                        ),
                                        Text(
                                          '${categories[index].tasks.length} Task(s)',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              color: Color(0xff0EA293)),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () {
                            _showAddCategory(context);
                            categories.clear();
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                            decoration: BoxDecoration(
                                color: const Color(0xff27E1C1),
                                border: Border.all(
                                    color: const Color(0xff27E1C1), width: 1.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 1,
                                    offset: const Offset(3, 3),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  'assets/images/add.png',
                                  height: 50,
                                  width: 50,
                                ),
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Add New\nTask',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xff270564),
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCategory(BuildContext context) async {
    todogo = box.get('todoGoUser');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddCategory();
      },
    ).then((_) {
      setState(() {
        for (var category in todogo.categories) {
          categories.add(category);
        }
      });
    });
  }

  _editDeleteCat(BuildContext context, String categoryName) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditCategory(categoryName: categoryName);
      },
    ).then((_) {
      setState(() {
        setState(() {
          for (var category in todogo.categories) {
            categories.add(category);
          }
        });
      });
    });
  }
}
