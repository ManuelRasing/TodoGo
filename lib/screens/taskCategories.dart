import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/auth/TodosController/todoController.dart';
import 'package:todo_app/screens/addtask_widget.dart';

class Category extends StatefulWidget {
  final categoryName;
  const Category({super.key, required this.categoryName});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> with TickerProviderStateMixin {
  DateTime dateNow = DateTime.now();

  // void initState(){

  // }

  @override
  @override
  Widget build(BuildContext context) {
    final todoController = Get.put(TodoController());
    String formattedMonth = DateFormat('MMM').format(dateNow);
    String formattedDay = DateFormat('dd').format(dateNow);
    String formattedYear = DateFormat('yyyy').format(dateNow);

    String truncateText(String text, int maxLength) {
      if (text.length <= maxLength) {
        return text;
      } else {
        return '${text.substring(0, maxLength)}...';
      }
    }

    String cutStringIntoTwoLines(String input, int maxCharsPerLine) {
      final words = input.split(' ');
      final lines = <String>[];
      String currentLine = '';

      for (final word in words) {
        final testLine = '$currentLine $word'.trim();
        if (testLine.length <= maxCharsPerLine) {
          currentLine = testLine;
        } else {
          lines.add(currentLine);
          currentLine = word;
        }
      }

      lines.add(currentLine);
      return lines.join('\n');
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F3C1),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff0EA293),
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: Column(
                    children: [
                      Text(
                        formattedMonth,
                        style: const TextStyle(
                            fontFamily: "aAkhirTahun",
                            color: Color(0xffF5F3C1),
                            fontSize: 30),
                      ),
                      Text(
                        formattedDay,
                        style: const TextStyle(
                            fontFamily: "aAkhirTahun",
                            color: Color(0xffF5F3C1),
                            fontSize: 60),
                      ),
                      Text(
                        formattedYear,
                        style: const TextStyle(
                            fontFamily: "aAkhirTahun",
                            color: Color(0xffF5F3C1),
                            fontSize: 22),
                      ),
                    ],
                  ),
                ),
                Text(
                  cutStringIntoTwoLines(widget.categoryName, 15),
                  style: const TextStyle(
                      fontFamily: 'Anton',
                      color: Color(0xff0EA293),
                      fontSize: 40),
                )
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height * 0.75) - 2.5,
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              decoration: const BoxDecoration(
                  color: Color(0xff27E1C1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(55),
                      topRight: Radius.circular(55))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'ToDo List',
                          style: TextStyle(
                            fontFamily: 'Aylafs',
                            fontSize: 40,
                            color: Color(0xff0EA293),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 90, right: 30),
                          child: GestureDetector(
                            onTap: () {
                              _showAddTask(context, widget.categoryName);
                            },
                            child: Image.asset(
                              'assets/images/add_task.png',
                              width: 25,
                              height: 25,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.63,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.63,
                            child: FutureBuilder(
                                future: todoController
                                    .getAllTodos(widget.categoryName),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff0EA293),
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                              ),
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      todoController
                                                          .updateIsDone(
                                                              widget
                                                                  .categoryName,
                                                              snapshot
                                                                  .data![index]
                                                                  .todoId,
                                                              !snapshot
                                                                  .data![index]
                                                                  .isDone,
                                                              snapshot
                                                                  .data![index]
                                                                  .doThis)
                                                          .then((_) {
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: const Duration(
                                                          milliseconds: 700),
                                                      width: 40,
                                                      height: 40,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 20),
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xffF5F3C1),
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xff270564),
                                                              width: 3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: snapshot
                                                              .data![index]
                                                              .isDone
                                                          ? const Icon(
                                                              Icons.check,
                                                              size: 30,
                                                              color: Color(
                                                                  0xff27E1C1),
                                                            )
                                                          : null,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        _showEditTask(
                                                            context,
                                                            widget
                                                                .categoryName);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            truncateText(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .doThis,
                                                                20),
                                                            style: TextStyle(
                                                              decoration: snapshot
                                                                      .data![
                                                                          index]
                                                                      .isDone
                                                                  ? TextDecoration
                                                                      .lineThrough
                                                                  : TextDecoration
                                                                      .none,
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  'Poppins',
                                                              color: Color(
                                                                  0xffF5F3C1),
                                                            ),
                                                          ),
                                                          Text(
                                                            '${snapshot.data![index].whatTimehr}:${snapshot.data![index].whatTimemin}',
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 19,
                                                                color: Color(
                                                                    0xff27E1C1)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    } else if (snapshot.hasError) {
                                      return Text(
                                          '${snapshot.error.toString()} \nPlease try again later.');
                                    } else {
                                      return const Text(
                                          'Something went wrong. \nPlease try again later.');
                                    }
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                })),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTask(BuildContext context, categoryName) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTask(categoryName: categoryName);
      },
    );
  }

  void _showEditTask(BuildContext context, categoryName) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return editTodo();
      },
    );
  }
}
