import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  runApp(const MyApp());
  fetchData();
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
  double catHeight = 10.0;

  @override
  void initState() {
    super.initState();
    fetchData().then((response) {
      setState(() {
        quote = response;
      });
      Timer(const Duration(seconds: 2), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          getContainerSize();
          catHeight = 500.0;
          categoryHeight = containerSize?.height;
          print(catHeight);
          catHeight = catHeight - categoryHeight!.toDouble();
          print(catHeight);
          catHeight = MediaQuery.of(context).size.height - catHeight;
          print(catHeight);
        });
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

  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

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
                  children: const [
                    Text(
                      '08 June 2023',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Apollo',
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF0EA293),
                      ),
                    ),
                    Text(
                      'Good Morning',
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
                  'assets/images/autumn.png',
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
                quote,
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
                  child: ListView.builder(
                    itemCount:
                        10, // Set the number of items in the scrollable list
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 160,
                                height: 130,
                                padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
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
                                          'assets/images/personal.png',
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
                                              'Personal',
                                              style: TextStyle(
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
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text(
                                            '20 Tasks',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Inter',
                                                color: Color(0xff0EA293)),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                            Container(
                                width: 160,
                                height: 130,
                                padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
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
                                          'assets/images/personal.png',
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
                                              'Personal',
                                              style: TextStyle(
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
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text(
                                            '20 Tasks',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Inter',
                                                color: Color(0xff0EA293)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      );
                    },
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
