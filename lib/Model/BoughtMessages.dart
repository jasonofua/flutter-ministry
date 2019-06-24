import 'package:firebase_database/firebase_database.dart';

class BoughtMessages {
  String title;
  String imageUrl;
  String downloadUrl;
  String type;
  String extension;
  String key;

  static const KEY = "key";
  static const TITLE = "title";
  static const DOWNLOAD = "downloadUrl";
  static const TYPE = "type";
  static const EXTENSION = "extension";
  static const IMAGEURL = "imageUrl";
  BoughtMessages(this.title,this.imageUrl,this.downloadUrl,this.type,this.extension,this.key);

  BoughtMessages.fromSnapshot(DataSnapshot snap){
    this.title=snap.value['messageTitle'];
    this.imageUrl=snap.value['messageImageUrl'];
    this.downloadUrl=snap.value['messageDownloadUrl'];
    this.type=snap.value['type'];
    this.extension=snap.value['extension'];
    this.key=snap.key;

  }

  Map toMap(){
    return {TITLE: title, DOWNLOAD: downloadUrl, IMAGEURL: imageUrl, EXTENSION: extension,TYPE: type,KEY: key};
  }
}