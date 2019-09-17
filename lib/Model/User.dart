
import 'package:firebase_database/firebase_database.dart';

class User{
  String id,
      firstName,
      lastName,
      title,
      region,
      imageUrl,
      currency,
      status;

  int wallet;

  User(
      {
        this.id,
        this.firstName,
        this.lastName,
        this.title,
        this.region,
        this.imageUrl,
        this.currency,
        this.status,
        this.wallet});

  Map<String, dynamic> toMap() => {
    "id":id,
    "firstName": firstName,
    "lastName": lastName,
    "title": title,
    "region": region,
    "mImageUrl": imageUrl,
    "currency": currency,
    "status": status,
    "wallet": wallet
  };

  User.map(dynamic obj) {
    this.id = obj["id"];
    this.firstName = obj["firstName"];
    this.lastName = obj["lastName"];
    this.region = obj["region"];
    this.imageUrl = obj["mImageUrl"];
    this.currency = obj["currency"];
    this.title = obj["title"];
    this.status = obj["status"];
    this.wallet = obj["wallet"];
  }

  User.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.value["id"];
    firstName = snapshot.value["firstName"];
    lastName = snapshot.value["lastName"];
    region = snapshot.value["region"];
    imageUrl = snapshot.value["mImageUrl"];
    currency = snapshot.value["currency"];
    title = snapshot.value["title"];
    status = snapshot.value["status"];
    wallet = snapshot.value["wallet"];
  }


}