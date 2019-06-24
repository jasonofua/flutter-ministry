import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class Message {
  String author;
  String downloadUrl;
  String exetension;
  String genre;
  String imageUrl;
  String key;
  String priceDollar;
  String priceNaira;
  String title;
  String type;

  Message(this.author,this.downloadUrl,this.exetension,this.genre,this.imageUrl,this.key,this.priceDollar,this.priceNaira,this.title,this.type);

  Message.fromJson(var value){
    this.author=value['author'];
    this.downloadUrl=value['downloadUrl'];
    this.exetension=value['exetension'];
    this.genre=value['genre'];
    this.imageUrl=value['imageUrl'];
    this.key=value['key'];
    this.priceDollar=value['priceDollar'];
    this.priceNaira=value['priceNaira'];
    this.title=value['title'];
    this.type=value['type'];

  }

  Message.fromSnapshot(AsyncSnapshot<Event> snapshot){
    this.author=snapshot.data.snapshot.value['author'];
    this.downloadUrl=snapshot.data.snapshot.value['downloadUrl'];
    this.exetension=snapshot.data.snapshot.value['exetension'];
    this.genre=snapshot.data.snapshot.value['genre'];
    this.imageUrl=snapshot.data.snapshot.value['imageUrl'];
    this.key=snapshot.data.snapshot.value['key'];
    this.priceDollar=snapshot.data.snapshot.value['priceDollar'];
    this.priceNaira=snapshot.data.snapshot.value['priceNaira'];
    this.title=snapshot.data.snapshot.value['title'];
    this.type=snapshot.data.snapshot.value['type'];
  }
}