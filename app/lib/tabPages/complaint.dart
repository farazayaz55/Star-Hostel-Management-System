import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/global/global.dart';
import '../model/complaintModel.dart';
import '../constants/colors.dart';
import '../widgets/complaint_item.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todosList;
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
                        child: Text(
                          'Complaint Box',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (ToDo todoo in _foundToDo.reversed)
                        ToDoItem(
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
                        hintText: 'Add a new todo item',
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

  Future<void> _handleToDoChange(ToDo todo) async {
    bool iAmAllowed = false;
    var id = todo.id.toString();
    await firestore.collection('complaints').doc(id).get().then((map) {
      //checking from firebase if i am the owner of complaint
      print(map);
      Fluttertoast.showToast(msg: map['email']);
      if (map['email'] == userModelCurrentInfo.email) {
        iAmAllowed = true;
      }
    });
    if (isAdminLogin || iAmAllowed) {
      setState(() {
        todo.isDone = !todo.isDone;
      });
      var ref = await firestore.collection('complaints').doc(todo.id);

      ref.set({
        "Id": todo.id,
        "Text": todo.todoText,
        "Name": userModelCurrentInfo.name,
        "roomNo": userModelCurrentInfo.roomno,
        "Date": todo.id,
        "isDone": todo.isDone,
      });
    } else {
      Fluttertoast.showToast(msg: "You Can't make the record checked");
    }
  }

  Future<void> _deleteToDoItem(String id) async {
    //am i allowed?
    bool iAmAllowed = false;
    await firestore.collection('complaints').doc(id).get().then((map) {
      print(map);
      Fluttertoast.showToast(msg: map['email']);
      if (map['email'] == userModelCurrentInfo.email) {
        iAmAllowed = true;
      }
    });
    //
    if (isAdminLogin || iAmAllowed) {
      setState(() {
        todosList.removeWhere((item) => item.id == id);
      });

      await firestore.collection('complaints').doc(id).delete();
    } else {
      Fluttertoast.showToast(msg: "You Can't delete the record");
    }
  }

  Future<void> _addToDoItem(String toDo) async {
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      todosList.add(ToDo(
        id: id,
        todoText: toDo,
        name: userModelCurrentInfo.name,
        roomNo: userModelCurrentInfo.roomno,
        email: userModelCurrentInfo.email,
      ));
    });

    var ref = await firestore.collection('complaints').doc(id);
    ref.set({
      "Id": id,
      "Text": toDo,
      "Name": userModelCurrentInfo.name,
      "roomNo": userModelCurrentInfo.roomno,
      "Date": id,
      "isDone": false,
      "email": userModelCurrentInfo.email,
    });
    Fluttertoast.showToast(msg: "compliant added");
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
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
