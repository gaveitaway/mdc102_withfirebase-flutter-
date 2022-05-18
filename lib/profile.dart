import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constant/firebase_constant.dart';
import 'dart:io';

class profilepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            }),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.exit_to_app,
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/login');
              }),
        ],
      ),
      body: (!firebaseAuth.currentUser!.isAnonymous)
          ? Center(
            child: ListView(
                children: <Widget>[
                  Image.network(firebaseAuth.currentUser!.photoURL!),
                  Text("<" + firebaseAuth.currentUser!.uid + ">"),
                  Divider(thickness: 1, height: 1, color: Colors.blue),
                  Text(firebaseAuth.currentUser!.email!),
                  Text("KimMinsoo"),
                  SizedBox(height:20),
                  Text("I promise to take the test honestly before God"),
                  TextButton(
                    child: Text('Edit'),
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    onPressed: () {
                    },
                  ),
                ],
              ),
          )
          : Center(
            child: ListView(children: [
                Image.file(File(
                    "/data/user/0/com.example.shrine/cache/image_picker6587986818416015194.png")),
                Text("<" + firebaseAuth.currentUser!.uid + ">"),
              Divider(thickness: 1, height: 1, color: Colors.blue),

              Text("Anonymous"),
                Text("KimMinsoo"),
              SizedBox(height:20),

              Text("I promise to take the test honestly before God"),
              TextButton(
                child: Text('Edit'),
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                ),
                onPressed: () {
                },
              ),
              ]

            ),
          ),
    );
  }
}
