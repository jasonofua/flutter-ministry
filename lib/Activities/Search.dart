import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:salvation_ministries_library/Model/Message.dart';
import 'package:salvation_ministries_library/Activities/MessagesList.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Search extends StatefulWidget {
  @override
  State createState() => SearchState();
}

class SearchState extends State<Search> {
  var _searchview = new TextEditingController();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _query = "";
  List<String> _filterList;
  List<String> list;
  TextEditingController controller = new TextEditingController();
  String filter;
  Map<dynamic, dynamic> map;

  @override
  void initState() {
    list = new List();
    final FirebaseDatabase database =
    FirebaseDatabase(app: FirebaseDatabase.instance.app);
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    super.initState();

  }




  @override
  void dispose() {
    _searchview.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          //`true` if you want Flutter to automatically add Back Button when needed,
          //or `false` if you want to force your own back button every where
          title: Text('Search for your message'),
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
          )
      ),
      backgroundColor: Color(0xff3a3b54),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30.0,left: 10.0,right: 10.0),
          child: Container(
          decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new TextField(
           onChanged: (text){
             map.forEach((key, value) {

               print(key.toString());
               print(value.toString());

               if(text.isEmpty || text == ""){
                 print("not here");
               }else if(value["title"].contains(text)){
                 print(value["title"]);
               }else{
                 print(value["genre"]);
               }

             });
           },
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: new TextStyle(color: Colors.grey[300]),

            ),
            textAlign: TextAlign.start,
        ),
      ),
    ),
        ),
            Container(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: StreamBuilder(
                      stream: FirebaseDatabase.instance
                          .reference()
                          .child("Messages")
                          .onValue,
                      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                        if (snapshot.hasData) {
                         map = snapshot.data.snapshot.value;

                          if(snapshot.data.snapshot.value != null){

                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                              child: Container(
                                height: screenSize.height,
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
                                      "Buy NGN ${map.values.toList()[index]["priceNaira"]}";
                                    } else {
                                      currency =
                                      "Buy USD ${map.values.toList()[index]["priceDollar"]}";
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
                                                  onPressed: () {},
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
                          return CircularProgressIndicator();
                        }
                      }),
                )),


          ],
        ),
      ),
    );
  }
  Widget _createSearchView() {
    return new Container(
      decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: new TextField(
        controller: _searchview,
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: new TextStyle(color: Colors.grey[300]),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  //Perform actual search

}
