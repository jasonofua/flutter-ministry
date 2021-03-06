import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salvation_ministries_library/Auth/auth.dart';
import 'package:salvation_ministries_library/Model/Message.dart';
import 'package:salvation_ministries_library/Activities/MessagesList.dart';
import 'package:salvation_ministries_library/Activities/NewMessage.dart';
import 'package:salvation_ministries_library/Activities/Ebook.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/BoughtMessages.dart';
import '../Model/User.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Message> list = new List();
  final myController = TextEditingController();
  var _database;
  var _userDatabase;
  String _code = "";
  String uid = "";
  String connected = "";
  BaseAuth auth;
  User userD;

  void getUid() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid;
    print(uid);
    userD = await auth.returnAUserDetail(uid);

    // here you write the codes to input the data into firestore
  }

  void isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connected = "connected";
        print('connected');
        inputData();
      }
    } on SocketException catch (_) {
      print('not connected');
      connected = "not connected";

    }
  }

  void inputData() async {
    final prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('uid') ?? '';

    if (myString != null || myString != "") {
      uid = myString;
      userD = await auth.returnAUserDetail(uid);

    } else {
      getUid();
      print("scam" + uid);
    }

    // here you write the codes to input the data into firestore
  }
  @override
  void initState() {
    final FirebaseDatabase database =
    FirebaseDatabase(app: FirebaseDatabase.instance.app);
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    _database = FirebaseDatabase.instance.reference();
    _database = FirebaseDatabase.instance.reference().child("Users");
    auth = new Auth();
    isInternetConnected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff3a3b54),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  height: 200.0,
                  child: StreamBuilder(
                      stream: FirebaseDatabase.instance
                          .reference()
                          .child("Messages")
                          .onValue,
                      builder:
                          (BuildContext context, AsyncSnapshot<Event> snapshot) {
                        if (snapshot.hasData) {
                          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                          print(map.values.toList()[0]["imageUrl"].toString());

                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: map.values.toList().length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                var type = "";

                                var my_color_variable = Colors.blue;

                                String currency = map.values.toList()[index]
                                ["points"].toString();

                                String amount = "${currency} points";

                                if (map.values.toList()[index]["type"] == "Audio") {
                                  type = 'Audio';
                                  my_color_variable = Colors.blue;
                                } else if (map.values.toList()[index]["type"] ==
                                    "Book") {
                                  type = 'Book';
                                  my_color_variable = Colors.green;
                                } else {
                                  type = 'Video';
                                  my_color_variable = Colors.red;
                                }

                                print(currency);
                                return GestureDetector(
                                  onTap: () {
                                    Alert(

                                        style: AlertStyle(
                                          animationType: AnimationType.fromTop,
                                          isCloseButton: false,
                                          overlayColor: Color(0xff3a3b54),
                                          animationDuration:
                                          Duration(milliseconds: 400),
                                          isOverlayTapDismiss: true,
                                        ),
                                        context: context,
                                        title: "",
                                        content: Column(
                                          children: <Widget>[
                                            Banner(
                                              location: BannerLocation.topEnd,
                                              color: my_color_variable,
                                              message: type,
                                              child: Center(
                                                  child: Image.network(
                                                    map.values.toList()[index]
                                                    ["imageUrl"],
                                                    height: 100.0,
                                                    width: 250.0,
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(top: 8.0),
                                              child: ListTile(
                                                title: Text(
                                                  map.values.toList()[index]
                                                  ["title"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color(0xff3a3b54),
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(top: 4.0),
                                              child: ListTile(
                                                title: Text(
                                                  map.values.toList()[index]
                                                  ["author"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color(0xff3a3b54),
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            OutlineButton(
                                              child: new Text(
                                                amount,
                                                style: TextStyle(
                                                    color: Color(0xff3a3b54),
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                int amt = map.values.toList()[index]["points"];

                                                if (amt > userD.wallet){
                                                  Fluttertoast.showToast(
                                                      msg: "Insufficient fund.. please fund account",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIos: 2,
                                                      backgroundColor: Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                }else{
                                                  int newAmount = userD.wallet - amt;

                                                  Fluttertoast.showToast(
                                                      msg: "Getting your message..please wait",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIos: 2,
                                                      backgroundColor: Colors.green,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);


                                                  BoughtMessages bought = new BoughtMessages(map.values.toList()[index]["title"], map.values.toList()[index]["imageUrl"], map.values.toList()[index]["downloadUrl"], type, map.values.toList()[index]["exetension"], map.values.toList()[index]["key"]);
                                                  auth.buyMessage(bought, uid).whenComplete(() async {

                                                    auth.updateUserAmount(uid, newAmount).whenComplete(() async {
                                                      Fluttertoast.showToast(
                                                          msg: "Message Bought",
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.CENTER,
                                                          timeInSecForIos: 5,
                                                          backgroundColor: Colors.green,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0);

                                                    });
                                                  }) ;
                                                }


                                              },
                                              borderSide:
                                              BorderSide(color: Colors.amber),
                                              shape: StadiumBorder(),
                                            ),

                                          ],
                                        ),
                                        buttons: [
                                          DialogButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text(
                                              "",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          )
                                        ]).show();
                                  },
                                  child: Container(
                                    width: 150.0,
                                    child: Banner(
                                      location: BannerLocation.topEnd,
                                      color: my_color_variable,
                                      message: type,
                                      child: Card(
                                        color: Color(0xff3a3b54),
                                        child: Wrap(
                                          children: <Widget>[
                                            Center(
                                                child: Image.network(
                                                  map.values.toList()[index]
                                                  ["imageUrl"],
                                                  height: 100.0,
                                                  width: 150.0,
                                                )),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(top: 8.0),
                                              child: ListTile(
                                                title: Text(
                                                  map.values.toList()[index]
                                                  ["title"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Map<String, String> data = new Map();
                      data["name"] = "New Release";
                      data["image"] = "assets/image/background.png";

                      var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new NewMessage(data: data));
                      Navigator.of(context).push(route);
                    },
                    child: Text(
                      "New Release",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Map<String, String> data = new Map();
                      data["name"] = "All Messages";
                      data["image"] = "assets/image/background.png";

                      var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new NewMessage(data: data));
                      Navigator.of(context).push(route);
                    },
                    child: Text(
                      "All Messages",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Map<String, String> data = new Map();
                      data["name"] = "Ebooks";
                      data["image"] = "assets/image/background.png";

                      var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new Ebook(data: data));
                      Navigator.of(context).push(route);
                    },
                    child: Text(
                      "Ebooks",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 16.0),
                  child: Text(
                    "GENRE & TAG",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "WORD";
                        data["image"] = "assets/image/word.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "WORD",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/image/word.png"),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "SPECIAL EVENTS (5NOG)";
                        data["image"] = "assets/image/fivenight.JPG";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "SPECIAL EVENTS (5NOG)",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/fivenight.JPG'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "POWER";
                        data["image"] = "assets/image/power.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "POWER",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/power.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "PRAISE";
                        data["image"] = "assets/image/praise.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "PRAISE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/praise.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "SUCCESS";
                        data["image"] = "assets/image/success.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "SUCCESS",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/success.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "FAMILY/MARRIAGE";
                        data["image"] = "assets/image/family.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "FAMILY/MARRIAGE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/family.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "REALITIES OF NEW BIRTH";
                        data["image"] = "assets/image/birth.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "REALITIES OF NEW BIRTH",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/birth.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "FAITH";
                        data["image"] = "assets/image/faith.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "FAITH",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/faith.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "PROSPERITY/FINANCE";
                        data["image"] = "assets/image/business.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "PROSPERITY/FINANCE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/business.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "WISDOM";
                        data["image"] = "assets/image/wisdom.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "WISDOM",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/wisdom.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "PRAYER";
                        data["image"] = "assets/image/prayer.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "PRAYER",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/prayer.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "HOLY SPIRIT/ANOINTING";
                        data["image"] = "assets/image/holyspirit.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "HOLY SPIRIT/ANOINTING",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image:
                                AssetImage('assets/image/holyspirit.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "HEALING/MIRACLES";
                        data["image"] = "assets/image/healing.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Center(
                            child: Text(
                              "HEALING/MIRACLES",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/healing.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "VENGANCE/JUDGEMENT";
                        data["image"] = "assets/image/vengence.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "VENGANCE/JUDGEMENT",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/vengence.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "BUSINESS/CAREER";
                        data["image"] = "assets/image/business.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "BUSINESS/CAREER",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/business.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "SOUL WINNING/SOUL WORD";
                        data["image"] = "assets/image/soul.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "SOUL WINNING/SOUL WORD",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/soul.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "COMMUNION";
                        data["image"] = "assets/image/communion.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "COMMUNION",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/communion.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, String> data = new Map();
                        data["name"] = "EXCELLENCE";
                        data["image"] = "assets/image/excellence.png";

                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MessagesList(data: data));
                        Navigator.of(context).push(route);
                      },
                      child: Container(
                        width: 150.0,
                        height: 130.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(
                              "EXCELLENCE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image:
                                AssetImage('assets/image/excellence.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
