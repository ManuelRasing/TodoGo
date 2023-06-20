import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todos.dart';

class Category extends StatefulWidget {
  const Category({super.key});
  
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> with TickerProviderStateMixin{

  DateTime dateNow = DateTime.now();

  // void initState(){

  // }

  @override




  @override
  Widget build(BuildContext context) {

  String  formattedMonth = DateFormat('MMM').format(dateNow);
  String  formattedDay = DateFormat('dd').format(dateNow);
  String  formattedYear = DateFormat('yyyy').format(dateNow);

  String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}...';
  }
}
  
  
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
              decoration: const BoxDecoration(
                color: Color(0xff27E1C1),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(55), topRight: Radius.circular(55))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('ToDo List',
                      style: TextStyle(
                        fontFamily: 'Aylafs',
                        fontSize: 40,
                        color: Color(0xff0EA293),
                  ),),
                  Container(
                    margin: EdgeInsets.only(left: 90, right: 30),
                    child: Image.asset('assets/images/add_task.png',
                    width: 25,
                    height: 25,),
                  )
                    ],
                  ),
                  Container(
                    height: 592,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                        child: Container(
                          height: 592,
                          child: 
                            ListView.builder(
                          itemCount: Todos.myTodos.length,
                          itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.only(right: 15),
                            width: MediaQuery.of(context).size.width -30,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Color(0xff0EA293),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if(Todos.myTodos[index].isDone == true){
                                          setState(() {
                                            Todos.myTodos[index].isDone = false;
                                          });
                                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('na tap mo na bobo $isDone' )));
                                        }else{
                                          setState(() {
                                            Todos.myTodos[index].isDone = true;
                                          });
                                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('na tap mo na bobo $isDone' )));
                                        }
                                      
                                    },
                                    child: AnimatedContainer(
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
                                      child: 
                                      Todos.myTodos[index].isDone ? 
                                      Icon(
                                        Icons.check, 
                                        size: 30,
                                        color: Color(0xff27E1C1),)
                                        : null,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(truncateText(Todos.myTodos[index].doThis, 26),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    color: Color(0xffF5F3C1),
                                  ),),
                                  Text('${Todos.myTodos[index].whatTimehr}:${Todos.myTodos[index].whatTimemin}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 19,
                                    color: Color(0xff27E1C1)
                                  ), )
                                    ],
                                  ))
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