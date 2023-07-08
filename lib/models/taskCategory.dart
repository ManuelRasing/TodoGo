
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskCategory{
  String categoryTitle;
  String categoryIcn; //image path

  TaskCategory({
    required this.categoryTitle, 
    required this.categoryIcn});

  factory TaskCategory.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc){
    const catIcon = 'assets/images/other_task.png';
    return TaskCategory(
      categoryTitle: doc.id, 
      categoryIcn: catIcon
      );
  }
  
}
