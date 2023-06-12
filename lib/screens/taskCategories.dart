import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

class Category extends StatefulWidget {
  const Category({super.key});
  
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  DateTime dateNow = DateTime.now();

  // void initState(){

  // }
  
  @override
  Widget build(BuildContext context) {

  String  formattedMonth = DateFormat('MMM').format(dateNow);
  String  formattedDay = DateFormat('dd').format(dateNow);
  String  formattedYear = DateFormat('yyyy').format(dateNow);

  bool isDone = false;
  
    return Scaffold(
      backgroundColor: Color(0xffF5F3C1),
      body: Padding(
        padding: EdgeInsets.only(top: 70), 
        child: 
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                  color: Color(0xff0EA293),
                  borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: Column(
                    children: [
                      Text( 
                        formattedMonth,
                        style: const TextStyle(
                          fontFamily: "aAkhirTahun",
                          color: Color(0xffF5F3C1),
                          fontSize: 30
                        ),
                      ),
                      Text( formattedDay,
                        style: const TextStyle(
                          fontFamily: "aAkhirTahun",
                          color: Color(0xffF5F3C1),
                          fontSize: 60
                        ),
                      ),
                      Text( formattedYear,
                        style: const TextStyle(
                          fontFamily: "aAkhirTahun",
                          color: Color(0xffF5F3C1),
                          fontSize: 22
                        ),
                      ),
                    ],
                  ),
                ),
                Text('Personal Task',
                style: TextStyle(
                  fontFamily: 'Anton',
                  color: Color(0xff0EA293),
                  fontSize: 40
                ),)
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 664,
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.fromLTRB(15, 30, 15, 5),
              decoration: BoxDecoration(
                color: Color(0xff27E1C1),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(55), topRight: Radius.circular(55))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('ToDo List',
                  
                  style: TextStyle(
                    fontFamily: 'Aylafs',
                    fontSize: 40,
                    color: Color(0xff0EA293),
                  ),),
                  Container(
                    height: 592,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                        child: Container(
                          height: 592,
                          child: 
                            ListView.builder(
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width -30,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Color(0xff0EA293),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 700),
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF5F3C1),
                                      border: Border.all(
                                        color: Color(0xff270564),
                                        width: 3
                                      ),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                  ),
                                  Text('Something you want to do....',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    color: Color(0xffF5F3C1),
                                  ),)
                                ],
                            ),
                          );
                        })
                          ,
                        ),
                        ),
                    ),
                ]
                  
              ),
              ),
            
          ],
        ),
        ),
    );
  }
}