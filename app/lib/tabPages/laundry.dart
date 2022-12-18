import 'package:app/global/global.dart';
import 'package:app/tabPages/laundry_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Laundry extends StatefulWidget {
  const Laundry({Key? key}) : super(key: key);

  @override
  State<Laundry> createState() => _LaundryState();
}

class _LaundryState extends State<Laundry> {
  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.all(32),
        children: [
          buildBackgroundCard("Room 1"),
          buildBackgroundCard("Room 2"),
          buildBackgroundCard("Room 3"),
          buildBackgroundCard("Room 4"),
          buildBackgroundCard("Room 5"),
          buildBackgroundCard("Room 6"),
          buildBackgroundCard("Room 7"),
          buildBackgroundCard("Room 8"),
        ],
      );

  Widget buildBackgroundCard(String RoomNo) {
    var urlBackgroundImage =
        "https://images.unsplash.com/photo-1590074072786-a66914d668f1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxzZWFyY2h8MXx8aG90ZWx8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60";
    if (RoomNo == "Room 1")
      urlBackgroundImage =
          "https://images.unsplash.com/photo-1517840901100-8179e982acb7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8aG90ZWx8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60";

    if (RoomNo == "Room 2")
      urlBackgroundImage =
          "https://images.unsplash.com/photo-1496417263034-38ec4f0b665a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8aG90ZWx8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60";

    if (RoomNo == "Room 3")
      urlBackgroundImage =
          "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8aG90ZWx8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60";

    if (RoomNo == "Room 4")
      urlBackgroundImage =
          "https://images.unsplash.com/photo-1618773928121-c32242e63f39?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8aG90ZWx8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60";

    if (RoomNo == "Room 5")
      urlBackgroundImage =
          "https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhvdGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60";

    if (RoomNo == "Room 6")
      urlBackgroundImage =
          "https://images.unsplash.com/photo-1444201983204-c43cbd584d93?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fGhvdGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60";

    if (RoomNo == "Room 7")
      urlBackgroundImage =
          "https://images.unsplash.com/photo-1518733057094-95b53143d2a7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjJ8fGhvdGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60";

    if (RoomNo == "Room 8")
      urlBackgroundImage =
          "https://images.unsplash.com/photo-1596701062351-8c2c14d1fdd0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjR8fGhvdGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60";
    return GestureDetector(
      onTap: () {
        Fluttertoast.showToast(msg: RoomNo);
        if (RoomNo != userModelCurrentInfo.roomno && !isAdminLogin) {
          Fluttertoast.showToast(msg: "You don't have access to the room");
        } else {
          Fluttertoast.showToast(msg: "TAPPED");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LaundryDetails(roomNo: RoomNo),
            ),
          );
        }
        //shift to laundry details
      },
      child: Container(
        padding: EdgeInsets.all(24),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(urlBackgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.25),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              RoomNo,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
