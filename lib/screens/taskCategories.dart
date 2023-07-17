import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/addtask_widget.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import '../offline_database/database.dart';
import 'package:timezone/timezone.dart' as tz;

class Category extends StatefulWidget {
  final categoryName;
  const Category({super.key, required this.categoryName});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> with TickerProviderStateMixin {
  DateTime dateNow = DateTime.now();
  final box = Hive.box('todogoBox');
  var todogo;
  var category;
  var taskList = <Task>[];
  @override
  void initState() {
    todogo = box.get('todoGoUser');
    category = todogo.categories
        .firstWhere((category) => category.name == widget.categoryName);
    if (category != null) {
      for (var task in category.tasks) {
        taskList.add(Task(
            todos: task.todos,
            isDone: task.isDone,
            hour: task.hour,
            minute: task.minute,
            isAM: task.isAM,
            day: task.day,
            month: task.month,
            year: task.year));
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                              taskList.clear();
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
                            child: ListView.builder(
                                itemCount: taskList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.only(right: 15),
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff0EA293),
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              taskList[index].isDone =
                                                  !taskList[index].isDone;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 700),
                                            width: 40,
                                            height: 40,
                                            margin: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            decoration: BoxDecoration(
                                                color: const Color(0xffF5F3C1),
                                                border: Border.all(
                                                    color:
                                                        const Color(0xff270564),
                                                    width: 3),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: taskList[index].isDone
                                                ? const Icon(
                                                    Icons.check,
                                                    size: 30,
                                                    color: Color(0xff27E1C1),
                                                  )
                                                : null,
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              _showEditTask(
                                                  context,
                                                  taskList[index].todos,
                                                  taskList[index].hour,
                                                  taskList[index].minute,
                                                  taskList[index].isAM,
                                                  taskList[index].day,
                                                  taskList[index].month,
                                                  taskList[index].year,
                                                  taskList[index].isDone);
                                              taskList.clear();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  truncateText(
                                                      taskList[index].todos,
                                                      12),
                                                  style: TextStyle(
                                                    decoration: taskList[index]
                                                            .isDone
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none,
                                                    fontSize: 20,
                                                    fontFamily: 'Poppins',
                                                    color: Color(0xffF5F3C1),
                                                  ),
                                                ),
                                                Text(
                                                  // ignore: unnecessary_brace_in_string_interps
                                                  '${taskList[index].hour}:${taskList[index].minute}${taskList[index].isAM ? 'am' : 'pm'}',
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 19,
                                                      color: Color(0xff27E1C1)),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
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
    todogo = box.get('todoGoUser');
    category = todogo.categories
        .firstWhere((category) => category.name == widget.categoryName);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTask(categoryName: categoryName);
      },
    ).then((_) {
      setState(() {
        if (category != null) {
          for (var task in category.tasks) {
            taskList.add(Task(
                todos: task.todos,
                isDone: task.isDone,
                hour: task.hour,
                minute: task.minute,
                isAM: task.isAM,
                day: task.day,
                month: task.month,
                year: task.year));
          }
        }
      });
    });
  }

  void _showEditTask(BuildContext context, todoTask, hr, min, isAm, day, mon,
      year, isDone) async {
    todogo = box.get('todoGoUser');
    category = todogo.categories
        .firstWhere((category) => category.name == widget.categoryName);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return editTodo(
          categoryName: widget.categoryName,
          todos: todoTask,
          todoTask: todoTask,
          isDone: isDone,
          hr: hr,
          min: min,
          isAm: isAm,
          day: day,
          mon: mon,
          year: year,
        );
      },
    ).then((_) {
      setState(() {
        if (category != null) {
          for (var task in category.tasks) {
            taskList.add(Task(
                todos: task.todos,
                isDone: task.isDone,
                hour: task.hour,
                minute: task.minute,
                isAM: task.isAM,
                day: task.day,
                month: task.month,
                year: task.year));
          }
        }
      });
    });
  }
}
