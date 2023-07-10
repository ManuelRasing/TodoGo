
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);
  @override
  State<AddTask> createState() => _AddTaskState();
  
}

class _AddTaskState extends State<AddTask> {
  TextEditingController taskController = TextEditingController();
  DateTime dateNow = DateTime.now();
  
  

    String _hour = '';
    String _min = '';
    String _timeOfDay = '';
    String _mon = '';
    String _day = '';
    final String _year = '';


  int daysInMonth = 0;
  final String _taskTime = "00";
  final List<String> _taskhr = [];
  final List<String> _taskmin = [];
  final List<String> _taskmon = [];
  final List<String> _taskday = [];
  final List<String> _taskyear = [];

  var _amPm = 0;
  @override
  void initState() {
    daysInMonth = DateTime(dateNow.year, dateNow.month + 1, 0).day;
    if(int.parse(DateFormat('HH').format(dateNow)) > 12){
       _amPm = 1;
    }
    // Year
    for(int i = dateNow.year; i <= dateNow.year + 10; i++){
      _taskyear.add(DateFormat('yyyy').format(DateTime(i)));
    }
    // Days
    for(int i = 0; i <= daysInMonth; i++){
    if(i<10){
      _taskday.add('0$i');
    }else{
      _taskday.add('$i');
    }
    }
    // Month
    for(int i = dateNow.year; i <= daysInMonth + 10; i++){
    }
    for (int i = 1; i <= 12; i++){
    if(i<10){
      _taskmon.add(DateFormat('MMM').format(DateTime(0, i)));
    }else{
      _taskmon.add(DateFormat('MMM').format(DateTime(0, i)));
    }
  }
  // Hour
    for (int i = 1; i <= 12; i++){
    if(i<10){
      _taskhr.add('0$i');
    }else{
      _taskhr.add('$i');
    }
  }
  // Min
    for (int i = 0; i <= 60; i++){
    if(i<10){
      _taskmin.add('0$i');
    }else{
      _taskmin.add('$i');
    }
  }
    super.initState();
  }
  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
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
                const Text("ADD TASK",
                style: TextStyle(
                  fontFamily: "aAkhirTahun",
                  fontSize: 25,
                  color: Color(0xff270564)
                ),),
                Container(
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width - 323),
                  child: Image.asset('assets/images/save.png',
                  height: 30,
                  width: 30,),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10,),
                    child: Image.asset('assets/images/cancel.png',
                    height: 30,
                    width: 30,),
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
                  color: Color(0xff270564)
                ),
                controller: taskController,
                decoration: const InputDecoration(
                  hintText: "Something you want to do..",
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: Color.fromARGB(123, 38, 5, 100),
                    
                  ),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Color(0xffD9D7A9)
                ),
                
              ),
            ),
            const Text('Time and Date',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xff270564)
            ),),
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
                              onValueChanged: (s) {setState(() {
                                _hour = s;
                              });},
                              startPosition: int.parse(DateFormat('hh').format(dateNow)) -1,
                              datas: _taskhr,
                              listHeight: 15,
                              unSelectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color.fromARGB(123, 38, 5, 100),),
                              selectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xff270564)
                              ),),
                        ),
                        const Text(":",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff270564)
                        ),),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 11,
                          height: 40,
                          child: WheelChooser(
                              onValueChanged: (s) {setState(() {
                                _min = s;
                              });},
                              startPosition: int.parse(DateFormat('mm').format(dateNow)),
                              datas: _taskmin,
                              listHeight: 15,
                              unSelectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color.fromARGB(123, 38, 5, 100),),
                              selectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xff270564)
                              ),),
                        ),SizedBox(
                          width: MediaQuery.of(context).size.width / 12,
                          height: 40,
                          child: WheelChooser(
                              onValueChanged: (s) {setState(() {
                                _timeOfDay = s;
                              });},
                              startPosition: _amPm,
                              datas: const ['AM', 'PM'],
                              listHeight: 15,
                              unSelectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color.fromARGB(123, 38, 5, 100),),
                              selectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xff270564)
                              ),),
                        ),
                        
                      ],
                    ),
                  ),

                  const Text("|",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 30,
                          color: Color(0x7D260564)
                        ),),
            
                  //Date
                  
                  SizedBox(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 9,
                          height: 40,
                          child: WheelChooser(
                              onValueChanged: (s) {setState(() {
                                _mon = s;
                              });},
                              startPosition: dateNow.month - 1,
                              datas: _taskmon, //also has a length of 12
                              listHeight: 15,
                              unSelectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color.fromARGB(123, 38, 5, 100),),
                              selectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xff270564)
                              ),),
                        ),
                        
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 12,
                          height: 40,
                          child: WheelChooser(
                              onValueChanged: (s) {setState(() {
                                _day = s;
                              });},
                              startPosition: dateNow.day,
                              datas: _taskday,
                              listHeight: 15,
                              unSelectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color.fromARGB(123, 38, 5, 100),),
                              selectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xff270564)
                              ),),
                        ),
                        const Text(",",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          color: Color(0xff270564)
                        ),),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 7,
                          height: 40,
                          child: WheelChooser(
                              onValueChanged: (s) {setState(() {
                                _timeOfDay = s;
                              });},
                              datas: _taskyear,
                              listHeight: 15,
                              unSelectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color.fromARGB(123, 38, 5, 100),),
                              selectTextStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xff270564)
                              ),),
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
}