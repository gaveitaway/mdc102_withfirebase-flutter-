import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shrine/constant/firebase_constant.dart';
import 'model/product.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class updatepage extends StatefulWidget {
  @override
  State<updatepage> createState() => _updatepageState();
}

class _updatepageState extends State<updatepage> {
  var productnameController = TextEditingController();

  var PriceController = TextEditingController();

  var DescriptionController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  int flag = 1;
  String imagePath =
      "/data/user/0/com.example.shrine/cache/image_picker6587986818416015194.png";
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context)!.settings.arguments as Product;
    productnameController.text = product.name;
    PriceController.text = product.price.toString();
    DescriptionController.text = product.description;
    String imagePath1 = product.image;
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
        title: Center(child: const Text('Edit')),
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
              await crudFunction.updateProduct(
                  url,
                  firebaseAuth.currentUser!.uid,
                  productnameController.text,
                  int.parse(PriceController.text),
                  DescriptionController.text,
                  product.id,
                  FieldValue.serverTimestamp().toString(),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [ Column(
          children: [
            (flag == 1)
                ? Image.network(imagePath1)
                : Image.file(File(imagePath)),
            IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                ),
                onPressed: () {
                  getImage();
                  flag = 2;
                }),
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
      ]
      ),
    );
  }
}
