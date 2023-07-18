import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/taskCatController.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final controller = Get.put(TaskCatController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xffF5F3C1),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Category.',
                  style: TextStyle(
                    fontFamily: 'aAkhirTahun',
                    fontSize: 20,
                    color: Color(0xff270564),
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
            TextField(
              cursorColor: const Color(0xff270564),
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  color: Color(0xff270564)),
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
                  fillColor: Color(0xffD9D7A9)),
            ),
            ElevatedButton(
                onPressed: () async {
                  await TaskCatController.instance
                      .addCategory(controller.addCatController.text.trim());
                  if (context.mounted) {
                    controller.addCatController.clear();
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shadowColor: const Color(0xff270564),
                  backgroundColor: const Color(0xff27E1C1),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 36),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xff270564),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class EditCategory extends StatefulWidget {
  final categoryName;
  const EditCategory({
    super.key,
    required this.categoryName,
  });
  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final controller = Get.put(TaskCatController());

  @override
  Widget build(BuildContext context) {
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

    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      backgroundColor: const Color(0xffF5F3C1),
      content: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: MediaQuery.of(context).size.width,
        height: 150,
        color: const Color(0xffF5F3C1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Category: ',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xff270564),
              ),
            ),
            Center(
              child: Text(
                cutStringIntoTwoLines(widget.categoryName, 18),
                style: const TextStyle(
                  fontFamily: 'aAkhirTahun',
                  fontSize: 24,
                  color: Color(0xff0EA293),
                ),
              ),
            ),
            AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: const Offset(0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await TaskCatController.instance
                            .editCategory(widget.categoryName);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        shadowColor: const Color(0xff27E1C1),
                        backgroundColor: const Color(0xff270564),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 36),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'assets/images/delete.png',
                            height: 25,
                            width: 25,
                          ),
                          const Text(
                            'Delete Category',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xff27E1C1),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
