import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? id;
  final String email;
  final String username;
  final String password;

  const UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  toJson(){
    return {
      "Username": username,
      "Email": email,
      "Password": password,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc){
    final data = doc.data()!;
    return UserModel(
      id: doc.id,
      username: data['Username'], 
      email: data['Email'], 
      password: data['Password']);
  }
}