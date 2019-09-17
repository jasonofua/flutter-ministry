import 'dart:async';
import 'package:salvation_ministries_library/Model/User.dart';
import 'package:salvation_ministries_library/Model/BoughtMessages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);

  Future<String> createUserWithEmailAndPassword(String email, String password);

  Future<void> putUserDetailsInDb(User user);

  Future<void> putMessageInDb(BoughtMessages user, String uid);
  Future<void> buyMessage(BoughtMessages user, String uid);
  Future<void> removeMessageInDb(String user, String uid);
  Future<void> updateUserAmount(String user, int amt);

  Future<String> getUserid();

  Future<void> logUserOut();

  Future<User> returnAUserDetail(String id);

  Future<void> deleteUser(FirebaseUser firebaseUser);
}

class Auth implements BaseAuth {
  @override
  Future<String> createUserWithEmailAndPassword(String email,
      String password) async {
    FirebaseUser user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  @override
  Future<String> getUserid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  @override
  Future<void> logUserOut() async {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> putUserDetailsInDb(User user) async {
    FirebaseDatabase firebaseDatabase = new FirebaseDatabase(
        app: FirebaseDatabase.instance.app,
        databaseURL: "https://grantie-2b757.firebaseio.com/");
    print("Firebase Link ******** " + firebaseDatabase.databaseURL +
        " ******** ");
//    firebaseDatabase.reference().child("Users").push().set(user);
//    Map<String, dynamic> map = new Map();
//    map["Users"] = user;
    return firebaseDatabase.reference().child("Users").child(user.id).set(
        user.toMap());
  }

  @override
  Future<void> putMessageInDb(BoughtMessages user,String uid) async {
    FirebaseDatabase firebaseDatabase = new FirebaseDatabase(
        app: FirebaseDatabase.instance.app,
        databaseURL: "https://grantie-2b757.firebaseio.com/");
    print("Firebase Link ******** " + firebaseDatabase.databaseURL +
        " ******** ");
//    firebaseDatabase.reference().child("Users").push().set(user);
//    Map<String, dynamic> map = new Map();
//    map["Users"] = user;
    return firebaseDatabase.reference().child("Downloaded Messages").child(uid).child(user.key).set(
        user.toMap());
  }

  @override
  Future<void> updateUserAmount(String user,int amt) async {
    FirebaseDatabase firebaseDatabase = new FirebaseDatabase(
        app: FirebaseDatabase.instance.app,
        databaseURL: "https://grantie-2b757.firebaseio.com/");
    print("Firebase Link ******** " + firebaseDatabase.databaseURL +
        " ******** ");
//    firebaseDatabase.reference().child("Users").push().set(user);
//    Map<String, dynamic> map = new Map();
//    map["Users"] = user;
    return firebaseDatabase.reference().child("Users").child(user).child("wallet").set(
        amt);
  }


  @override
  Future<void> buyMessage(BoughtMessages user,String uid) async {
    FirebaseDatabase firebaseDatabase = new FirebaseDatabase(
        app: FirebaseDatabase.instance.app,
        databaseURL: "https://grantie-2b757.firebaseio.com/");
    print("Firebase Link ******** " + firebaseDatabase.databaseURL +
        " ******** ");

    return firebaseDatabase.reference().child("BoughtMessages").child(uid).child(user.key).set(
        user.toMap());
  }


  @override
  Future<void> removeMessageInDb(String key,String uid) async {
    FirebaseDatabase firebaseDatabase = new FirebaseDatabase(
        app: FirebaseDatabase.instance.app,
        databaseURL: "https://grantie-2b757.firebaseio.com/");
    print("Firebase Link ******** " + firebaseDatabase.databaseURL +
        " ******** ");
//    firebaseDatabase.reference().child("Users").push().set(user);
//    Map<String, dynamic> map = new Map();
//    map["Users"] = user;
    return firebaseDatabase.reference().child("Downloaded Messages").child(uid).child(key).remove();
  }

  @override
  Future<String> signInWithEmailAndPassword(String email,
      String password) async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return firebaseUser.uid;
  }

  @override
  Future<User> returnAUserDetail(String id) async {
    FirebaseDatabase firebaseDatabase = new FirebaseDatabase(
        app: FirebaseDatabase.instance.app,
        databaseURL: "https://grantie-2b757.firebaseio.com/");
    DataSnapshot dataSnapshot = await firebaseDatabase.reference().child(
        "Users").child(id).once();
    return User.fromSnapshot(dataSnapshot);
//    return firebaseDatabase.reference().child("User").reference().child(id).once();
  }

  @override
  Future<void> deleteUser(FirebaseUser firebaseUser) {
    return firebaseUser.delete();
  }
}
