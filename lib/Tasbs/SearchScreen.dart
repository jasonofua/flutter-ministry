import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:salvation_ministries_library/Activities/MessagesList.dart';
import 'package:salvation_ministries_library/Activities/Search.dart';

class SearchScreen extends StatefulWidget {
  @override
  State createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database =
    FirebaseDatabase(app: FirebaseDatabase.instance.app);
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xff3a3b54),
        body: SingleChildScrollView(
          child: Container(
              child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: Container(
                    width: screenSize.width,
                    child: FlatButton.icon(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search()));
                        },
                        icon: Icon(FontAwesomeIcons.search),
                        label: Text("Search Messages")),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 140.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
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
                                    image:
                                        AssetImage("assets/image/word.png"),
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
                                    image:
                                        AssetImage('assets/image/fivenight.JPG'),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
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
                                    image:
                                        AssetImage('assets/image/power.png'),
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
                                    image:
                                        AssetImage('assets/image/praise.png'),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
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
                                    image:
                                        AssetImage('assets/image/success.png'),
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
                                    image:
                                        AssetImage('assets/image/family.png'),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
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
                                    image:
                                        AssetImage('assets/image/birth.png'),
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
                                    image:
                                        AssetImage('assets/image/faith.png'),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            Map<String, String> data = new Map();
                            data["name"] = "PROPERITY/FINANCE";
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
                                  "PROPERITY/FINANCE",
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
                                        AssetImage('assets/image/business.png'),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only( left: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "NEWS AND SPECIAL",
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
                child: StreamBuilder(
                    stream: FirebaseDatabase.instance
                        .reference()
                        .child("Special Offers")
                        .onValue,
                    builder: (BuildContext context, AsyncSnapshot<Event> snapshot){
                      if(snapshot.hasData){
                        Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

                        print( map.values.toList()[0]["imageUrl"].toString());

                        return Container(
                          height: 400.0,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 300.0,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: map.values.toList().length,
                                      itemBuilder: (BuildContext ctxt, int index){
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
                                                    Center(
                                                        child: Image.network(
                                                          map.values.toList()[index]
                                                          ["imageUrl"],
                                                          height: 150.0,
                                                          width: 250.0,
                                                        )),
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
                                          child: Column(
                                            children: <Widget>[
                                              Center(
                                                  child: Image.network(
                                                    map.values.toList()[index]
                                                    ["imageUrl"],
                                                    height: 200.0,
                                                    width: 250.0,
                                                  )),
                                            ],
                                          ),
                                        );

                                      }),
                                ),
                              ),
                            ],
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
                                  child: Text("No Message For the Genre",style: TextStyle(color: Colors.white, fontSize: 18.0,))
                                ),
                                CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        );
                      }


                    }),
              )

            ],
          )
          ),
        )
    );
  }
}
