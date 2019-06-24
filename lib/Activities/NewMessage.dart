import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:salvation_ministries_library/Activities/WebViewRedirect.dart';
import 'package:salvation_ministries_library/Model/Message.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewMessage extends StatefulWidget {

  Map<String,String> data = new Map();

  NewMessage({Key key, this.data}) : super(key: key);



  @override
  State createState() => NewMessageState();
}

class NewMessageState extends State< NewMessage> {
  List<Message> list = new List();

  var messages;



  @override
  void initState() {

    final FirebaseDatabase database =
    FirebaseDatabase(app: FirebaseDatabase.instance.app);
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

     messages = FirebaseDatabase.instance
        .reference()
        .child('Messages')
        .limitToFirst(20);
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

                return Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: map.values.toList().length,
                    padding: EdgeInsets.all(2.0),
                    itemBuilder: (BuildContext context, int index) {
                      var type = "";
                      var currency = "";
                      var my_color_variable = Colors.blue;

                      if (map.values.toList()[index]["currency"] ==
                          "naira") {
                        currency =
                        "Buy USD ${map.values.toList()[index]["priceDollar"]}";
                      } else {
                        currency =
                        "Buy NGN ${map.values.toList()[index]["priceNaira"]}";

                      }


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
                                      currency,
                                      style: TextStyle(
                                          color: Color(0xff3a3b54),
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      var route = new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                          new WebViewRedirect(value: "https://staging.payu.co.za/rpp.do?PayUReference=%7Bpayureference%7D",));
                                      Navigator.of(context).push(route);
                                    },
                                    borderSide:
                                    BorderSide(color: Colors.amber),
                                    shape: StadiumBorder(),
                                  )
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
