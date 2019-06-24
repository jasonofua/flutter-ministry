import 'package:flutter/material.dart';
import 'welcome/Welcomepage.dart';

void main(){
  runApp(new MaterialApp(

    theme: ThemeData(primaryColor: Colors.green,accentColor: Colors.white),
    debugShowCheckedModeBanner: false,
    home: new Welcomepage(),

  ));
}