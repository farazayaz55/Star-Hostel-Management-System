import 'package:editable/editable.dart';
import 'package:app/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/global/global.dart';

class MessMenu extends StatefulWidget {
  const MessMenu({Key? key}) : super(key: key);

  @override
  State<MessMenu> createState() => _MessMenuState();
}

class _MessMenuState extends State<MessMenu> {
  var editble;
  // ignore: non_constant_identifier_names
  List cols = [
    {"title": 'Day', 'widthFactor': 0.25, 'key': 'day'},
    {"title": 'Breakfast', 'widthFactor': 0.37, 'key': 'bf'},
    {"title": 'Dinner', 'widthFactor': 0.37, 'key': 'dinner'},
  ];

  List rows = [
    {
      "day": "Monday",
      "bf": splitCell(B1.data as String),
      "dinner": splitCell(D1.data as String)
    },
    {
      "day": "Tuesday",
      "bf": splitCell(B2.data as String),
      "dinner": splitCell(D2.data as String)
    },
    {
      "day": "Wednesday",
      "bf": splitCell(B3.data as String),
      "dinner": splitCell(D3.data as String)
    },
    {
      "day": "Thursday",
      "bf": splitCell(B4.data as String),
      "dinner": splitCell(D4.data as String)
    },
    {
      "day": "Friday",
      "bf": splitCell(B5.data as String),
      "dinner": splitCell(D5.data as String)
    },
    {
      "day": "Saturday",
      "bf": splitCell(B6.data as String),
      "dinner": splitCell(D6.data as String)
    },
    {
      "day": "Sunday",
      "bf": splitCell(B7.data as String),
      "dinner": splitCell(D7.data as String)
    },
  ];

  @override
  void initState() {
    super.initState();
    if (isAdminLogin) {
      editble = Editable(
        columns: cols,
        rows: rows,
        showSaveIcon: true,
        trHeight: 250.0,
        tdPaddingLeft: 20.0,
        tdPaddingRight: 20.0,
        onRowSaved: (value) async {
          rows[value['row']][
              value.keys
                  .elementAt(1)] = value[value.keys.elementAt(
              1)]; //value has the edited id and value inspect it by debugger
          Map<String, dynamic> chatData = {
            //we update the rows in previous row and by the update rows list we are updating the firebase
            "B1": rows[0]["bf"],
            "D1": rows[0]["dinner"],
            "B2": rows[1]["bf"],
            "D2": rows[1]["dinner"],
            "B3": rows[2]["bf"],
            "D3": rows[2]["dinner"],
            "B4": rows[3]["bf"],
            "D4": rows[3]["dinner"],
            "B5": rows[4]["bf"],
            "D5": rows[4]["dinner"],
            "B6": rows[5]["bf"],
            "D6": rows[5]["dinner"],
            "B7": rows[6]["bf"],
            "D7": rows[6]["dinner"],
          };
          var ref = await firestore.collection('Table').doc('Latest');
          ref.set(chatData);
        },
      ); //editble
    }//if
    else{
      editble = Editable(
        columns: cols,
        rows: rows,
        showSaveIcon: false,
        trHeight: 250.0,
        tdPaddingLeft: 20.0,
        tdPaddingRight: 20.0,
        onRowSaved: (value) async {
          rows[value['row']][
              value.keys
                  .elementAt(1)] = value[value.keys.elementAt(
              1)]; //value has the edited id and value inspect it by debugger
          Map<String, dynamic> chatData = {
            //we update the rows in previous row and by the update rows list we are updating the firebase
            "B1": rows[0]["bf"],
            "D1": rows[0]["dinner"],
            "B2": rows[1]["bf"],
            "D2": rows[1]["dinner"],
            "B3": rows[2]["bf"],
            "D3": rows[2]["dinner"],
            "B4": rows[3]["bf"],
            "D4": rows[3]["dinner"],
            "B5": rows[4]["bf"],
            "D5": rows[4]["dinner"],
            "B6": rows[5]["bf"],
            "D6": rows[5]["dinner"],
            "B7": rows[6]["bf"],
            "D7": rows[6]["dinner"],
          };
          var ref = await firestore.collection('Table').doc('Latest');
          ref.set(chatData);
        },
      );
    }
  }

  splitCol(String s) {
    var lst = s.split("+");
    var ans = "";
    for (var i = 0; i < lst.length; i++) {
      ans += "${lst[i]}\n";
    }
    return ans;
  }

  saveTimeTable() async {
    //
    Map<String, dynamic> chatData = {
      "B1": B1.data,
      "D1": D1.data,
      "B2": B2.data,
      "D2": D2.data,
      "B3": B3.data,
      "D3": D3.data,
      "B4": B4.data,
      "D4": D4.data,
      "B5": B5.data,
      "D5": D5.data,
      "B6": B6.data,
      "D6": D6.data,
      "B7": B7.data,
      "D7": D7.data,
    };

    var ref = await firestore.collection('Table').doc('Latest');
    ref.set(chatData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Color.fromARGB(255, 255, 255, 255), //background color of scaffold
        appBar: AppBar(
          title: Text("Star Hostel Mess"),
          //title of app
          backgroundColor:
              Color.fromARGB(255, 129, 189, 238), //background color of app bar
        ),
        body: editble);
  }
}
