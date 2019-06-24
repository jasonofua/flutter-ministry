import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salvation_ministries_library/Buttons/roundedButton.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:salvation_ministries_library/Model/User.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_format/date_format.dart';
import 'package:salvation_ministries_library/Auth/auth.dart';
import 'package:salvation_ministries_library/services/validations.dart';
import 'package:salvation_ministries_library/Activities/Home.dart';

enum AuthStatus { signedIn, notSignedIn }
class UpdateProfile extends StatefulWidget {
  User user;

  UpdateProfile({Key key, this.user}) : super(key: key);

  @override
  State createState() => UpdateProfileState();


}

class UpdateProfileState extends State<UpdateProfile> {
  BuildContext context;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  bool autovalidate = false;
  Validations validations = new Validations();
  AuthStatus _authStatus = AuthStatus.notSignedIn;
  BaseAuth auth;

  final List<String> _Title = [
    "Mr",
    "Mrs",
    "Brother",
    "Sister",
    "Pastor",
    "Deacon",
    "Deaconess"
  ];

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

  String selected = "Title";
  Country _selected;
  bool _isIos;
  File _image;
  String _title;
  String _region;
  String _currency;
  String _firstName;
  String _lastName;
  String _imageUrl;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future _handleSubmitted(BuildContext context) async {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      openProgressDialog();
      DateTime now = new DateTime.now();
      String datestamp = formatDate(now, [yyyy, '-', mm, '-', dd]);
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child("uploads").child(datestamp);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      var img = await (await uploadTask.onComplete).ref.getDownloadURL();
      _imageUrl = img.toString();
      print(_imageUrl);
      _region == "Nigeria" ? _currency = "naira" : _currency = "dollars";

      User user = User(
          id: widget.user.id,
          firstName: _firstName,
          lastName: _lastName,
          title: _title,
          region: _region,
          imageUrl: _imageUrl,
          currency: _currency,
          status: "user");

      print(_imageUrl);
      print(_title);
      print(_region);
      if (widget.user.id != null) {
        auth.putUserDetailsInDb(user).whenComplete(() async {
          User userD = await auth.returnAUserDetail(widget.user.id);
          if (userD != null) {
            print("value != null oooooh --- ");
            setState(() {
              _authStatus = AuthStatus.signedIn;
            });

            var route = new MaterialPageRoute(
                builder: (BuildContext context) => new MyApp());
            Navigator.of(context).push(route);
          } else {
//          Navigator.pop(context);
            print("User == null oooh");

            setState(() async {
              _authStatus = AuthStatus.notSignedIn;
              auth.deleteUser(await FirebaseAuth.instance.currentUser());
            });
          }
        });
      }

    }
  }

  @override
  void initState() {
    super.initState();
    auth = new Auth();
    selected = widget.user.title;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    this.context = context;
    Future openImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print("Image path ${_image.path}");
      });
    }

    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            //`true` if you want Flutter to automatically add Back Button when needed,
            //or `false` if you want to force your own back button every where
            title: Text('Update profile'),
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context, false),
            )
        ),
        body: Builder(
            builder: (context) => Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Color(0xff476cfb),
                              child: ClipOval(
                                child: SizedBox(
                                  width: 140.0,
                                  height: 140.0,
                                  child: (_image != null)
                                      ? Image.file(_image, fit: BoxFit.fill)
                                      : Image.network(
                                        widget.user.imageUrl,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.camera,
                                size: 20.0,
                              ),
                              onPressed: () {
                                openImage();
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Form(
                                      key: formKey,
                                      autovalidate: autovalidate,
                                      child: new Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0, top: 10.0),
                                            child: new TextFormField(
                                              decoration:
                                              new InputDecoration(
                                                labelText: widget.user.firstName,
                                                fillColor: Colors.white,
                                                border:
                                                new OutlineInputBorder(
                                                  borderRadius:
                                                  new BorderRadius
                                                      .circular(25.0),
                                                  borderSide:
                                                  new BorderSide(),
                                                ),
                                              ),
                                              onSaved: (value) =>
                                              _firstName = value,
                                              keyboardType:
                                              TextInputType.text,
                                              style: new TextStyle(
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20.0),
                                            child: new TextFormField(
                                              decoration:
                                              new InputDecoration(
                                                labelText: widget.user.lastName,
                                                fillColor: Colors.white,
                                                border:
                                                new OutlineInputBorder(
                                                  borderRadius:
                                                  new BorderRadius
                                                      .circular(25.0),
                                                  borderSide:
                                                  new BorderSide(),
                                                ),
                                              ),
                                              onSaved: (value) =>
                                              _lastName = value,
                                              keyboardType:
                                              TextInputType.text,
                                              style: new TextStyle(
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300.0,
                                            child: Container(
                                              child: DropdownButton(
                                                items: _Title.map((value) =>
                                                    DropdownMenuItem(
                                                      child: Text(value),
                                                      value: value,
                                                    )).toList(),
                                                onChanged: (String value) {
                                                  selected = value;
                                                  _title = selected;
                                                  setState(() =>
                                                  selected = value);
                                                },
                                                isExpanded: false,
                                                hint: Text(selected),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: SizedBox(
                                              width: 300.0,
                                              child: Container(
                                                child: CountryPicker(
                                                  showDialingCode: false,
                                                  showFlag: true,
                                                  showName: true,
                                                  onChanged:
                                                      (Country country) {
                                                    setState(() {
                                                      _region = country.name;
                                                      _selected = country;
                                                    });
                                                  },
                                                  selectedCountry: _selected,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: SizedBox(
                                              width: 300.0,
                                              child: Container(
                                                child: ButtonTheme(
                                                  minWidth: 280.0,
                                                  height: 40.0,
                                                  child: RaisedButton(
                                                      onPressed: () {
                                                        _handleSubmitted(
                                                            context);
                                                      },
                                                      textColor:
                                                      Colors.white,
                                                      color:
                                                      Colors.lightBlue,
                                                      child: const Text(
                                                          'Update Profile'),
                                                      shape: new RoundedRectangleBorder(
                                                          borderRadius:
                                                          new BorderRadius
                                                              .circular(
                                                              30.0))),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
