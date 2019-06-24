import 'package:flutter/material.dart';
import 'package:salvation_ministries_library/Auth/Register.dart';
import 'package:salvation_ministries_library/Auth/Signup.dart';
import 'package:salvation_ministries_library/Auth/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salvation_ministries_library/Activities/Home.dart';


class Welcomepage extends StatefulWidget{
  @override
  State createState() => WelcomepageState();

}

class WelcomepageState extends State<Welcomepage>{
  bool isLoggedIn;
  @override
    void initState(){

    isLoggedIn = false;
    FirebaseAuth.instance.currentUser().then((user) => user != null
        ? setState(() {
      isLoggedIn = true;
    })
        : null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  isLoggedIn ? new MyApp() :  Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(image: DecorationImage(
                image: AssetImage('assets/image/bg.png'),fit: BoxFit.fill)
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Text("SALVATION MINISTRIES", textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 30.0,fontWeight:  FontWeight.bold),),
                      Text("Digital Library", textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 30.0,fontFamily: 'blacksword'),),

                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(bottom: 20.0),),
                      ButtonTheme(
                        minWidth: 280.0,
                        height: 40.0,

                        child :  RaisedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                            },
                            textColor: Colors.white,
                            color: Colors.lightBlue,
                            child: const Text('Register'),
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                        ),
                      ),


                      ButtonTheme(
                        minWidth: 280.0,
                        height: 40.0,

                        child :  RaisedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            },
                            textColor: Colors.white,
                            color: Colors.lightBlue,
                            child: const Text('Log in'),
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                        ),
                      ),

                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ) ;

  }


}