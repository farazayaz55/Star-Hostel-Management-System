import 'package:app/global/global.dart';

class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  String? name;
  String? email;
  String? roomNo;

  ToDo({
    required this.id,
    required this.todoText,
    required this.name,
    required this.roomNo,
    required this.email,
    this.isDone = false,
  });
}
