import 'package:app/mainScreens/Authentication/signup_screen.dart';
import 'package:app/tabPages/Mess_menu.dart';
import 'package:app/tabPages/complaint.dart';
import 'package:app/tabPages/daily_mess.dart';
import 'package:app/tabPages/profile_tab.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:app/tabPages/laundry.dart';
import 'package:flutter/material.dart';
import 'package:app/global/global.dart';
// import 'package:go_dutch/tabPages/ChatBot.dart';
// import 'package:go_dutch/tabPages/home_tab.dart';
// import 'package:go_dutch/tabPages/profile_tab.dart';
// import 'package:go_dutch/tabPages/ratings_tab.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;
  List<Widget> tabBarList = [];
  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!isAdminLogin) {
      tabBarList = [
        Laundry(),
        MessMenu(),
        ProfileTab(),
        Home(), //complaint screen
      ];
    } else {
      //if its admin login
      tabBarList = [
        Laundry(),
        MessMenu(),
        ProfileTab(),
        Home(), //complaint screen
        SignUpScreen(),
        dailyMess(),
      ];
    }
    //if you are a user you will see these  screens
    tabController = TabController(length: tabBarList.length, vsync: this);
    if (!isAdminLogin) {
      readCurrentOnlineUserInfo();
    } else {
      readAdminInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: tabBarList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Laundry",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: "Mess",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Complaint",
          ),
          if (isAdminLogin)
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: "Make account",
            ),
          
          if(isAdminLogin)
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank),
              label: "Mess Control",
            )

        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
