import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Product {
  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.uid,
    required this.image,
    required this.id,
    required this.thumbUp,
    required this.addtimestamp,
    required this.updatetimestamp,


  });

  String name;
  int price;
  String description;
  String uid;
  String image;
  String id;
  List thumbUp;
  Timestamp addtimestamp;
  Timestamp updatetimestamp;

}
class user {
  user({
    required this.name,
    required this.uid,
    required this.email,
    required this.status_message,


  });

  String name;
  String uid;
  String email;
  String status_message;
}


class loginjudge with ChangeNotifier{
   int loginkind;
  loginjudge({required this.loginkind});
  void googlelogin(){
    loginkind = 1;
    notifyListeners();
  }
  void anonylogin(){
    loginkind = 0;
    notifyListeners();
  }
}