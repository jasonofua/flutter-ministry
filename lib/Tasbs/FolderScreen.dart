import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salvation_ministries_library/Activities/WebViewRedirect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:salvation_ministries_library/Auth/AudioApp.dart';
import 'package:salvation_ministries_library/Model/BoughtMessages.dart';
import 'package:salvation_ministries_library/Activities/VideoPlayer.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:salvation_ministries_library/Auth/auth.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

enum Departments { Call, Email }

class FolderScreen extends StatefulWidget {
  String value;

  FolderScreen({Key key, this.value}) : super(key: key);

  @override
  State createState() => FolderScreenState();
}

class FolderScreenState extends State<FolderScreen> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  FirebaseDatabase _databaseDownloaded = FirebaseDatabase.instance;
  FirebaseDatabase _databaseNew = FirebaseDatabase.instance;
  List<BoughtMessages> list = new List();
  List<BoughtMessages> list2 = new List();
  String uid = "";
  var messages,downloaded;
  String t;
  String localFilePath;
  BaseAuth auth;
  String connected = "";


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


  Future<Departments> _asyncSimpleDialog(
      BuildContext context,
      String title,
      String downloadUrl,
      String imageUrl,
      String extension,
      String type,
      String key) async {
    if (type == "Audio") {
      t = "Listen";
    } else if (type == "Video") {
      t = "Watch";
    } else {
      t = "Read";
    }
    return await showDialog<Departments>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(title),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  if (type == "Audio") {
                    Map<String, String> data = new Map();
                    data["downloadUrl"] = downloadUrl;
                    data["image"] = imageUrl;
                    data["title"] = title;

                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new AudioApp(data: data));
                    Navigator.of(context).push(route);
                  } else if (type == "Video") {
                    Map<String, String> data = new Map();
                    data["downloadUrl"] = downloadUrl;
                    data["image"] = imageUrl;
                    data["title"] = title;
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new VideoApp(
                              data: data,
                            ));
                    Navigator.of(context).push(route);
                  }else{
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new WebViewRedirect(value: downloadUrl,));
                    Navigator.of(context).push(route);
                  }
                  // Navigator.pop(context, Departments.Research);
                },
                child: Text(t),
              ),
              SimpleDialogOption(
                onPressed: () {

                  Fluttertoast.showToast(
                      msg: "Started Downloading your file..please wait",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 2,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);


                  BoughtMessages bought = new BoughtMessages(title, imageUrl, downloadUrl, type, extension, key);
                  auth.putMessageInDb(bought, uid).whenComplete(() async {
                    Fluttertoast.showToast(
                        msg: "File Downloaded",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 5,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);

                  }) ;
                  // Navigator.pop(context, Departments.Research);
                },
                child: Text("Download"),
              ),
            ],
          );
        });
  }

  Future<Departments> _asyncSimpleDialogDownLoaded(
      BuildContext context,
      String title,
      String downloadUrl,
      String imageUrl,
      String extension,
      String type,
      String key) async {
    if (type == "Audio") {
      t = "Listen";
    } else if (type == "Video") {
      t = "Watch";
    } else {
      t = "Read";
    }
    return await showDialog<Departments>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(title),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  if (type == "Audio") {
                    Map<String, String> data = new Map();
                    data["downloadUrl"] = downloadUrl;
                    data["image"] = imageUrl;
                    data["title"] = title;

                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new AudioApp(data: data));
                    Navigator.of(context).push(route);
                  } else if (type == "Video") {
                    Map<String, String> data = new Map();
                    data["downloadUrl"] = downloadUrl;
                    data["image"] = imageUrl;
                    data["title"] = title;
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new VideoApp(
                          data: data,
                        ));
                    Navigator.of(context).push(route);
                  }else{
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new WebViewRedirect(value: downloadUrl,));
                    Navigator.of(context).push(route);
                  }
                  // Navigator.pop(context, Departments.Research);
                },
                child: Text(t),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "Deleting your file..please wait",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 2,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);


                  BoughtMessages bought = new BoughtMessages(title, imageUrl, downloadUrl, type, extension, key);
                  auth.removeMessageInDb(bought.key, uid).whenComplete(() async {
                    Fluttertoast.showToast(
                        msg: "File Deleted",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 2,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);

                  }) ;
                  // Navigator.pop(context, Departments.Research);
                },
                child: Text("Delete"),
              ),
            ],
          );
        });
  }

  void getUid() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid;
    print(uid);

    // here you write the codes to input the data into firestore
  }

  void inputData() async {
    final prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('uid') ?? '';

    if (myString != null || myString != "") {
      uid = myString;
      _database
          .reference()
          .child("BoughtMessages")
          .child(uid)
          .onChildAdded
          .listen(_childAdded);
      _database
          .reference()
          .child("BoughtMessages")
          .child(uid)
          .onChildRemoved
          .listen(_childRemoves);
      _database
          .reference()
          .child("BoughtMessages")
          .child(uid)
          .onChildChanged
          .listen(_childChanged);


      _databaseDownloaded
          .reference()
          .child("Downloaded Messages")
          .child(uid)
          .onChildAdded
          .listen(_childAddedDownloaded);
      _databaseDownloaded
          .reference()
          .child("Downloaded Messages")
          .child(uid)
          .onChildRemoved
          .listen(_childRemovesDownloaded);
      _databaseDownloaded
          .reference()
          .child("Downloaded Messages")
          .child(uid)
          .onChildChanged
          .listen(_childChangedDownloaded);

      messages = FirebaseDatabase.instance
          .reference()
          .child("BoughtMessages")
          .child(uid);

      _databaseNew
          .reference()
          .child("BoughtMessages")
          .child(uid);


      downloaded = FirebaseDatabase.instance
          .reference()
          .child("Downloaded Messages")
          .child(uid);

      print(uid);
    } else {
      getUid();
      print("scam" + uid);
    }

    // here you write the codes to input the data into firestore
  }

  @override
  void initState() {
    auth = new Auth();
    isInternetConnected();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Size screenSize = MediaQuery.of(context).size;
    isInternetConnected();

    if(connected == "connected") {
      if (uid != null || uid != "") {
        return Scaffold(
            backgroundColor: Color(0xff3a3b54),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Bought Messages",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Container(
                        height: 300.0,
                        child: Flex(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Flexible(
                                child: FirebaseAnimatedList(
                                    query: messages,
                                    itemBuilder: (_, DataSnapshot snap,
                                        Animation<double> animation,
                                        int index) {
                                      if (snap.value != null) {
                                        BoughtMessages b =
                                        BoughtMessages.fromSnapshot(snap);
                                        list.add(b);
                                        print(list
                                            .asMap()
                                            .values
                                            .toList()[index]
                                            .downloadUrl);
                                        var type = "";

                                        var my_color_variable = Colors.blue;
                                        if (list
                                            .asMap()
                                            .values
                                            .toList()[index]
                                            .type ==
                                            "Audio") {
                                          type = 'Audio';
                                          my_color_variable = Colors.blue;
                                        } else if (list
                                            .asMap()
                                            .values
                                            .toList()[index]
                                            .type ==
                                            "Book") {
                                          type = 'Book';
                                          my_color_variable = Colors.green;
                                        } else {
                                          type = 'Video';
                                          my_color_variable = Colors.red;
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            _asyncSimpleDialog(
                                                context,
                                                list
                                                    .asMap()
                                                    .values
                                                    .toList()[index]
                                                    .title,
                                                list
                                                    .asMap()
                                                    .values
                                                    .toList()[index]
                                                    .downloadUrl,
                                                list
                                                    .asMap()
                                                    .values
                                                    .toList()[index]
                                                    .imageUrl,
                                                list
                                                    .asMap()
                                                    .values
                                                    .toList()[index]
                                                    .extension,
                                                list
                                                    .asMap()
                                                    .values
                                                    .toList()[index]
                                                    .type,
                                                list
                                                    .asMap()
                                                    .values
                                                    .toList()[index]
                                                    .key);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              width: 150.0,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    8.0),
                                                child: Banner(
                                                  location: BannerLocation
                                                      .topEnd,
                                                  color: my_color_variable,
                                                  message: type,
                                                  child: Card(
                                                    color: Color(0xff212238),
                                                    child: Wrap(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                          child: Center(
                                                              child: Image
                                                                  .network(
                                                                list
                                                                    .asMap()
                                                                    .values
                                                                    .toList()[index]
                                                                    .imageUrl,
                                                                height: 80.0,
                                                                width: 150.0,
                                                              )),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                          child: ListTile(
                                                            title: Text(
                                                              list
                                                                  .asMap()
                                                                  .values
                                                                  .toList()[index]
                                                                  .title,
                                                              textAlign:
                                                              TextAlign.center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10.0,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          color: Color(0xff3a3b54),

                                        );
                                      }
                                    }
                                )
                            ),
                          ],
                        )),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Downloaded Messages",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      child: Container(
                          height: screenSize.height / 2,
                          child: Flex(
                            direction: Axis.vertical,
                            children: <Widget>[
                              Flexible(
                                  child: FirebaseAnimatedList(
                                      query: downloaded,
                                      itemBuilder: (_, DataSnapshot snap,
                                          Animation<double> animation,
                                          int index) {
                                        if (snap.value != null) {
                                          BoughtMessages b =
                                          BoughtMessages.fromSnapshot(snap);
                                          list.add(b);
                                          print(list
                                              .asMap()
                                              .values
                                              .toList()[index]
                                              .downloadUrl);
                                          var type = "";

                                          var my_color_variable = Colors.blue;
                                          if (list
                                              .asMap()
                                              .values
                                              .toList()[index]
                                              .type ==
                                              "Audio") {
                                            type = 'Audio';
                                            my_color_variable = Colors.blue;
                                          } else if (list
                                              .asMap()
                                              .values
                                              .toList()[index]
                                              .type ==
                                              "Book") {
                                            type = 'Book';
                                            my_color_variable = Colors.green;
                                          } else {
                                            type = 'Video';
                                            my_color_variable = Colors.red;
                                          }

                                          return GestureDetector(
                                            onTap: () {
                                              _asyncSimpleDialogDownLoaded(
                                                  context,
                                                  list
                                                      .asMap()
                                                      .values
                                                      .toList()[index]
                                                      .title,
                                                  list
                                                      .asMap()
                                                      .values
                                                      .toList()[index]
                                                      .downloadUrl,
                                                  list
                                                      .asMap()
                                                      .values
                                                      .toList()[index]
                                                      .imageUrl,
                                                  list
                                                      .asMap()
                                                      .values
                                                      .toList()[index]
                                                      .extension,
                                                  list
                                                      .asMap()
                                                      .values
                                                      .toList()[index]
                                                      .type,
                                                  list
                                                      .asMap()
                                                      .values
                                                      .toList()[index]
                                                      .key);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  10.0),
                                              child: Container(
                                                width: 150.0,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      8.0),
                                                  child: Banner(
                                                    location: BannerLocation
                                                        .topEnd,
                                                    color: my_color_variable,
                                                    message: type,
                                                    child: Card(
                                                      color: Color(0xff212238),
                                                      child: Wrap(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                8.0),
                                                            child: Center(
                                                                child: Image
                                                                    .network(
                                                                  list
                                                                      .asMap()
                                                                      .values
                                                                      .toList()[index]
                                                                      .imageUrl,
                                                                  height: 80.0,
                                                                  width: 150.0,
                                                                )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 8.0),
                                                            child: ListTile(
                                                              title: Text(
                                                                list
                                                                    .asMap()
                                                                    .values
                                                                    .toList()[index]
                                                                    .title,
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 10.0,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return  Container(
                                            color: Color(0xff3a3b54),

                                          );
                                        }
                                      }
                                  )
                              ),
                            ],
                          )),
                    ),
                  )
                ],
              ),
            ));
      } else {
        return  Container(
          color: Color(0xff3a3b54),

        );
      }
    }else{
      return Container(
        color: Color(0xff3a3b54),

      );
    }


  }

  _childAdded(Event event) {
    setState(() {
      list.add(BoughtMessages.fromSnapshot(event.snapshot));
    });
  }

  void _childRemoves(Event event) {
    var deletedPost = list.singleWhere((BoughtMessages) {
      return BoughtMessages.key == event.snapshot.key;
    });

    setState(() {
      list.removeAt(list.indexOf(deletedPost));
    });
  }

  void _childChanged(Event event) {
    var changedPost = list.singleWhere((BoughtMessages) {
      return BoughtMessages.key == event.snapshot.key;
    });

    setState(() {
      list[list.indexOf(changedPost)] =
          BoughtMessages.fromSnapshot(event.snapshot);
    });
  }


  _childAddedDownloaded(Event event) {
    setState(() {
      list2.add(BoughtMessages.fromSnapshot(event.snapshot));
    });
  }

  void _childRemovesDownloaded(Event event) {
    var deletedPost = list2.singleWhere((BoughtMessages) {
      return BoughtMessages.key == event.snapshot.key;
    });

    setState(() {
      list2.removeAt(list2.indexOf(deletedPost));
    });
  }

  void _childChangedDownloaded(Event event) {
    var changedPost = list2.singleWhere((BoughtMessages) {
      return BoughtMessages.key == event.snapshot.key;
    });

    setState(() {
      list2[list2.indexOf(changedPost)] =
          BoughtMessages.fromSnapshot(event.snapshot);
    });
  }
}
