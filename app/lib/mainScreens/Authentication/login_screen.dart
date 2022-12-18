import 'package:app/mainScreens/Authentication/admin_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_dutch/authentication/signup_screen.dart';
import 'package:app/Splash_Screen/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/global/global.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User? firebaseUser;
  @override
  void initState() {
    super.initState();
  }

  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();

  validateform() {
    if (!emailtextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "email is not correct!");
    } else if (passwordtextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "password is required!");
    } else {
      loginusernow();
    }
  }

  loginusernow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Progressing ... Please wait",
          );
        });

    firebaseUser = (await firebaseAuth
            .signInWithEmailAndPassword(
      email: emailtextEditingController.text.trim(),
      password: passwordtextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error" + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      currentfirebaseuser = firebaseUser;
      Fluttertoast.showToast(msg: "WELCOME TO STAR HOSTEL!!");

      isAdminLogin = false;
      DatabaseReference usersref =
          FirebaseDatabase.instance.ref().child("Users");
      usersref.child(firebaseUser!.uid).once().then((userkey) {
        final snap = userkey.snapshot;
        if (snap.value != null) {
          currentfirebaseuser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successfull!");
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        } else {
          Fluttertoast.showToast(msg: "No record exists with this email!");
          firebaseAuth.signOut();
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error occured during Login..");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  "assets/finallogo.png",
                  width: 300,
                  height: 200,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment(-0.88, 0),
                child: Text(
                  "Lets Get Start!",
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
                height: 20,
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
                        borderSide:
                            BorderSide(color: Colors.black38, width: 2)),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
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
                        borderSide:
                            BorderSide(color: Colors.black38, width: 2)),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
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
                    //Navigator.push(context, MaterialPageRoute(builder: (c)=> CarDetailScreen()));
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
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                child: const Text(
                  "Login As Admin",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => ADMINLoginScreen()));
                },
              ),
              TextButton(
                child: const Text(
                  "Login As Guest",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  firebaseAuth.signInAnonymously();
                  isGuestLogin = true;
                  userModelCurrentInfo.email = "guest";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const MySplashScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
