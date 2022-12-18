import 'dart:developer' as dev;
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/global/global.dart';

//every signed in user has email
//the message tile has email too
//we match the signed in email with tile email
//if matches it means its ur data so u can edit or if you are admin you can edit the tile
class LaundryDetails extends StatefulWidget {
  final String roomNo;
  const LaundryDetails({required this.roomNo, Key? key}) : super(key: key);

  @override
  State<LaundryDetails> createState() => _LaundryDetailsState();
}

class _LaundryDetailsState extends State<LaundryDetails> {
  // ignore: prefer_typing_uninitialized_variables
  var email;
  var rang1, rang2, rang3, rang4, rang5, rang6, rang7, rang8 = Colors.white;
  final TextEditingController _message = TextEditingController();
  final TextEditingController pents = TextEditingController();
  final TextEditingController shirts = TextEditingController();
  final TextEditingController shorts = TextEditingController();
  final TextEditingController t_shirts = TextEditingController();
  final TextEditingController shalwar_kameez = TextEditingController();
  final TextEditingController trousers = TextEditingController();
  final TextEditingController others = TextEditingController();
  final TextEditingController _message1 = TextEditingController();
  final TextEditingController pents1 = TextEditingController();
  final TextEditingController shirts1 = TextEditingController();
  final TextEditingController shorts1 = TextEditingController();
  final TextEditingController t_shirts1 = TextEditingController();
  final TextEditingController shalwar_kameez1 = TextEditingController();
  final TextEditingController trousers1 = TextEditingController();
  final TextEditingController others1 = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = userModelCurrentInfo.email;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alerttttt!!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to delete this record?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                //delete from firebase
                var disp = await _firestore
                    .collection('laundry')
                    .doc(widget.roomNo)
                    .collection('Data')
                    .doc(email.toString())
                    .delete();

                Navigator.pop(context, 'Yes');
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.pop(context, 'No'),
            ),
          ],
        );
      },
    );
  }

  void onSendMessage() async {
    Fluttertoast.showToast(msg: "TAPPED");
    if (others.text.isEmpty) {
      others.text = "0";
    }
    if (trousers.text.isEmpty) {
      trousers.text = "0";
    }
    if (shalwar_kameez.text.isEmpty) {
      shalwar_kameez.text = "0";
    }
    if (t_shirts.text.isEmpty) {
      t_shirts.text = "0";
    }
    if (shorts.text.isEmpty) {
      shorts.text = "0";
    }
    if (shirts.text.isEmpty) {
      shirts.text = "0";
    }
    if (pents.text.isEmpty) {
      pents.text = "0";
    }
    if (_message.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter Name pls");
    }
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": _message.text,
        "Pants": int.parse(pents.text),
        "Shirts": int.parse(shirts.text),
        "Trousers": int.parse(trousers.text),
        "T-Shirts": int.parse(t_shirts.text),
        "Shalwar Kameez": int.parse(shalwar_kameez.text),
        "Other": int.parse(others.text),
        "Shorts": int.parse(shorts.text),
        "Email": email.toString(),
        "Date": DateTime.now(),
      };

      var ref = await _firestore
          .collection('laundry')
          .doc(widget.roomNo)
          .collection('Data')
          .doc(email.toString());
      ref.set(chatData);
      Fluttertoast.showToast(msg: "data uploaded");
      _message.clear();
      pents.clear();
      shirts.clear();
      t_shirts.clear();
      shalwar_kameez.clear();
      others.clear();
      trousers.clear();
    }
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    _message1.text = chatMap['sendBy'];
    _message1.selection =
        TextSelection.collapsed(offset: _message1.text.length);
    shirts1.text = chatMap['Shirts'].toString();
    shirts1.selection = TextSelection.collapsed(offset: shirts1.text.length);
    pents1.text = chatMap['Pants'].toString();
    pents1.selection = TextSelection.collapsed(offset: pents1.text.length);

    shorts1.text = chatMap['Shorts'].toString();
    shorts1.selection = TextSelection.collapsed(offset: shorts1.text.length);

    t_shirts1.text = chatMap['T-Shirts'].toString();
    t_shirts1.selection =
        TextSelection.collapsed(offset: t_shirts1.text.length);
    trousers1.text = chatMap['Trousers'].toString();
    trousers1.selection =
        TextSelection.collapsed(offset: trousers1.text.length);
    shalwar_kameez1.text = chatMap['Shalwar Kameez'].toString();
    shalwar_kameez1.selection =
        TextSelection.collapsed(offset: shalwar_kameez1.text.length);
    others1.text = chatMap['Other'].toString();
    others1.selection = TextSelection.collapsed(offset: others1.text.length);
    var en = false;
    if (chatMap['Email'] == email || isAdminLogin == true) {
      en = true;
    }
    return Builder(builder: (_) {
      return Container(
          width: size.width,
          child: GestureDetector(
            onLongPress: () {
              if (chatMap['Email'] == email || isAdminLogin == true) {
                _showMyDialog();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: Column(children: [
                TextField(
                  onTap: () {
                    rang2 = Colors.white;
                    rang1 = Colors.white;
                    rang4 = Colors.white;
                    rang5 = Colors.white;
                    rang6 = Colors.white;
                    rang7 = Colors.white;
                    rang3 = Colors.white;
                    rang8 = Colors.red;
                    setState(() {});
                  },
                  controller: _message1,
                  enabled: en,
                  onChanged: (text) async {
                    _message1.text = text;
                    //text is the new name
                    Map<String, dynamic> chatData = {
                      "sendBy": text,
                      "Pants": chatMap['Pants'],
                      "Shirts": chatMap['Shirts'],
                      "Trousers": chatMap['Trousers'],
                      "T-Shirts": chatMap['T-Shirts'],
                      "Shalwar Kameez": chatMap['Shalwar Kameez'],
                      "Other": chatMap['Other'],
                      "Shorts": chatMap['Shorts'],
                      "Email": chatMap['Email'],
                      "Date": DateTime.now(),
                    };
                    var ref = await _firestore
                        .collection('laundry')
                        .doc(widget.roomNo)
                        .collection('Data')
                        .doc(email.toString());
                    ref.set(chatData);
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: rang8,
                  ),
                ),
                SizedBox(
                  height: size.height / 200,
                ),
                const Text('Shirts'),
                TextField(
                  onTap: () {
                    rang2 = Colors.white;
                    rang1 = Colors.white;
                    rang3 = Colors.white;
                    rang5 = Colors.white;
                    rang6 = Colors.white;
                    rang7 = Colors.white;
                    rang8 = Colors.white;
                    rang4 = Colors.red;
                    setState(() {});
                  },
                  controller: shirts1,
                  enabled: en,
                  onChanged: (text) async {
                    if (text == "") {
                      text = "0";
                    }
                    shirts1.text = text;
                    //text is the new name
                    Map<String, dynamic> chatData = {
                      "sendBy": chatMap['sendBy'],
                      "Pants": chatMap['Pants'],
                      "Shirts": int.parse(text),
                      "Trousers": chatMap['Trousers'],
                      "T-Shirts": chatMap['T-Shirts'],
                      "Shalwar Kameez": chatMap['Shalwar Kameez'],
                      "Other": chatMap['Other'],
                      "Shorts": chatMap['Shorts'],
                      "Email": chatMap['Email'],
                      "Date": DateTime.now(),
                    };
                    var ref = await _firestore
                        .collection('laundry')
                        .doc(widget.roomNo)
                        .collection('Data')
                        .doc(email.toString());
                    ref.set(chatData);
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: rang4,
                  ),
                ),
                SizedBox(
                  height: size.height / 200,
                ),
                const Text('T-Shirts'),
                TextField(
                  onTap: () {
                    rang2 = Colors.white;
                    rang1 = Colors.white;
                    rang4 = Colors.white;
                    rang5 = Colors.white;
                    rang3 = Colors.white;
                    rang7 = Colors.white;
                    rang8 = Colors.white;
                    rang6 = Colors.red;
                    setState(() {});
                  },
                  controller: t_shirts1,
                  enabled: en,
                  onChanged: (text) async {
                    if (text == "") {
                      text = "0";
                    }
                    pents1.text = text;
                    //text is the new name
                    Map<String, dynamic> chatData = {
                      "sendBy": chatMap['sendBy'],
                      "Pants": int.parse(text),
                      "Shirts": chatMap['Shirts'],
                      "Trousers": chatMap['Trousers'],
                      "T-Shirts": int.parse(text),
                      "Shalwar Kameez": chatMap['Shalwar Kameez'],
                      "Other": chatMap['Other'],
                      "Shorts": chatMap['Shorts'],
                      "Email": chatMap['Email'],
                      "Date": DateTime.now(),
                    };
                    var ref = await _firestore
                        .collection('laundry')
                        .doc(widget.roomNo)
                        .collection('Data')
                        .doc(email.toString());
                    ref.set(chatData);
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500, color: rang6),
                ),
                const Text('PANTS'),
                TextField(
                  controller: pents1,
                  onTap: () {
                    rang7 = Colors.white;
                    rang1 = Colors.white;
                    rang4 = Colors.white;
                    rang5 = Colors.white;
                    rang6 = Colors.white;
                    rang3 = Colors.white;
                    rang8 = Colors.white;
                    rang2 = Colors.red;
                    setState(() {});
                  },
                  enabled: en,
                  onChanged: (text) async {
                    if (text == "") {
                      text = "0";
                    }
                    pents1.text = text;
                    //text is the new name
                    Map<String, dynamic> chatData = {
                      "sendBy": chatMap['sendBy'],
                      "Pants": int.parse(text),
                      "Shirts": chatMap['Shirts'],
                      "Trousers": chatMap['Trousers'],
                      "T-Shirts": chatMap['T-Shirts'],
                      "Shalwar Kameez": chatMap['Shalwar Kameez'],
                      "Other": chatMap['Other'],
                      "Shorts": chatMap['Shorts'],
                      "Email": chatMap['Email'],
                      "Date": DateTime.now(),
                    };
                    var ref = await _firestore
                        .collection('laundry')
                        .doc(widget.roomNo)
                        .collection('Data')
                        .doc(email.toString());
                    ref.set(chatData);
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: rang2,
                  ),
                ),
                const Text('TROUSERS'),
                TextField(
                  onTap: () {
                    rang2 = Colors.white;
                    rang1 = Colors.white;
                    rang4 = Colors.white;
                    rang5 = Colors.white;
                    rang6 = Colors.white;
                    rang3 = Colors.white;
                    rang8 = Colors.white;
                    rang7 = Colors.red;
                    setState(() {});
                  },
                  controller: trousers1,
                  enabled: en,
                  onChanged: (text) async {
                    if (text == "") {
                      text = "0";
                    }
                    trousers1.text = text;
                    //text is the new name
                    Map<String, dynamic> chatData = {
                      "sendBy": chatMap['sendBy'],
                      "Pants": chatMap['Pants'],
                      "Shirts": chatMap['Shirts'],
                      "Trousers": int.parse(text),
                      "T-Shirts": chatMap['T-Shirts'],
                      "Shalwar Kameez": chatMap['Shalwar Kameez'],
                      "Other": chatMap['Other'],
                      "Shorts": chatMap['Shorts'],
                      "Email": chatMap['Email'],
                      "Date": DateTime.now(),
                    };
                    var ref = await _firestore
                        .collection('laundry')
                        .doc(widget.roomNo)
                        .collection('Data')
                        .doc(email.toString());
                    ref.set(chatData);
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: rang7,
                  ),
                ),
                const Text('Shorts'),
                TextField(
                  onTap: () {
                    rang2 = Colors.white;
                    rang1 = Colors.white;
                    rang4 = Colors.white;
                    rang3 = Colors.white;
                    rang6 = Colors.white;
                    rang7 = Colors.white;
                    rang8 = Colors.white;
                    rang5 = Colors.red;
                    setState(() {});
                  },
                  controller: shorts1,
                  enabled: en,
                  onChanged: (text) async {
                    if (text == "") {
                      text = "0";
                    }
                    shorts1.text = text;
                    //text is the new name
                    Map<String, dynamic> chatData = {
                      "sendBy": chatMap['sendBy'],
                      "Pants": chatMap['Pants'],
                      "Shirts": chatMap['Shirts'],
                      "Trousers": chatMap['Trousers'],
                      "T-Shirts": chatMap['T-Shirts'],
                      "Shalwar Kameez": chatMap['Shalwar Kameez'],
                      "Other": chatMap['Other'],
                      "Shorts": int.parse(text),
                      "Email": chatMap['Email'],
                      "Date": DateTime.now(),
                    };
                    var ref = await _firestore
                        .collection('laundry')
                        .doc(widget.roomNo)
                        .collection('Data')
                        .doc(email.toString());
                    ref.set(chatData);
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: rang5,
                  ),
                ),
                const Text('SUITS'),
                TextField(
                  controller: shalwar_kameez1,
                  enabled: en,
                  onTap: () {
                    rang2 = Colors.white;
                    rang1 = Colors.white;
                    rang4 = Colors.white;
                    rang5 = Colors.white;
                    rang6 = Colors.white;
                    rang7 = Colors.white;
                    rang8 = Colors.white;
                    rang3 = Colors.red;
                    setState(() {});
                  },
                  onChanged: (text) async {
                    if (text == "") {
                      text = "0";
                    }
                    shalwar_kameez1.text = text;
                    //text is the new name
                    Map<String, dynamic> chatData = {
                      "sendBy": chatMap['sendBy'],
                      "Pants": chatMap['Pants'],
                      "Shirts": chatMap['Shirts'],
                      "Trousers": chatMap['Trousers'],
                      "T-Shirts": chatMap['T-Shirts'],
                      "Shalwar Kameez": int.parse(text),
                      "Other": chatMap['Other'],
                      "Shorts": int.parse(text),
                      "Email": chatMap['Email'],
                      "Date": DateTime.now(),
                    };
                    var ref = await _firestore
                        .collection('laundry')
                        .doc(widget.roomNo)
                        .collection('Data')
                        .doc(email.toString());
                    ref.set(chatData);
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: rang3,
                  ),
                ),
                const Text('OTHERS'),
                TextField(
                  controller: others1,
                  enabled: en,
                  onTap: () {
                    rang2 = Colors.white;
                    rang3 = Colors.white;
                    rang4 = Colors.white;
                    rang5 = Colors.white;
                    rang6 = Colors.white;
                    rang7 = Colors.white;
                    rang8 = Colors.white;
                    rang1 = Colors.red;
                    setState(() {});
                  },
                  onChanged: (text) async {
                    if (text == "") {
                      text = "0";
                    }
                    others1.text = text;
                    //text is the new name
                    Map<String, dynamic> chatData = {
                      "sendBy": chatMap['sendBy'],
                      "Pants": chatMap['Pants'],
                      "Shirts": chatMap['Shirts'],
                      "Trousers": chatMap['Trousers'],
                      "T-Shirts": chatMap['T-Shirts'],
                      "Shalwar Kameez": chatMap['Shalwar Kameez'],
                      "Other": int.parse(text),
                      "Shorts": chatMap['Shorts'],
                      "Email": chatMap['Email'],
                      "Date": DateTime.now(),
                    };
                    var ref = await _firestore
                        .collection('laundry')
                        .doc(widget.roomNo)
                        .collection('Data')
                        .doc(email.toString());
                    ref.set(chatData);
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: rang1,
                  ),
                ),
                const Text('Date Entered'),
                Text(
                  (DateFormat('dd-MM-yyyy   :   HH-MM')
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          chatMap['Date'].millisecondsSinceEpoch))
                      .toString()),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ]),
            ),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // dev.debugger();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.roomNo),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              height: size.height / 1.5,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('laundry')
                      .doc(widget.roomNo)
                      .collection('Data')
                      .snapshots(), //lets say snapshot have 3 msgs
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> chatMap =
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;

                          return messageTile(size, chatMap);

                          // return Container();// we used to return a message tile
                        },
                      );
                    } else {
                      return Container();
                    }
                  })),
          //it should not be showed to the guest
          //name,pents,shirts
          Visibility(
           visible: isAdminLogin,
           child:Container(
            height: size.height / 10,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    color: Color.fromARGB(255, 50, 61, 221),
                    height: size.height / 17,
                    width: size.width / 4,
                    child: TextFormField(
                      onTap: () {
                        rang2 = Colors.white;
                        rang1 = Colors.white;
                        rang4 = Colors.white;
                        rang5 = Colors.white;
                        rang6 = Colors.white;
                        rang7 = Colors.white;
                        rang8 = Colors.white;
                        rang3 = Colors.white;
                        setState(() {});
                      },
                      style: TextStyle(color: Colors.pinkAccent),
                      enabled: true,
                      controller: _message,
                      decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle:
                              TextStyle(color: Color.fromARGB(255, 116, 1, 39)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  Container(
                    height: size.height / 17,
                    width: size.width / 4,
                    color: Color.fromARGB(255, 50, 61, 221),
                    child: TextFormField(
                      onTap: () {
                        rang2 = Colors.white;
                        rang1 = Colors.white;
                        rang4 = Colors.white;
                        rang5 = Colors.white;
                        rang6 = Colors.white;
                        rang7 = Colors.white;
                        rang8 = Colors.white;
                        rang3 = Colors.white;
                        setState(() {});
                      },
                      style: TextStyle(color: Colors.pinkAccent),
                      controller: pents,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Pents",
                          hintStyle:
                              TextStyle(color: Color.fromARGB(255, 116, 1, 39)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  Container(
                    height: size.height / 17,
                    width: size.width / 4,
                    color: Color.fromARGB(255, 50, 61, 221),
                    child: TextFormField(
                      onTap: () {
                        rang2 = Colors.white;
                        rang1 = Colors.white;
                        rang4 = Colors.white;
                        rang5 = Colors.white;
                        rang6 = Colors.white;
                        rang7 = Colors.white;
                        rang8 = Colors.white;
                        rang3 = Colors.white;
                        setState(() {});
                      },
                      style: TextStyle(color: Colors.pinkAccent),
                      controller: shirts,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Shirts",
                          hintStyle:
                              TextStyle(color: Color.fromARGB(255, 116, 1, 39)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                ])),
          )
          ),
          //2nd row
          Visibility(
          visible: isAdminLogin,
          child: Container(
            height: size.height / 10,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    height: size.height / 17,
                    width: size.width / 4,
                    color: Color.fromARGB(255, 50, 61, 221),
                    child: TextFormField(
                      onTap: () {
                        rang2 = Colors.white;
                        rang1 = Colors.white;
                        rang4 = Colors.white;
                        rang5 = Colors.white;
                        rang6 = Colors.white;
                        rang7 = Colors.white;
                        rang8 = Colors.white;
                        rang3 = Colors.white;
                        setState(() {});
                      },
                      style: TextStyle(color: Colors.pinkAccent),
                      controller: t_shirts,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "T-SHirts",
                          hintStyle:
                              TextStyle(color: Color.fromARGB(255, 116, 1, 39)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  Container(
                    height: size.height / 17,
                    width: size.width / 4,
                    color: Color.fromARGB(255, 50, 61, 221),
                    child: TextFormField(
                      onTap: () {
                        rang2 = Colors.white;
                        rang1 = Colors.white;
                        rang4 = Colors.white;
                        rang5 = Colors.white;
                        rang6 = Colors.white;
                        rang7 = Colors.white;
                        rang8 = Colors.white;
                        rang3 = Colors.white;
                        setState(() {});
                      },
                      style: TextStyle(color: Colors.pinkAccent),
                      controller: shalwar_kameez,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Shalwar_Kameez",
                          hintStyle:
                              TextStyle(color: Color.fromARGB(255, 116, 1, 39)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  Container(
                    height: size.height / 17,
                    width: size.width / 4,
                    color: Color.fromARGB(255, 50, 61, 221),
                    child: TextFormField(
                      onTap: () {
                        rang2 = Colors.white;
                        rang1 = Colors.white;
                        rang4 = Colors.white;
                        rang5 = Colors.white;
                        rang6 = Colors.white;
                        rang7 = Colors.white;
                        rang8 = Colors.white;
                        rang3 = Colors.white;
                        setState(() {});
                      },
                      style: TextStyle(color: Colors.pinkAccent),
                      controller: trousers,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "trousers",
                          hintStyle:
                              TextStyle(color: Color.fromARGB(255, 116, 1, 39)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                ])),
          )
          ),
          //3rd row
          Visibility(
          visible: isAdminLogin,
          child: Container(
            height: size.height / 10,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    height: size.height / 17,
                    width: size.width / 4,
                    color: Color.fromARGB(255, 50, 61, 221),
                    child: TextFormField(
                      onTap: () {
                        rang2 = Colors.white;
                        rang1 = Colors.white;
                        rang4 = Colors.white;
                        rang5 = Colors.white;
                        rang6 = Colors.white;
                        rang7 = Colors.white;
                        rang8 = Colors.white;
                        rang3 = Colors.white;
                        setState(() {});
                      },
                      style: TextStyle(color: Colors.pinkAccent),
                      controller: others,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Others",
                          hintStyle:
                              TextStyle(color: Color.fromARGB(255, 116, 1, 39)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  Container(
                    height: size.height / 17,
                    width: size.width / 4,
                    color: Color.fromARGB(255, 50, 61, 221),
                    child: TextFormField(
                      onTap: () {
                        rang2 = Colors.white;
                        rang1 = Colors.white;
                        rang4 = Colors.white;
                        rang5 = Colors.white;
                        rang6 = Colors.white;
                        rang7 = Colors.white;
                        rang8 = Colors.white;
                        rang3 = Colors.white;
                        setState(() {});
                      },
                      style: TextStyle(color: Colors.pinkAccent),
                      controller: shorts,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Shorts",
                          hintStyle:
                              TextStyle(color: Color.fromARGB(255, 116, 1, 39)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        Fluttertoast.showToast(msg: "Tapped");
                        if (isGuestLogin) {
                          Fluttertoast.showToast(
                              msg: "Sorry you can not enter data as a guest");
                        } else {
                          Fluttertoast.showToast(msg: "OK!!");
                          onSendMessage();
                        }
                      }),
                ])),
          )
          ),
        ]) //after scold view
            ));
  }
}
