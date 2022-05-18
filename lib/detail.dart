import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shrine/constant/firebase_constant.dart';
import 'model/product.dart';
import 'constant/firebase_constant.dart';
import 'crud_function.dart';

class detailpage extends StatelessWidget {
  static FieldValue serverTimestamp() => FieldValue.serverTimestamp();
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context)!.settings.arguments as Product;
    // user User = ModalRoute.of(context)!.settings.arguments as use
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        title: Center(child: const Text('Detail')),
        actions: <Widget>[
          TextButton(
            child: const Text('Save'),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.create,
            ),
            onPressed: () {
              if (firebaseAuth.currentUser!.uid == product.uid) {
                Navigator.pushNamed(context, '/fourth', arguments: product);
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () {
              if (firebaseAuth.currentUser!.uid == product.uid) {
                crudFunction.deleteProduct(product.id);
                Navigator.pushNamed(context, '/');
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: [ StreamBuilder<DocumentSnapshot>(
            stream: crudFunction.productStreamOne(product.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot<Map> k = snapshot.data as DocumentSnapshot<Map>;
                Product myProduct = Product(
                  image: k.data()!['image'],
                  uid: k.data()!["uid"],
                  price: k.data()!["price"],
                  name: k.data()!["name"],
                  description: k.data()!["description"],
                  id: k.data()!["id"],
                  thumbUp: k.data()!["thumbUp"],
                  addtimestamp: k.data()!["addtimestamp"],
                  updatetimestamp: k.data()!["updatetimestamp"],
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(myProduct.image),
                    Row(
                      children: [
                        SizedBox(width: 150),
                        Column(
                          children: [
                            Text(myProduct.name),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  size: 15,
                                ),
                                Text(myProduct.price.toString()),
                              ],
                            ),
                          ],
                        ),
                        Center(
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.thumb_up,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  if (myProduct.thumbUp
                                      .contains(firebaseAuth.currentUser!.uid)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("You can only do it once")),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("I Like it !")),
                                    );
                                  }
                                  crudFunction.thumbUpOne(
                                      firebaseAuth.currentUser!.uid,
                                      myProduct.id);
                                },
                              ),
                              Text(myProduct.thumbUp.length.toString()),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 1, height: 1, color: Colors.blue),
                    SizedBox(height: 20),
                    Text(myProduct.description),
                    SizedBox(height: 150),
                    //Text("${k.data!["addtimestamp"].toDate()} Created")
                    Text("Creater: <  " + myProduct.uid + " > "),
                    Text(
                        myProduct.addtimestamp.toDate().toString() + "  Created"),
                    Text(myProduct.updatetimestamp.toDate().toString() +
                        "  Modified"),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
        ],

      ),
    );
  }
}
