class Person {
  String? id;
  String? todoText;
  bool isDone;
  String? description;

  Person({
    required this.id,
    required this.todoText,
    required this.description,
    this.isDone = false,
  });
}
