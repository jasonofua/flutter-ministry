import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iap/iap.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:salvation_ministries_library/Auth/auth.dart';
import 'package:salvation_ministries_library/Model/User.dart';
import 'package:salvation_ministries_library/welcome/Welcomepage.dart';
import 'package:flutter/scheduler.dart';
import 'package:salvation_ministries_library/Activities/DebitCardActivity.dart';
import 'package:salvation_ministries_library/Activities/UpdateProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum Departments { Call, Email }

class Profile extends StatefulWidget {
  @override
  State createState() => ProfileState();
}

class ExamplePurchaseProcessor extends SKPaymentTransactionObserver {
  /// Payment initiated by the user and is currently being processed.
  SKPayment _payment;
  Completer<SKPaymentTransaction> _completer;

  Future<SKPaymentTransaction> purchase(SKProduct product) {
    assert(_payment == null, 'There is already purchase in progress.');
    _payment = SKPayment.withProduct(product);
    _completer = Completer<SKPaymentTransaction>();
    StoreKit.instance.paymentQueue.addPayment(_payment);
    return _completer.future;
  }

  @override
  void didUpdateTransactions(
      SKPaymentQueue queue, List<SKPaymentTransaction> transactions) async {
    // Note that this method can be invoked by StoreKit even if there is no
    // active purchase initiated by the user (via [purchase] method), so
    // you should take this into account.
    // We only handle two states here (purchased and failed) and omit the rest
    // for brevity purposes.
    for (final tx in transactions) {
      switch (tx.transactionState) {
        case SKPaymentTransactionState.purchased:
          // Validate transaction, unlock content, etc...
          // Make sure to call `finishTransaction` when done, otherwise
          // this transaction will be redelivered by the queue on next application
          // launch.
          await queue.finishTransaction(tx);
          if (_payment == tx.payment) {
            // This transaction is related to an active purchase initiated
            // by user in UI. Signal it's been completed successfully.
            _completer.complete(tx);
            _payment = null;
            _completer = null;
          }
          break;
        case SKPaymentTransactionState.failed:
          // Purchase failed, make sure to notify the user in some way.
          await queue.finishTransaction(tx);
          if (_payment == tx.payment) {
            // This transaction is related to an active purchase as well.
            // Signal to the user that it failed. We pass the same transaction
            // object for simplicity here.
            _completer.completeError(tx);
            _payment = null;
            _completer = null;
          }
          break;
        default:
          // TODO: handle other states
          break;
      }
    }
  }
}

class ProfileState extends State<Profile> {
  String _imageUrl;
  String uidd;
  var messages;
  String name = "";
  BaseAuth auth;
  User userD;
  String uid = "";
  String wallet = "";
  int amount;
  String connected = "";
  String iap1 = "com.primedsoft.salvationmist.5points";
  String iap2 = "com.primedsoft.salvationmist.10points";
  String iap3 = "com.primedsoft.salvationmist.25points";
  String iap4 = "com.primedsoft.salvationmist.50points";
  String iap5 = "com.primedsoft.salvationmist.100points";

  bool available = true;

  final ExamplePurchaseProcessor _observer = ExamplePurchaseProcessor();
  bool _canMakePayments;

  SKProduct _product;

  //
  Future<SKPaymentTransaction> _purchaseFuture;

  //
  SKPaymentTransaction _transaction;

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

  void logOut() async {
    await FirebaseAuth.instance.signOut().then((_) {
      Fluttertoast.showToast(
          msg: "Signing you out.. please wait",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      var route = new MaterialPageRoute(
          builder: (BuildContext context) => new Welcomepage());
      Navigator.of(context).push(route);
    });
  }

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

  void inputData() async {
    final prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('uid') ?? '';

    if (myString != null || myString != "") {
      uidd = myString;
      userD = await auth.returnAUserDetail(uidd);
      name = userD.firstName + " " + userD.lastName;
      wallet = " ${userD.wallet.toString()} points";
      _imageUrl = userD.imageUrl;

      print(name);
      print(_imageUrl);
    } else {
      getUid();
      print("scam" + uidd);
    }

    // here you write the codes to input the data into firestore
  }

  void getFunding(String id) async {
    final productIds = [id];
    StoreKit.instance.products(productIds).then(_handleProducts);

    // here you write the codes to input the data into firestore
  }

  void getUid() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uidd = user.uid;
    print(uidd);
    userD = await auth.returnAUserDetail(uidd);
    name = userD.firstName + " " + userD.lastName;
    wallet = " ${userD.wallet.toString()} points";
    _imageUrl = userD.imageUrl;
    print(name);
    print(_imageUrl);

    // here you write the codes to input the data into firestore
  }

  @override
  void initState() {
    auth = new Auth();
    isInternetConnected();

    StoreKit.instance.paymentQueue.setTransactionObserver(_observer);
    // Check if user can actually make payments.
    // Note error-handling is omitted for brevity.
    StoreKit.instance.paymentQueue
        .canMakePayments()
        .then(_handleCanMakePayments);

    final FirebaseDatabase database =
        FirebaseDatabase(app: FirebaseDatabase.instance.app);
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    super.initState();
  }

  void _handleCanMakePayments(bool value) {
    setState(() {
      _canMakePayments = value;
    });
  }

  void _handleProducts(SKProductsResponse response) {
    // Note error-handling is omitted for brevity. If you have an issue with
    // your product it will appear in [response.invalidProductIds].
    setState(() {
      _product = response.products.single;
      _purchase();
    });
  }

  @override
  void dispose() {
    // Don't forget to remove your observer when your app state is rebuilding.
    StoreKit.instance.paymentQueue.removeTransactionObserver();
    super.dispose();
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
                            ? Image.network(
                                _imageUrl,
                                fit: BoxFit.cover,
                                width: 90.0,
                                height: 90.0,
                              )
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
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        wallet,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
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
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) =>
                                    new UpdateProfile(user: userD)));
                      },
                      textColor: Colors.white,
                      color: Colors.lightBlue,
                      child: const Text('Update Profile'),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ButtonTheme(
                  minWidth: 280.0,
                  height: 40.0,
                  child: RaisedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  height: 250,
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            amount = 5;
                                          });
                                          getFunding(iap1);

                                        },
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Buy 5 points",
                                              style: TextStyle(
                                                  color: Color(0xff3a3b54),
                                                  fontSize: 19),
                                            )),
                                      ),
                                      Divider(
                                        color: Color(0xff3a3b54),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            amount = 10;
                                          });
                                          getFunding(iap2);

                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Buy 10 points",
                                                style: TextStyle(
                                                    color: Color(0xff3a3b54),
                                                    fontSize: 19),
                                              )),
                                        ),
                                      ),
                                      Divider(
                                        color: Color(0xff3a3b54),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            amount = 25;
                                          });
                                          getFunding(iap3);

                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Buy 25 points",
                                                style: TextStyle(
                                                    color: Color(0xff3a3b54),
                                                    fontSize: 19),
                                              )),
                                        ),
                                      ),
                                      Divider(
                                        color: Color(0xff3a3b54),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            amount = 50;
                                          });
                                          getFunding(iap4);

                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Buy 50 points",
                                                style: TextStyle(
                                                    color: Color(0xff3a3b54),
                                                    fontSize: 19),
                                              )),
                                        ),
                                      ),
                                      Divider(
                                        color: Color(0xff3a3b54),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            amount = 100;
                                          });
                                          getFunding(iap5);

                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Buy 100 points",
                                                style: TextStyle(
                                                    color: Color(0xff3a3b54),
                                                    fontSize: 19),
                                              )),
                                        ),
                                      ),
                                      Divider(
                                        color: Color(0xff3a3b54),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });

                        // getFunding();
                      },
                      textColor: Colors.white,
                      color: Colors.lightBlue,
                      child: const Text('Fund Account'),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
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
                          onTap: () {},
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
                                builder: (BuildContext context) =>
                                    new CreditCardExample());
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

  void _purchase() {
    setState(() {
      _purchaseFuture = _observer.purchase(_product);
      _purchaseFuture.then(_handlePurchase).catchError(_handlePurchaseError);
    });
  }

  void _handlePurchase(SKPaymentTransaction tx) {
    setState(() {
      _transaction = tx;
      if (tx.transactionState ==
          SKPaymentTransactionState.purchased){
        auth.updateUserAmount(uidd, amount).whenComplete(() async {
          Fluttertoast.showToast(
              msg: "Purchase successful : ${_transaction.transactionState}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

        });


      }else{
         Fluttertoast.showToast(
             msg: "Purchase failed: ${_transaction.transactionState}",
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.CENTER,
             timeInSecForIos: 2,
             backgroundColor: Colors.red,
             textColor: Colors.white,
             fontSize: 16.0);
      }
      print(_transaction);
    });
  }

  void _handlePurchaseError(error) {
    if (error is SKPaymentTransaction) {
      setState(() {
        _transaction = error;
        print(error);
      });
    } else {
      setState(() {
        // TODO: set error state
      });
    }
  }
}
