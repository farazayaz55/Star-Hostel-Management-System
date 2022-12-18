import 'package:flutter/material.dart';

import 'package:app/model/daily-mess.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/colors.dart';
import 'package:app/widgets/daily-mess_item.dart';
import 'package:app/global/global.dart';

class dailyMess extends StatefulWidget {
  dailyMess({Key? key}) : super(key: key);

  @override
  State<dailyMess> createState() => _dailyMessState();
}

class _dailyMessState extends State<dailyMess> {
  List<Person> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = peoplesList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'All Mess People',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                //mark all as read
                                for (Person todoo in _foundToDo.reversed) {
                                  _handleToDoChange(todoo);
                                }
                              },
                              icon: const Icon(Icons.mark_chat_read),
                            ),

                          ],
                        ),
                      ),
                      for (Person todoo in _foundToDo.reversed)
                        Peopleitem(
                          todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                        hintText: 'Add a new Person Here',
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  onPressed: () {
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: tdBlue,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> _handleToDoChange(Person todo) async {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    var ref = await firestore.collection('people').doc(todo.id);

    ref.set({
      "Id": todo.id,
      "Text": todo.todoText,
      "Description": todo.description,
      "isDone": todo.isDone,
    });
  }

  Future<void> _deleteToDoItem(String id) async {
    setState(() {
      peoplesList.removeWhere((item) => item.id == id);
    });

    await firestore.collection('people').doc(id).delete();
  }

  Future<void> _addToDoItem(String toDo) async {
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      peoplesList.add(Person(
        id: id,
        todoText: toDo,
        description: "",
      ));
    });
    var ref = await firestore.collection('people').doc(id);
    ref.set({
      "Id": id,
      "Text": toDo,
      "Description": "",
      "isDone": false,
    });
    Fluttertoast.showToast(msg: "Person added");
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<Person> results = [];
    if (enteredKeyword.isEmpty) {
      results = peoplesList;
    } else {
      results = peoplesList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/avatar.jpeg'),
          ),
        ),
      ]),
    );
  }
}
