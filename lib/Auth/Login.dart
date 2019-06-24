import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salvation_ministries_library/Auth/auth.dart';
import 'package:salvation_ministries_library/Auth/index.dart';

enum AuthStatus { signedIn, notSignedIn }
class Login extends StatefulWidget{

  @override
  State createState() => LoginState();

}

class LoginState extends State<Login>{
  AuthStatus _authStatus = AuthStatus.notSignedIn;
  String id;
  bool isLoading = false;
  BaseAuth auth;
  @override
  void initState() {
    super.initState();
    auth = new Auth();
  }


  openProgressDialog(
      {String text: "Loading..",
        Color themeColor: Colors.white70,
        Color progressBarColor: Colors.blueAccent,
        Color textColor: Colors.blue}) =>
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => Theme(
              data: Theme.of(context).copyWith(primaryColor: Colors.pink),
              child: new Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: new Container(
                  height: 100.0,
                  color: themeColor,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        child: new Text(
                          text,
                          style:
                          new TextStyle(color: textColor, fontSize: 20.0),
                        ),
                        margin: EdgeInsets.only(left: 20.0),
                      ),
                      new CircularProgressIndicator(
                        backgroundColor: progressBarColor,
                      )
                    ],
                  ),
                ),
              )));
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Teachable",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Login Checkpoint",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Image.asset(
                                'assets/image/imgone.png',
                                height: 200.0,
                                width: 300.0,
                              ),
                              Positioned(
                                  child: Text("Teacher",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold))
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,  MaterialPageRoute(builder: (context) => LoginScreen()));
                                },

                              )
                            ],

                          ),

                          //   child:
                        ),
                        Expanded(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Image.asset(
                                'assets/image/imgtwo.png',
                                height: 200.0,
                                width: 300.0,
                              ),
                              Positioned(
                                  child: Text("School",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                          //   child:
                        ),
                        Expanded(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Image.asset('assets/image/imgthree.png',
                                  height: 200.0, width: 300.0),
                              Positioned(
                                  child: Text("Individual",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                          //   child:
                        ),
                      ],
                    )),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }

}