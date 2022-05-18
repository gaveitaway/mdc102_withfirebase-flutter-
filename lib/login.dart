// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shrine/constant/firebase_constant.dart';
import 'package:provider/provider.dart';
import 'model/product.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<User?> signInAnonymous() async {
    try {
      UserCredential res = await firebaseAuth.signInAnonymously();
      User? user = res.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await firebaseAuth.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              const SizedBox(height: 80.0),
              Column(
                children: <Widget>[
                  Image.asset('assets/diamond.png'),
                  const SizedBox(height: 16.0),
                  const Text('SHRINE'),
                ],
              ),
              const SizedBox(height: 120.0),
              // TODO: Remove filled: true values (103)

              const SizedBox(height: 12.0),
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Provider.of<loginjudge>(context,listen: false).googlelogin();
                        signInWithGoogle().then((value) {
                          if (value.additionalUserInfo!.isNewUser) {
                            crudFunction.addGoogleUser(
                              firebaseAuth.currentUser!.email!,
                              firebaseAuth.currentUser!.displayName!,
                              firebaseAuth.currentUser!.uid,
                            );
                          }
                          Navigator.pushNamed(
                            context,
                            '/',
                          );
                        });

                      },
                      child: Text("Google Login"))
                ],
              )),
              const SizedBox(height: 12.0),
              Center(

                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Provider.of<loginjudge>(context,listen: false).anonylogin();
                        signInAnonymous().then((value) {
                          crudFunction
                              .addAnonyUser(firebaseAuth.currentUser!.uid);
                          Navigator.pushNamed(
                            context,
                            '/',
                          );
                        });

                      },
                      child: Text("Anonymous Login"))
                ],
              )),
            ],
          ),
        ),
      );
  }
}
