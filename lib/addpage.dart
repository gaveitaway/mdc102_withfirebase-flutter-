import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shrine/crud_function.dart';
import 'package:image_picker/image_picker.dart';
import 'crud_function.dart';
import 'constant/firebase_constant.dart';

class addpage extends StatefulWidget {
  @override
  State<addpage> createState() => _addpageState();
}

class _addpageState extends State<addpage> {
  var crudFunction = CrudFunction();
  var productnameController = TextEditingController();
  var PriceController = TextEditingController();
  var DescriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  String imagePath =
      "/data/user/0/com.example.shrine/cache/image_picker6587986818416015194.png";
  Future getImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = image!.path;
    });
  }

  Future uploadImage(String fileName) async {
    File file = File(imagePath);
    await firebaseStorage.ref().child(fileName).putFile(file);
  }
  String servertime= FieldValue.serverTimestamp().toString();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          child: TextButton(
            child: Text('Cancel'),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ),
        title: Center(child: const Text('Add')),
        actions: <Widget>[
          TextButton(
            child: Text('Save'),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: () async {
              await uploadImage(productnameController.text);
              String url = await firebaseStorage
                  .ref()
                  .child(productnameController.text)
                  .getDownloadURL();
              await crudFunction.addProduct(
                  url,
                  firebaseAuth.currentUser!.uid,
                  productnameController.text,
                  int.parse(PriceController.text),
                  DescriptionController.text,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          Image.file(File(imagePath)),
          IconButton(
              icon: const Icon(
                Icons.camera_alt,
              ),
              onPressed: () {
                getImage();
              }),
          const SizedBox(height: 12.0),
          TextFormField(
            controller: productnameController,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'ProductName',
            ),
          ),
          TextFormField(
            controller: PriceController,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Price',
            ),
          ),
          TextFormField(
            controller: DescriptionController,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Description',
            ),
          ),
        ],
      ),
    );
  }
}
