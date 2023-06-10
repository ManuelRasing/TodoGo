import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/taskCategory.dart';


Future<String> fetchData() async {
  const url = 'https://api.api-ninjas.com/v1/quotes?category=happiness';
  const apiKey =
      '1+PpC2J6tJpucOHYp7z9LQ==cN31nKX8Si9qxA6j'; // Replace with your actual API key

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

void main() {
  // fetchData();
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

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
  late String timeOfTheDay;
  late String dayOrNight;
  Timer? _timer;

  final categoryList = <int>[1,2,3,4,5,6,7,8,9,10];
  
  @override

  
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd MMMM yyyy').format(dateNow);
    formattedTime = DateFormat('HH').format(dateNow);
    if (dateNow.hour >= 18){
        timeOfTheDay = 'Good Evening';
        dayOrNight = 'assets/images/cloudy.png';
    }else if(dateNow.hour >= 12){
        timeOfTheDay = 'Good Afternoon';
    }else if(dateNow.hour >= 01){
        timeOfTheDay = 'Good Morning';
        dayOrNight = 'assets/images/autumn.png';
    } 
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
            setState(() {
              dateNow = DateTime.now();
              formattedDate = DateFormat('dd MMM yyyy').format(dateNow);
              formattedTime = DateFormat('HH').format(dateNow);
            });
            if (dateNow.hour >= 18){
                timeOfTheDay = 'Good Evening';
                dayOrNight = 'assets/images/cloudy.png';
            }else if(dateNow.hour >= 12){
                timeOfTheDay = 'Good Afternoon';
            }else if(dateNow.hour >= 01){
                timeOfTheDay = 'Good Morning';
                dayOrNight = 'assets/images/autumn.png';
            } 
    });
    print(formattedTime);
    fetchData().then((response) {
      setState(() {
        quote = response;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
          getContainerSize();
          categoryHeight = containerSize?.height;
          catHeight = MediaQuery.of(context).size.height - categoryHeight!.toDouble();
          catHeight = catHeight - 245;
        });
      
    }).catchError((error) {
      setState(() {
        quote = 'Failed to fetch data';
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

  Widget build(BuildContext context) {
    List<TaskCategory> taskCategories = [
    TaskCategory('Personal', 'assets/images/personal.png'),
    TaskCategory('Health and Fitness', 'assets/images/Health.png'),
    TaskCategory('Educational', 'assets/images/academic.png'),
    TaskCategory('Work', 'assets/images/work.png'),
    TaskCategory('Home', 'assets/images/chores.png'),
    TaskCategory('Finance', 'assets/images/finance.png'),
    TaskCategory('Shopping', 'assets/images/shopping.png'),
    TaskCategory('Social', 'assets/images/social.png'),
    TaskCategory('Hobbies', 'assets/images/hobbies.png'),
    TaskCategory('Travel', 'assets/images/travel.png'),
    TaskCategory('Add', 'assets/images/add.png'),
  ];

  String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return text.substring(0, maxLength) + '...';
  }
}
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      backgroundColor: Color(0xffF5F3C1),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Apollo',
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF0EA293),
                      ),
                    ),
                    Text(
                      timeOfTheDay,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Apollo',
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF0EA293)),
                    ),
                    Text(
                      'Manuel',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Aylafs',
                          fontSize: 64,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF0EA293)),
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
            Container(
              key: containerKey,
              width: MediaQuery.of(context).size.width - 30,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
              decoration: BoxDecoration(
                  color: Color.fromARGB(131, 14, 162, 147),
                  border: Border.all(
                      color: Color.fromARGB(131, 14, 162, 147), width: 1.0),
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                '"\ $quote \"',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'PatrickHand',
                    color: Color(0xff270564)),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(25, 30, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Task Categories',
                style: TextStyle(
                    fontFamily: 'Anton',
                    color: Color(0xff0EA293),
                    fontSize: 20),
              ),
            ),
            Divider(
              color: Color(0xff0EA293),
              thickness: 1.0,
              indent: 25.0,
              endIndent: 25.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 25.0, right: 25.0), // Set the desired padding
              child: SingleChildScrollView(
                child: Container(
                  height: catHeight, // Set the desired height of the container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GridView.count(crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  children:
                   List.generate(taskCategories.length, (index) {
                      if(taskCategories[index].categoryTitle == 'Add'){
                        return Padding(padding: EdgeInsets.all(5),
                      child: InkWell(
                        onTap: () {
                          print(taskCategories[index].categoryTitle + ' tapped');
                        },
                        child: Container(
                                  padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                                  decoration: BoxDecoration(
                                      color: Color(0xff27E1C1),
                                      border: Border.all(
                                          color: Color(0xff27E1C1), width: 1.0),
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
                                            taskCategories[index].categoryIcon,
                                            height: 50,
                                            width: 50,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text(
                                                'Add \nCategory',
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
                      ),); 
                      } else{
                        return Padding(padding: EdgeInsets.all(5),
                      child: InkWell(
                        onTap: () {
                          print(taskCategories[index].categoryTitle + ' tapped');
                        },
                        child: Container(
                                  padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                                  decoration: BoxDecoration(
                                      color: Color(0xff27E1C1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 1,
                                          offset: const Offset(3, 3),
                                        )
                                      ],
                                      border: Border.all(
                                          color: Color(0xff27E1C1), width: 1.0),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(
                                            taskCategories[index].categoryIcon,
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
                                                truncateText(taskCategories[index].categoryTitle, 9),
                                                style: const TextStyle(
                                                  color: Color(0xff270564),
                                                  fontSize: 18,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text('Task',
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
                      }
                    })
                  ,
                  ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
