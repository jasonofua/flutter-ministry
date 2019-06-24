import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salvation_ministries_library/Tasbs/HomeScreen.dart';
import 'package:salvation_ministries_library/Tasbs/SearchScreen.dart';
import 'package:salvation_ministries_library/Tasbs/FolderScreen.dart';
import 'package:salvation_ministries_library/Tasbs/Profile.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xff3a3b54), //Changing this will change the color of the TabBar
        accentColor: Color(0xff3a3b54),
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Salvation Ministries Digital Library"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.search)),
                Tab(icon: Icon(Icons.folder)),
                Tab(icon:Icon(Icons.person_pin)),
              ],
              indicatorColor: Colors.white,
            ),
          ),
          body: TabBarView(
            children: [
              HomeScreen(),
              SearchScreen(),
              FolderScreen(),
              Profile()
            ],
          ),
        ),
      ),
    );
  }
}