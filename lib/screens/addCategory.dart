

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/taskCatController.dart';

class AddCategory extends StatefulWidget {
  AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  
  final controller = Get.put(TaskCatController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffF5F3C1),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add Category.',
                style: TextStyle(
                  fontFamily: 'aAkhirTahun',
                  fontSize: 20,
                  color: Color(0xff270564),
                ),),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10,),
                    child: Image.asset('assets/images/cancel.png',
                    height: 30,
                    width: 30,),
                  ),
                )
              ],
            ),
            TextField(
                cursorColor: Color(0xff270564),
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  color: Color(0xff270564)
                ),
                controller: controller.addCatController,
                decoration: const InputDecoration(
                  hintText: "Add your own category",
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
              ElevatedButton(
              onPressed: () async{
                await TaskCatController.instance.addCategory(controller.addCatController.text.trim());
                if(context.mounted){
                  controller.addCatController.clear();
                  Navigator.of(context).pop();
                  };
              }, 
              style: ElevatedButton.styleFrom(
                elevation: 10,
                shadowColor: Color(0xff270564),
                backgroundColor: Color(0xff27E1C1),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)
                ),
              ),
              child: const Text('Save',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xff270564),
              ),)),
          ],
        ),
      ),
      );
  }
}

class EditCategory extends StatefulWidget {
  EditCategory({Key? key}) : super(key: key);

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {

  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffF5F3C1),
      content: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: MediaQuery.of(context).size.width,
        color: Color(0xffF5F3C1),
        child: Column(
          
        ),
        ),
    );
  }
}