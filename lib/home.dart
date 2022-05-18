

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shrine/crud_function.dart';
import 'model/product.dart';
import 'package:provider/provider.dart';
import 'constant/firebase_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropdownValue = 'ASC';

  var crudFunction = CrudFunction();

  List<Card> _buildGridCards(BuildContext context, List<Product> productList) {
    //List<Product> products = ProductsRepository.loadProducts(Category.all);
    List<Product> products = productList;
    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.network(product.image),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: theme.textTheme.headline6,
                      maxLines: 1,
                    ),
                    Text(
                      formatter.format(product.price),
                      style: theme.textTheme.subtitle2,
                    ),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        child: Text("more"),
                        onPressed: () {
                          Duration(seconds: 2);
                          Navigator.pushNamed(context, '/third',
                              arguments: product);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
    return Scaffold(
      appBar: AppBar(


        leading: IconButton(
          icon: const Icon(
            Icons.emoji_people,
            semanticLabel: 'menu',
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/second');
          },
        ),




          title:(!(Provider.of<loginjudge>(context,listen: false).loginkind==1))

          ? Center(child: Text("Welcome guest!"))

          : Center(child: Text("Welcome "+firebaseAuth.currentUser!.displayName!+ "!")),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              semanticLabel: 'filter',
            ),
            onPressed: () {

              Navigator.pushNamed(context, '/first');
            },
          ),

        ],
      ),

      body:
      StreamBuilder<List<Product>>(
        stream: crudFunction.productStream(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            var productList = snapshot.data!;
            if (dropdownValue == "DESC") {
              productList.sort((b, a) => a.price.compareTo(b.price));
            }
            else {
              productList.sort((a, b) => a.price.compareTo(b.price));
            }
            return ListView(children: [
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['ASC', 'DESC']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Container(
                height: 3000,
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16.0),
                  childAspectRatio: 8.0 / 9.0,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  children: _buildGridCards(context, productList),
                ),
              ),
            ]);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
