import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController? taskController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffF5F3C1),
      content: Container(
        width: MediaQuery.of(context).size.width -30,
        height: 300,
        decoration: const BoxDecoration(
          color: Color(0xffF5F3C1),
        ),
        child: Column(
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
                  margin: EdgeInsets.only(left: 100),
                  child: Image.asset('assets/images/save.png',
                  height: 30,
                  width: 30,),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,),
                  child: Image.asset('assets/images/cancel.png',
                  height: 30,
                  width: 30,),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: TextField(
                maxLines: 5,
                cursorColor: Color(0xff270564),
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
            )
          ],
        ),
      ),
    );
  }
}