import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:app/global/global.dart';
import 'package:flutter/material.dart';
// import 'package:go_dutch/authentication/login_screen.dart';
// import 'package:go_dutch/authentication/signup_screen.dart';
// import 'package:go_dutch/global/global.dart';
// import 'package:go_dutch/mainScreens/main_screen.dart';
import 'package:app/mainScreens/main_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../mainScreens/Authentication/login_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 5), () async {
      //these funcs should be done on splash to remove errors
      initscreen();
      getTimeTable();
      //sending user to main screen

      if (await firebaseAuth.currentUser != null) {
        currentfirebaseuser = firebaseAuth.currentUser;

        // Fluttertoast.showToast(msg: userModelCurrentInfo.email.toString());
        userModelCurrentInfo.email = currentfirebaseuser!.email;
        if (currentfirebaseuser!.email == "i180453@nu.edu.pk") {
          isAdminLogin = true;
        }
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/splash.json",
                width: 333,
                height: 205,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Star Hostel",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Mulish',
                    letterSpacing: 0,
                    height: 1,
                    decoration: TextDecoration.none),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Home Like Hostel!",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Mulish',
                    letterSpacing: 0,
                    height: 1,
                    decoration: TextDecoration.none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
