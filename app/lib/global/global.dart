import 'dart:async';
import 'package:app/mainScreens/Authentication/signup_screen.dart';
import 'package:app/model/daily-mess.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app/model/user_model.dart';
import 'package:app/model/complaintModel.dart';
import 'package:flutter/material.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentfirebaseuser;
UserModel userModelCurrentInfo = UserModel();
StreamSubscription<Position>? streamSubscription;
String titleStarsRating = "Good";
bool isAdminLogin = false; //get the context?
bool isGuestLogin = false;
List<Person> peoplesList = [];
List<ToDo> todosList = [];

Future<void> initPeople() async {
  await firestore.collection('people').get().then((value) {
    for (int i = 0; i < value.docs.length; i++) {
      var usermap = value.docs[i].data();
      peoplesList.add(Person(
        id: usermap['Id'],
        todoText: usermap['Text'],
        isDone: usermap['isDone'],
        description: usermap['description'],
      ));
    }
  });
}

//init complaints
Future<void> initscreen() async {
  await firestore.collection('complaints').get().then((value) {
    for (int i = 0; i < value.docs.length; i++) {
      var usermap = value.docs[i].data();
      todosList.add(ToDo(
        id: usermap['Id'],
        todoText: usermap['Text'],
        isDone: usermap['isDone'],
        name: usermap['Name'],
        roomNo: usermap['roomNo'],
        email: usermap['email'],
      ));
    }
  });
}

//menu
late Text B1;
late Text D1;
late Text B2;
late Text D2;
late Text B3;
late Text D3;
late Text B4;
late Text D4;
late Text B5;
late Text D5;
late Text B6;
late Text D6;
late Text B7;
late Text D7;
//to split menu table cell to multiple rows
splitCell(String s) {
  s = s.replaceAll("+", "+\n"); //chicken-biryani will be converted to two lines
  s = s.replaceAll("/",
      "/\n"); //dash will be converted to two lines  with dash being appended
  s = s.replaceAll(
      "-", "\n"); //- will be converted to two lines with - being appended
  return s;
}

getTimeTable() async {
  await firestore.collection('Table').doc('Latest').get().then((map) {
    B1 = Text(map["B1"]);
    D1 = Text(map["D1"]);
    B2 = Text(map["B2"]);
    D2 = Text(map["D2"]);
    B3 = Text(map["B3"]);
    D3 = Text(map["D3"]);
    B4 = Text(map["B4"]);
    D4 = Text(map["D4"]);
    B5 = Text(map["B5"]);
    D5 = Text(map["D5"]);
    B6 = Text(map["B6"]);
    D6 = Text(map["D6"]);
    B7 = Text(map["B7"]);
    D7 = Text(map["D7"]);
  });
}

readCurrentOnlineUserInfo() async {
  currentfirebaseuser = firebaseAuth.currentUser;
  await FirebaseDatabase.instance
      .ref()
      .child("Users")
      .child(currentfirebaseuser!.uid)
      .once()
      .then((snap) {
    if (snap.snapshot.value != null) {
      userModelCurrentInfo.id = (snap.snapshot.value as dynamic)["id"];
      userModelCurrentInfo.name = (snap.snapshot.value as dynamic)['name'];
      userModelCurrentInfo.phone = (snap.snapshot.value as dynamic)["phone"];
      userModelCurrentInfo.email = (snap.snapshot.value as dynamic)["email"];
      userModelCurrentInfo.cnic = (snap.snapshot.value as dynamic)["cnic"];
      userModelCurrentInfo.roomno = (snap.snapshot.value as dynamic)["roomno"];
      print("User id--------------------------------------------------: ");
      print(userModelCurrentInfo.id);
      print("\n User name: ");
      print(userModelCurrentInfo.name);
    }
  });
}

readAdminInfo() async {
  currentfirebaseuser = firebaseAuth.currentUser;
  await FirebaseDatabase.instance
      .ref()
      .child("Admin")
      .child("FARAZ")
      .once()
      .then((snap) {
    if (snap.snapshot.value != null) {
      userModelCurrentInfo.id = (snap.snapshot.value as dynamic)["id"];
      userModelCurrentInfo.name = (snap.snapshot.value as dynamic)['name'];
      userModelCurrentInfo.phone = (snap.snapshot.value as dynamic)["phone"];
      userModelCurrentInfo.email = (snap.snapshot.value as dynamic)["email"];
      userModelCurrentInfo.cnic = (snap.snapshot.value as dynamic)["cnic"];
      userModelCurrentInfo.roomno = (snap.snapshot.value as dynamic)["roomNo"];
      print("User id--------------------------------------------------: ");
      print(userModelCurrentInfo.id);
      print("\n User name: ");
      print(userModelCurrentInfo.name);
    }
  });
}
