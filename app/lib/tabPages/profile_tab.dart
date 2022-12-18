import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/mainScreens/Authentication/admin_login.dart';
import 'package:app/mainScreens/Authentication/login_screen.dart';
// import 'package:app/tabPages/home_tab.dart';
import 'package:app/global/global.dart';
import 'package:app/Splash_Screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:app/mainScreens/widgets/info_design_ui.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String? ImageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (ImageUrl != null)
                  ? Image.network(ImageUrl!)
                  : Icon(
                      Icons.account_circle,
                      size: 100,
                    ),
            ),

            //email
            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo.email!,
              iconData: Icons.email,
            ),

            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo.name!,
              iconData: Icons.people,
            ),

            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo.roomno!,
              iconData: Icons.people,
            ),

            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo.cnic!,
              iconData: Icons.people,
            ),

            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo.phone!,
              iconData: Icons.people,
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: () {
                logOut(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent,
              ),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    //also reinitialize the globals
    isAdminLogin = false;
    isGuestLogin = false;
    await _auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  } catch (e) {
    print("error");
  }
}
