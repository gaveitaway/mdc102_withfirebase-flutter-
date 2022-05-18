import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/product.dart';
import 'detail.dart';
import 'constant/firebase_constant.dart';

var firebase = FirebaseFirestore.instance;

class CrudFunction {
  var productRef = firebase.collection("product");
  var userRef = firebase.collection("user");
  Future<void> addProduct(String image, String uid, String name, int price,
      String description) async {
    productRef.add({
      "image": image,
      "uid": uid,
      "name": name,
      "price": price,
      "description": description,
      "thumbUp": [],
      "addtimestamp": FieldValue.serverTimestamp(),
      "updatetimestamp":FieldValue.serverTimestamp(),
    }).then((value) {
      productRef.doc(value.id).update({"id": value.id});
    });
  }

  Future<void> deleteProduct(String id) async {
    productRef.doc(id).delete();
  }

  Future<void> addGoogleUser(String email, String name, String uid) async {
    userRef.add({
      "email": email,
      "name": name,
      "status_maessage": "I promise to take the test honestly before God",
      "uid": uid,
    }).then((value) {
      userRef.doc(value.id).update({"id": value.id});
    });
  }

  Future<void> addAnonyUser(String uid) async {
    userRef.add({
      "status_maessage": "I promise to take the test honestly before God",
      "uid": uid,
    }).then((value) {
      userRef.doc(value.id).update({"id": value.id});
    });
  }

  Future<void> updateProduct(String image, String uid, String name, int price,
      String description, String id, String timestamp) async {
    productRef.doc(id).update({
      "image": image,
      "uid": uid,
      "name": name,
      "price": price,
      "description": description,
      "timestamp": timestamp,
      "updatetimestamp": FieldValue.serverTimestamp(),

    });
  }

  Future<void> thumbUpOne(String uid, String id) async {
    productRef.doc(id).update({
      "thumbUp": FieldValue.arrayUnion([uid]),
    });
  }

  Stream<List<Product>> productStream() {
    return productRef.snapshots().map((value) => value.docs
        .map((element) => Product(
              image: element.data()['image'],
              uid: element.data()["uid"],
              price: element.data()["price"],
              name: element.data()["name"],
              description: element.data()["description"],
              id: element.data()["id"],
              thumbUp: element.data()["thumbUp"],
              addtimestamp: element.data()["addtimestamp"],
              updatetimestamp: element.data()["updatetimestamp"],

    ))
        .toList());
  }

  // Stream<List<user>> userStream() {
  //   return userRef.snapshots().map((value) => value.docs
  //       .map((element) => user(
  //     name: element.data()['name'],
  //     uid: element.data()["uid"],
  //     email: element.data()["email"],
  //     status_message: element.data()["status_message"],
  //   ))
  //       .toList());
  // }

  Stream<DocumentSnapshot> productStreamOne(String id) {
    return productRef.doc(id).snapshots();
  }
}
