import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/auth/TodosController/todoController.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class AddTask extends StatefulWidget {
  final categoryName;
  const AddTask({Key? key, required this.categoryName}) : super(key: key);
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final todoController = Get.put(TodoController());
  DateTime dateNow = DateTime.now();

  bool _timeOfDay = true;

  int daysInMonth = 0;
  final List<String> _taskhr = [];
  final List<String> _taskmin = [];
  final List<String> _taskmon = [];
  final List<String> _taskday = [];
  final List<String> _taskyear = [];

  var _amPm = 0;
  @override
  void initState() {
    daysInMonth = DateTime(dateNow.year, dateNow.month + 1, 0).day;
    if (int.parse(DateFormat('HH').format(dateNow)) > 12) {
      _amPm = 1;
      setState(() {
        _timeOfDay = false;
      });
    }
    // Year
    for (int i = dateNow.year; i <= dateNow.year + 10; i++) {
      _taskyear.add(DateFormat('yyyy').format(DateTime(i)));
    }
    // Days
    for (int i = 0; i <= daysInMonth; i++) {
      if (i < 10) {
        _taskday.add('0$i');
      } else {
        _taskday.add('$i');
      }
    }
    // Month
    for (int i = dateNow.year; i <= daysInMonth + 10; i++) {}
    for (int i = 1; i <= 12; i++) {
      if (i < 10) {
        _taskmon.add(DateFormat('MMM').format(DateTime(0, i)));
      } else {
        _taskmon.add(DateFormat('MMM').format(DateTime(0, i)));
      }
    }
    // Hour
    for (int i = 1; i <= 12; i++) {
      if (i < 10) {
        _taskhr.add('0$i');
      } else {
        _taskhr.add('$i');
      }
    }
    // Min
    for (int i = 0; i <= 60; i++) {
      if (i < 10) {
        _taskmin.add('0$i');
      } else {
        _taskmin.add('$i');
      }
    }
    todoController.doThisController.addListener((isEmpty));
    var advanceMin = int.parse(dateNow.minute.toString()) + 5;
    todoController.hrController.text =
        DateFormat('hh').format(dateNow).toString();
    todoController.minController.text = advanceMin.toString();
    todoController.dayController.text = dateNow.day.toString();
    todoController.monController.text = dateNow.month.toString();
    todoController.yearController.text = dateNow.year.toString();
    super.initState();
  }

  @override
  void dispose() {
    todoController.doThisController.dispose();
    todoController.hrController.dispose();
    todoController.minController.dispose();
    todoController.dayController.dispose();
    todoController.monController.dispose();
    todoController.yearController.dispose();
    super.dispose();
  }

  bool _isEmpty = true;

  isEmpty() {
    if (todoController.doThisController.isBlank!) {
      setState(() {
        _isEmpty = true;
      });
    } else {
      setState(() {
        _isEmpty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(15),
      backgroundColor: const Color(0xffF5F3C1),
      content: Container(
        // width: MediaQuery.of(context).size.width - 100,
        height: 300,
        decoration: const BoxDecoration(
          color: Color(0xffF5F3C1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "ADD TASK",
                  style: TextStyle(
                      fontFamily: "aAkhirTahun",
                      fontSize: 25,
                      color: Color(0xff270564)),
                ),
                GestureDetector(
                  onTap: () {
                    if (_isEmpty) {
                      Get.snackbar(
                          'Error', 'Write something you want todo first.',
                          snackPosition: SnackPosition.TOP);
                    } else {
                      _saveTodo(
                          widget.categoryName,
                          todoController.doThisController.text.trim(),
                          todoController.hrController.text.trim(),
                          todoController.minController.text.trim(),
                          _timeOfDay,
                          todoController.dayController.text.trim(),
                          todoController.monController.text.trim(),
                          todoController.yearController.text.trim());
                      todoController.doThisController.clear();
                      todoController.hrController.clear();
                      todoController.minController.clear();
                      todoController.dayController.clear();
                      todoController.monController.clear();
                      todoController.yearController.clear();

                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width - 323),
                    child: Image.asset(
                      'assets/images/save.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Image.asset(
                      'assets/images/cancel.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              child: TextField(
                maxLines: 5,
                cursorColor: const Color(0xff270564),
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: Color(0xff270564)),
                controller: todoController.doThisController,
                decoration: const InputDecoration(
                    hintText: "Something you want to do..",
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      color: Color.fromARGB(123, 38, 5, 100),
                    ),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xffD9D7A9)),
              ),
            ),
            const Text(
              'Time and Date',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff270564)),
            ),
            Container(
              color: const Color(0xffD9D7A9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Time
                  SizedBox(
                    child: Row(
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 50) / 10,
                          height: 40,
                          child: WheelChooser(
                            onValueChanged: (hr) {
                              setState(() {
                                todoController.hrController.text = hr;
                              });
                            },
                            startPosition:
                                int.parse(DateFormat('hh').format(dateNow)) - 1,
                            datas: _taskhr,
                            listHeight: 15,
                            unSelectTextStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color.fromARGB(123, 38, 5, 100),
                            ),
                            selectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xff270564)),
                          ),
                        ),
                        const Text(
                          ":",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff270564)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 11,
                          height: 40,
                          child: WheelChooser(
                            onValueChanged: (min) {
                              setState(() {
                                todoController.minController.text = min;
                              });
                            },
                            startPosition:
                                int.parse(DateFormat('mm').format(dateNow)) + 5,
                            datas: _taskmin,
                            listHeight: 15,
                            unSelectTextStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color.fromARGB(123, 38, 5, 100),
                            ),
                            selectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xff270564)),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 12,
                          height: 40,
                          child: WheelChooser(
                            onValueChanged: (amPm) {
                              if (amPm == 'AM') {
                                setState(() {
                                  _timeOfDay = true;
                                });
                              } else {
                                setState(() {
                                  _timeOfDay = false;
                                });
                              }
                            },
                            startPosition: _amPm,
                            datas: const ['AM', 'PM'],
                            listHeight: 15,
                            unSelectTextStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color.fromARGB(123, 38, 5, 100),
                            ),
                            selectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xff270564)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Text(
                    "|",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 30,
                        color: Color(0x7D260564)),
                  ),

                  //Date

                  SizedBox(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 9,
                          height: 40,
                          child: WheelChooser(
                            onValueChanged: (mon) {
                              setState(() {
                                todoController.monController.text = mon;
                              });
                            },
                            startPosition: dateNow.month - 1,
                            datas: _taskmon, //also has a length of 12
                            listHeight: 15,
                            unSelectTextStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color.fromARGB(123, 38, 5, 100),
                            ),
                            selectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xff270564)),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 12,
                          height: 40,
                          child: WheelChooser(
                            onValueChanged: (day) {
                              setState(() {
                                todoController.dayController.text = day;
                              });
                            },
                            startPosition: dateNow.day,
                            datas: _taskday,
                            listHeight: 15,
                            unSelectTextStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color.fromARGB(123, 38, 5, 100),
                            ),
                            selectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xff270564)),
                          ),
                        ),
                        const Text(
                          ",",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 20,
                              color: Color(0xff270564)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 7,
                          height: 40,
                          child: WheelChooser(
                            onValueChanged: (year) {
                              setState(() {
                                todoController.yearController.text = year;
                              });
                            },
                            datas: _taskyear,
                            listHeight: 15,
                            unSelectTextStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color.fromARGB(123, 38, 5, 100),
                            ),
                            selectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xff270564)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _saveTodo(categoryName, doThis, hr, min, amPm, day, mon, year) async {
    await todoController.addTodo(
        categoryName, doThis, hr, min, amPm, day, mon, year);

    Navigator.of(context).pop();
  }
}

class editTodo extends StatefulWidget {
  final todoTask;
  final hr;
  final min;
  final isAm;
  final day;
  final mon;
  final year;
  final isDone;
  final todos;
  final categoryName;
  const editTodo(
      {super.key,
      required this.todoTask,
      required this.isDone,
      required this.todos,
      required this.hr,
      required this.min,
      required this.isAm,
      required this.day,
      required this.mon,
      required this.year,
      required this.categoryName});

  @override
  State<editTodo> createState() => _editTodoState();
}

class _editTodoState extends State<editTodo> {
  final controller = Get.put(TodoController());
  bool isEdit = false;
  var _timeOfDay;

  DateTime dateNow = DateTime.now();
  int daysInMonth = 0;
  final List<String> _taskhr = [];
  final List<String> _taskmin = [];
  final List<String> _taskmon = [];
  final List<String> _taskday = [];
  final List<String> _taskyear = [];
  String todoTime = '';
  var _amPm;
  @override
  void initState() {
    _amPm = widget.isAm ? 0 : 1;
    _timeOfDay = widget.isAm;
    final month = DateFormat('MMM').format(DateTime(0, int.parse(widget.mon)));
    daysInMonth = DateTime(dateNow.year, dateNow.month + 1, 0).day;
    // Year
    for (int i = dateNow.year; i <= dateNow.year + 10; i++) {
      _taskyear.add(DateFormat('yyyy').format(DateTime(i)));
    }
    // Days
    for (int i = 0; i <= daysInMonth; i++) {
      if (i < 10) {
        _taskday.add('0$i');
      } else {
        _taskday.add('$i');
      }
    }
    // Month
    for (int i = dateNow.year; i <= daysInMonth + 10; i++) {}
    for (int i = 1; i <= 12; i++) {
      if (i < 10) {
        _taskmon.add(DateFormat('MMM').format(DateTime(0, i)));
      } else {
        _taskmon.add(DateFormat('MMM').format(DateTime(0, i)));
      }
    }
    // Hour
    for (int i = 1; i <= 12; i++) {
      if (i < 10) {
        _taskhr.add('0$i');
      } else {
        _taskhr.add('$i');
      }
    }
    // Min
    for (int i = 0; i <= 60; i++) {
      if (i < 10) {
        _taskmin.add('0$i');
      } else {
        _taskmin.add('$i');
      }
    }
    controller.doThisController.addListener((isEmpty));

    controller.hrController.text = widget.hr;
    controller.minController.text = widget.min;
    controller.dayController.text = widget.day;
    controller.monController.text = widget.mon;
    controller.yearController.text = widget.year;
    controller.doThisController.text = widget.todoTask;
    todoTime =
        '${widget.hr}:${widget.min} ${widget.isAm ? 'am' : 'pm'}   ${month.toString()} ${widget.day} , ${widget.year}';
    super.initState();
  }

  isEmpty() {
    if (controller.doThisController.isBlank!) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        backgroundColor: const Color(0xffF5F3C1),
        content: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width,
            height: isEdit ? 350 : 300,
            color: const Color(0xffF5F3C1),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Task: ',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0x7E260564),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    maxLines: isEdit ? 5 : null,
                    readOnly: isEdit ? false : true,
                    cursorColor: const Color(0xff270564),
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Color(0xff270564)),
                    controller: controller.doThisController,
                    decoration: const InputDecoration(
                        hintText: 'Set something you need to do...',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          color: Color.fromARGB(123, 38, 5, 100),
                        ),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: const Color(0xffD9D7A9)),
                  ),
                  AnimatedScale(
                    scale: isEdit ? 0 : 1,
                    duration: Duration(milliseconds: 300),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0x7E260564),
                          ),
                        ),
                        Text(
                          widget.isDone
                              ? 'Task Finished'
                              : 'Task not yet finished',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff270564),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedSlide(
                    offset:
                        isEdit ? const Offset(0, -0.15) : const Offset(0, 0),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reminder Time:',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0x7E260564),
                          ),
                        ),
                        AnimatedScale(
                          curve: Curves.easeInOut,
                          scale: isEdit ? 0 : 1,
                          duration: Duration(milliseconds: 200),
                          child: Text(
                            todoTime,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff270564),
                            ),
                          ),
                        ),
                        AnimatedSlide(
                          offset: isEdit
                              ? const Offset(0, -0.5)
                              : const Offset(0, 0),
                          duration: Duration(milliseconds: 300),
                          child: AnimatedScale(
                            duration: Duration(milliseconds: 300),
                            scale: isEdit ? 1 : 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Color(0xffD9D7A9),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //Time
                                  SizedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50) /
                                              10,
                                          height: 40,
                                          child: WheelChooser(
                                            onValueChanged: (hr) {
                                              setState(() {
                                                controller.hrController.text =
                                                    hr;
                                              });
                                            },
                                            startPosition:
                                                int.parse(widget.hr) - 1,
                                            datas: _taskhr,
                                            listHeight: 15,
                                            unSelectTextStyle: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  123, 38, 5, 100),
                                            ),
                                            selectTextStyle: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: Color(0xff270564)),
                                          ),
                                        ),
                                        const Text(
                                          ":",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff270564)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              11,
                                          height: 40,
                                          child: WheelChooser(
                                            onValueChanged: (min) {
                                              setState(() {
                                                controller.minController.text =
                                                    min;
                                              });
                                            },
                                            startPosition:
                                                int.parse(widget.min) + 1,
                                            datas: _taskmin,
                                            listHeight: 15,
                                            unSelectTextStyle: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  123, 38, 5, 100),
                                            ),
                                            selectTextStyle: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: Color(0xff270564)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              12,
                                          height: 40,
                                          child: WheelChooser(
                                            onValueChanged: (amPm) {
                                              if (amPm == 'AM') {
                                                setState(() {
                                                  _timeOfDay = true;
                                                });
                                              } else {
                                                setState(() {
                                                  _timeOfDay = false;
                                                });
                                              }
                                            },
                                            startPosition: _amPm,
                                            datas: const ['AM', 'PM'],
                                            listHeight: 15,
                                            unSelectTextStyle: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  123, 38, 5, 100),
                                            ),
                                            selectTextStyle: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: Color(0xff270564)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Text(
                                    "|",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 30,
                                        color: Color(0x7D260564)),
                                  ),

                                  //Date

                                  SizedBox(
                                      child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                9,
                                        height: 40,
                                        child: WheelChooser(
                                          onValueChanged: (mon) {
                                            setState(() {
                                              controller.monController.text =
                                                  mon;
                                            });
                                          },
                                          startPosition: dateNow.month - 1,
                                          datas:
                                              _taskmon, //also has a length of 12
                                          listHeight: 15,
                                          unSelectTextStyle: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color:
                                                Color.fromARGB(123, 38, 5, 100),
                                          ),
                                          selectTextStyle: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: Color(0xff270564)),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                12,
                                        height: 40,
                                        child: WheelChooser(
                                          onValueChanged: (day) {
                                            setState(() {
                                              controller.dayController.text =
                                                  day;
                                            });
                                          },
                                          startPosition: dateNow.day,
                                          datas: _taskday,
                                          listHeight: 15,
                                          unSelectTextStyle: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color:
                                                Color.fromARGB(123, 38, 5, 100),
                                          ),
                                          selectTextStyle: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: Color(0xff270564)),
                                        ),
                                      ),
                                      const Text(
                                        ",",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 20,
                                            color: Color(0xff270564)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                7,
                                        height: 40,
                                        child: WheelChooser(
                                          onValueChanged: (year) {
                                            setState(() {
                                              controller.yearController.text =
                                                  year;
                                            });
                                          },
                                          datas: _taskyear,
                                          listHeight: 15,
                                          unSelectTextStyle: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color:
                                                Color.fromARGB(123, 38, 5, 100),
                                          ),
                                          selectTextStyle: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: Color(0xff270564)),
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedSlide(
                          duration: const Duration(milliseconds: 300),
                          offset:
                              isEdit ? const Offset(0, 0) : const Offset(0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    if (isEdit == true) {
                                      controller.editTask(
                                          widget.categoryName,
                                          widget.todos,
                                          widget.isDone,
                                          controller.doThisController.text
                                              .trim(),
                                          controller.hrController.text.trim(),
                                          controller.minController.text.trim(),
                                          _timeOfDay,
                                          controller.dayController.text.trim(),
                                          controller.monController.text.trim(),
                                          controller.yearController.text
                                              .trim());

                                      controller.doThisController.clear();
                                      controller.hrController.clear();
                                      controller.minController.clear();
                                      controller.dayController.clear();
                                      controller.monController.clear();
                                      controller.yearController.clear();
                                      Navigator.of(context).pop();
                                    }
                                    setState(() {
                                      isEdit = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    shadowColor: const Color(0xff270564),
                                    backgroundColor: const Color(0xff27E1C1),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 36),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                  ),
                                  child: Text(
                                    isEdit ? 'Save' : 'Edit',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Color(0xff270564),
                                    ),
                                  )),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (isEdit == true) {
                                      setState(() {
                                        isEdit = false;
                                      });
                                    } else {
                                      controller.deleteTask(
                                          widget.categoryName, widget.todos);
                                      controller.doThisController.clear();
                                      controller.hrController.clear();
                                      controller.minController.clear();
                                      controller.dayController.clear();
                                      controller.monController.clear();
                                      controller.yearController.clear();
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    shadowColor: const Color(0xff27E1C1),
                                    backgroundColor: const Color(0xff270564),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 28),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                  ),
                                  child: Text(
                                    isEdit ? 'Cancel' : 'Delete',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Color(0xff27E1C1),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ])));
  }
}
