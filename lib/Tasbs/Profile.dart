import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salvation_ministries_library/Auth/auth.dart';
import 'package:salvation_ministries_library/Model/User.dart';
import 'package:salvation_ministries_library/welcome/Welcomepage.dart';
import 'package:flutter/scheduler.dart';
import 'package:salvation_ministries_library/Activities/DebitCardActivity.dart';
import 'package:salvation_ministries_library/Activities/UpdateProfile.dart';
import 'package:url_launcher/url_launcher.dart';

enum Departments { Call, Email}
class Profile extends  StatefulWidget {
  @override
  State createState() => ProfileState();
}
class ProfileState extends State<Profile>{
  String _imageUrl;
  String uidd;
  var messages;
  String name = "";
  BaseAuth auth;
  User userD;




Future<Departments> _asyncSimpleDialog(BuildContext context) async {
  return await showDialog<Departments>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Help '),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                launch('tel:+234 0809 521 6466');
               // Navigator.pop(context, Departments.Production);
              },
              child: const Text('Call Us'),
            ),
            SimpleDialogOption(
              onPressed: () {
                launch('mailto:knowledge@smhos.org?subject=Help needed');
               // Navigator.pop(context, Departments.Research);
              },
              child: const Text('Email Us'),
            ),

          ],
        );
      });
}
  void logOut()async{
    await FirebaseAuth.instance.signOut().then((_){
      Fluttertoast.showToast(
          msg: "Signing you out.. please wait",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      var route = new MaterialPageRoute(
          builder: (BuildContext context) => new Welcomepage());
      Navigator.of(context).push(route);

    });

  }

  void inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uidd = user.uid;
    print(uidd);
    userD = await auth.returnAUserDetail(uidd);
    name = userD.firstName + " "+ userD.lastName;
    _imageUrl = userD.imageUrl;
    print(name);
    print(_imageUrl);

    // here you write the codes to input the data into firestore
  }

  @override
  void initState(){
    auth = new Auth();
    inputData();
    final FirebaseDatabase database =
    FirebaseDatabase(app: FirebaseDatabase.instance.app);
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    inputData();
    return Scaffold(
        backgroundColor: Color(0xff3a3b54),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                 Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: CircleAvatar(
                        radius: 50,

                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: SizedBox(
                            width: 140.0,
                            height: 140.0,

                            child: (_imageUrl != null)
                                ? Image.network(_imageUrl, fit: BoxFit.cover,
                              width: 90.0,
                              height: 90.0,)
                                : Image.network(
                              "https://banner2.kisspng.com/20180403/bkq/kisspng-computer-icons-symbol-avatar-logo-clip-art-person-with-helmut-5ac35496b2daa3.1580708315227506147326.jpg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only( left: 8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ButtonTheme(
                    minWidth: 280.0,
                    height: 40.0,

                    child :  RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (__) => new UpdateProfile(user:userD)));

                        },
                        textColor: Colors.white,
                        color: Colors.lightBlue,
                        child: const Text('Update Profile'),
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 16.0),
                          child: GestureDetector(
                            onTap: () {


                            },
                            child: Text(
                              "INVITE FRIENDS",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 16.0),
                          child: GestureDetector(
                            onTap: () {
                                _asyncSimpleDialog(context);
                            },
                            child: Text(
                              "HELP",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              var route = new MaterialPageRoute(
                                  builder: (BuildContext context) => new CreditCardExample());
                              Navigator.of(context).push(route);
                            },
                            child: Text(
                              "ADD A DEBIT CARD",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 16.0),
                          child: GestureDetector(
                            onTap: () {
                                logOut();
                            },
                            child: Text(
                              "LOGOUT",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
            ),
        ),
        );
  }


}