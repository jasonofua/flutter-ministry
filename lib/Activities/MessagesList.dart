import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:salvation_ministries_library/Auth/auth.dart';
import 'package:salvation_ministries_library/Model/Message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/BoughtMessages.dart';
import '../Model/User.dart';

class MessagesList extends StatefulWidget {

  Map<String,String> data = new Map();

  MessagesList({Key key, this.data}) : super(key: key);



  @override
  State createState() => MessageListState();
}

class MessageListState extends State<MessagesList> {
  List<Message> list = new List();

  var messages;

  var _database;
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
     messages = FirebaseDatabase.instance
        .reference()
        .child('Messages')
        .orderByChild('genre')
        .equalTo(widget.data["name"]);

    _database = FirebaseDatabase.instance.reference();
    auth = new Auth();
    isInternetConnected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff3a3b54),
    body: NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
        flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(widget.data["name"],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                )),
            background: Image.asset(widget.data["image"],fit: BoxFit.cover,
            )),
      ),
    ];
    },
      body: StreamBuilder(
          stream: messages.onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData) {

              if(snapshot.data.snapshot.value != null){
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                print(widget.data["name"]);
                print(map.values.toList());

                return Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: map.values.toList().length,
                    padding: EdgeInsets.all(2.0),
                    itemBuilder: (BuildContext context, int index) {
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

                      return GestureDetector(
                        onTap: (){
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                          map.values.toList()[index]["imageUrl"],
                                          height: 100.0,
                                          width: 150.0,
                                        )),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(top: 8.0),
                                      child: ListTile(
                                        title: Text(
                                          map.values.toList()[index]["title"],
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
                        ),
                      );

                    },
                  ),
                );
              }

              return Container(
                width: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("No Message For the Genre",style: TextStyle(color: Colors.white, fontSize: 18.0,))),
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                width: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text("No Message For the Genre",style: TextStyle(color: Colors.white, fontSize: 18.0,))),
                    ),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            }
          }),
    ),
    );
}}
