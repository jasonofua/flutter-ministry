import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salvation_ministries_library/theme/style.dart';
import 'style.dart';
import 'package:salvation_ministries_library/Auth/complete.dart';
import 'package:salvation_ministries_library/Buttons/textButton.dart';
import 'package:salvation_ministries_library/Buttons/roundedButton.dart';
import 'package:salvation_ministries_library/services/validations.dart';
import 'package:salvation_ministries_library/Auth/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Signup extends StatefulWidget {
  const Signup({Key key}) : super(key: key);

  @override
  SignupState createState() => new SignupState();
}

class SignupState extends State<Signup> {
  ProgressDialog pr;
  BuildContext context;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  bool autovalidate = false;
  Validations validations = new Validations();
  String _email;
  String _password;
   bool _isIos;

  _onPressed() {
    print("button clicked");
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
                    borderRadius: BorderRadius.circular(10.0)),
                child: new Container(
                  height: 50.0,
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

  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }



  void _handleSubmitted() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      print("Email: ${_email}");
      print("Password: ${_password}");
     _registerUser();
    }
  }

  void _registerUser() async{
    try {
      openProgressDialog();
      FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
      print("User Id: ${user.uid}");

      Fluttertoast.showToast(
          msg: "Welcome, your user id is ${user.uid}" ,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );

      var route = new MaterialPageRoute(
          builder: (BuildContext context) => new Complete(value: user.uid,));
      Navigator.of(context).push(route);

    }catch (e){


      if(_isIos){
        Fluttertoast.showToast(
            msg: e.details,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }else {
        Fluttertoast.showToast(
            msg: e.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }

    }
  }



  @override
  Widget build(BuildContext context) {
    this.context = context;
    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final Size screenSize = MediaQuery.of(context).size;

    //print(context.widget.toString());
    Validations validations = new Validations();
    return new Scaffold(
        key: _scaffoldKey,
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


                    SizedBox(
                      width: 300.0,
                      height: 200.0,
                      child: new   Padding(
                        padding: const EdgeInsets.only(left: 0.0,top: 0.0,right: 0.0,bottom: 0.0),
                        child: new Card(
                          color: Color.fromRGBO(255,255,255,0.7),
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                          child: new  Container(
                            height: screenSize.height / 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0,top: 0.0,right: 10.0,bottom: 0.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Form(
                                    key: formKey,
                                    autovalidate: autovalidate,
                                    child: new Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0,top: 10.0),
                                          child: new TextFormField(
                                            decoration: new InputDecoration(
                                              labelText: "Enter Email",
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius: new BorderRadius.circular(25.0),
                                                borderSide: new BorderSide(
                                                ),
                                              ),
                                            ),
                                            validator: validations.validateEmail,

                                            keyboardType: TextInputType.emailAddress,
                                            style: new TextStyle(
                                              fontFamily: "Poppins",
                                            ),
                                            onSaved:(value) => _email = value,

                                          ),
                                        ),


                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 20.0),
                                          child: new TextFormField(
                                            decoration: new InputDecoration(
                                              labelText: "Enter Password",
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius: new BorderRadius.circular(25.0),
                                                borderSide: new BorderSide(
                                                ),
                                              ),
                                            ),
                                            validator: validations.validatePassword,
                                            onSaved:(value) => _password = value,
                                            keyboardType: TextInputType.text,
                                            obscureText: true,
                                            style: new TextStyle(
                                              fontFamily: "Poppins",
                                            ),


                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ) ,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 40,
                        top: 5,
                        right: 40,
                        bottom: 0,
                      ),
                      child: new RoundedButton(
                        buttonName: "Sign up",
                        onTap: _handleSubmitted,
                        width: screenSize.width,
                        height: 50.0,
                        bottomMargin: 10.0,
                        borderWidth: 0.0,
                        buttonColor: Colors.lightBlue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          SizedBox(
                            height: 25.0,
                            child:  Center(
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                  },
                                  buttonName: "Already have an account? Login",
                                  buttonTextStyle:TextStyle(color: Colors.white,fontSize: 16.0,fontWeight:  FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    )


                  ],
                )
              ],
            )
    );
  }


}