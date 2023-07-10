import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/auth/authRepository.dart';
import 'package:todo_app/auth/taskCatController.dart';
import 'package:todo_app/auth/userController.dart';
import 'package:todo_app/models/userModel.dart';
import 'package:todo_app/screens/addCategory.dart';
import 'dart:convert';

import '../main.dart';


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
    return 'Request failed with status: ${response.statusCode}';
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
  
  final categoryList = <int>[1,2,3,4,5,6,7,8,9,10];

  
  @override

  
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd MMMM yyyy').format(dateNow);
    formattedTime = DateFormat('HH').format(dateNow);
    if (dateNow.hour >= 18 && dateNow.hour <= 24){
        timeOfTheDay = 'Good Evening';
        dayOrNight = 'assets/images/cloudy.png';
    }else if(dateNow.hour >= 12 && dateNow.hour < 18){
        timeOfTheDay = 'Good Afternoon';
        dayOrNight = 'assets/images/afternoon.png';
    }else if(dateNow.hour >= 01 && dateNow.hour < 12){
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
          catHeight = MediaQuery.of(context).size.height - categoryHeight!.toDouble();
          catHeight = catHeight - 247;
        });
      
    }).catchError((error) {
      setState(() {
        quote = 'Failed to fetch data';
      });
    });
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
  Widget build(BuildContext context) {
    
  final controller = Get.put(UserController());
  final taskController = Get.put(TaskCatController());

  String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}...';
  }
}
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    
    return Scaffold(
      backgroundColor: const Color(0xffF5F3C1),
      body: Column(
          children: [
            Stack(
              children: 
                [
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
                          FutureBuilder(
                            future: controller.getUserData(),
                            builder: (context, snapshot) {
                              if(snapshot.connectionState == ConnectionState.done){
                                if(snapshot.hasData){
                                  UserModel userData = snapshot.data as UserModel;
                                  return Text(
                                    userData.username,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontFamily: 'Aylafs',
                                        fontSize: 64,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF0EA293)),
                                  );
                                }else if(snapshot.hasError){
                                  return Text(snapshot.error.toString());
                                }else{
                                  return const Text('Something went wrong');
                                }
                                
                             }else{
                                return const CircularProgressIndicator();
                                
                              }
                              }
                              
                              
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      padding: const EdgeInsets.all(0),
                      backgroundColor: const Color(0xffD9D7A9),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
                      )
                    ),
                    onLongPress: () {
                      const Tooltip(
                        message: 'Logout account',
                      );
                    },
                    onPressed: (){
                      AuthRepository.instance.logout();
                    }, 
                    child: Image.asset('assets/images/logout.png')),
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
                    fontFamily: 'Anton',
                    color: Color(0xff0EA293),
                    fontSize: 20),
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
                  child: FutureBuilder(
                    future: taskController.getAllCategory(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                        if(snapshot.hasData){
                          return GridView.count(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    children:[
                                    ... List.generate(snapshot.data!.length, (index) {
                                          String catIcon ='assets/images/other_task.png';
                                          switch (snapshot.data![index].categoryTitle) {
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
                                          return Padding(padding: const EdgeInsets.all(5),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(homepageToToDoPage(snapshot.data![index].categoryTitle.toString()));
                                          },
                                          onLongPress: () {
                                            _editDeleteCat(context, snapshot.data![index].categoryTitle);
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
                                                            color: const Color(0xff27E1C1), width: 1.0),
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
                                                                  truncateText(snapshot.data![index].categoryTitle, 7),
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
                                                              const Text(
                                                                '20 Tasks',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Inter',
                                                                    color: Color(0xff0EA293)),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),),
                                        ),);
                                      }),
                                      Padding(padding: const EdgeInsets.all(5),
                                        child: InkWell(
                                          onTap: () {
                                            _showAddCategory(context);
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
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Image.asset(
                                                              'assets/images/add.png',
                                                              height: 50,
                                                              width: 50,
                                                            ),
                                                            const Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
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
                                                    ),),
                                        ),)
                                    ]
          );
                        }else if(snapshot.hasError){
                          return Text('${snapshot.error.toString()} \nPlease try again later.');
                        }else{
                          return const Text('Something went wrong.\nPlease try again later.');
                        }
                      }else{
                        return const CircularProgressIndicator.adaptive();
                      }
                    }
                  ),
                  ),
              ),
            ),
          ],
        ),
      
    );
  }
    void _showAddCategory(BuildContext context) async {
     await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddCategory();
      },
    );
  }
    
    
    _editDeleteCat(BuildContext context, String categoryName ) async{
    await showDialog(
      context: context,
      builder: (BuildContext context) { 
        return EditCategory(categoryName: categoryName);
        } ,
    ).then((value) {
      setState(() {
      });
    });

  }
}
