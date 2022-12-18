import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/mainScreens/Authentication/login_screen.dart';
import 'package:app/global/global.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

TextEditingController cnictextEditingController = TextEditingController();
TextEditingController roomNo = TextEditingController();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  User? firebaseUser;
  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();
  TextEditingController phonetextEditingController = TextEditingController();

  validateform() async {
    if (nametextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 characters!!");
    } else if (!emailtextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "email is not correct!");
    } else if (passwordtextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "password must be atleast 6 characters!!");
    } else if (phonetextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "phonenumber is mandatory!!");
    } else if (phonetextEditingController.text.length != 11) {
      Fluttertoast.showToast(msg: "phone number must be 11 numbers!");
    } else if (cnictextEditingController.text.length != 13) {
      Fluttertoast.showToast(msg: "cnic must be 13 numbers!");
    } else if (roomNo.text.isEmpty) {
      Fluttertoast.showToast(msg: "Room No must be entered!");
    } else {
      await await saveInfotofirebase();
    }
  }

  clearform() {
    setState(() {
      nametextEditingController.clear();
      cnictextEditingController.clear();
      phonetextEditingController.clear();
      roomNo.clear();
      passwordtextEditingController.clear();
      emailtextEditingController.clear();
      nametextEditingController.clear();
    });
  }

  removeinfo() async {
    DatabaseReference usersref = FirebaseDatabase.instance.ref().child("Users");
    usersref.child(firebaseUser!.uid).remove();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _firestore.collection('users').doc(_auth.currentUser!.uid).delete();
    firebaseUser!.delete();
  }

  saveInfotofirebase() async {
    Fluttertoast.showToast(msg: "saving...");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing Please wait...",
          );
        });
    firebaseUser = (await firebaseAuth
            .createUserWithEmailAndPassword(
      email: emailtextEditingController.text.trim(),
      password: passwordtextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error" + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      Map usersmap = {
        "id": firebaseUser!.uid,
        "name": nametextEditingController.text.trim(),
        "email": emailtextEditingController.text.trim(),
        "password": passwordtextEditingController.text.trim(),
        "phone": phonetextEditingController.text.trim(),
        "cnic": cnictextEditingController.text.trim(),
        "roomno": "Room ${roomNo.text.trim()}",
      };

      DatabaseReference usersref =
          FirebaseDatabase.instance.ref().child("Users");
      usersref.child(firebaseUser!.uid).set(usersmap);


      Fluttertoast.showToast(msg: "Account has been created");
      //clear the screen
      clearform();
      //cancel progress screen
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "Account has not been created");
      //makeform red

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Align(
                alignment: Alignment.center,
                child: const Text(
                  "Welcome to Star Hostel",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Mulish',
                    letterSpacing: 0,
                    height: 1,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Home Like Hostel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Mulish',
                    letterSpacing: 0,
                    height: 1,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SignUp',
                  style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 40,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create Account!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Mulish',
                    letterSpacing: 0,
                    height: 1,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              TextField(
                controller: nametextEditingController,
                keyboardType: TextInputType.text,
                enableSuggestions: false,
                autocorrect: false,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(color: Colors.black38, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(34, 87, 122, 1), width: 3)),
                    hintText: "Name",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontFamily: 'Poppins-Regular')),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailtextEditingController,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(color: Colors.black38, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(34, 87, 122, 1), width: 3)),
                    hintText: "Email",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontFamily: 'Poppins-Regular')),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordtextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(color: Colors.black38, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(34, 87, 122, 1), width: 3)),
                    hintText: "Password",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontFamily: 'Poppins-Regular')),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: phonetextEditingController,
                keyboardType: TextInputType.phone,
                enableSuggestions: false,
                autocorrect: false,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(color: Colors.black38, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(34, 87, 122, 1), width: 3)),
                    hintText: "Phone Number",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontFamily: 'Poppins-Regular')),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: cnictextEditingController,
                keyboardType: TextInputType.number,
                enableSuggestions: false,
                autocorrect: false,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(color: Colors.black38, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(34, 87, 122, 1), width: 3)),
                    hintText: "CNIC",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontFamily: 'Poppins-Regular')),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: roomNo,
                keyboardType: TextInputType.number,
                enableSuggestions: false,
                autocorrect: false,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(color: Colors.black38, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(34, 87, 122, 1), width: 3)),
                    hintText: "Room No",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontFamily: 'Poppins-Regular')),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50.0,
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    validateform();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Poppins-Regular'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
