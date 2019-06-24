import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  State createState() => RegisterState();
}

class RegisterState extends State<Register> {
  @override
  void initState() {
    super.initState();
  }

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
                        "Registration Checkpoint",
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
