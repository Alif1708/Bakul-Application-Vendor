import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bakul_app_vendor/screens/add_new_product_screen.dart';
import 'package:bakul_app_vendor/widgets/published_product.dart';
import 'package:bakul_app_vendor/widgets/unpublished_product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);
  static const String id = 'product-screen';

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int totalProduct = 0;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: user!.uid)
        .get()
        .then((value) {
      totalProduct = value.size;

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Color(0xFFF4B41A),
          body: Column(
            children: [
              Material(
                color: Color(0xFFF4B41A),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Row(
                            children: [
                              Text(
                                'Products',
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black54,
                                maxRadius: 13,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    totalProduct.toString(),
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      FlatButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, AddNewProduct.id);
                          },
                          color: Color(0xFF143D59),
                          icon: Icon(
                            Icons.add,
                            color: Color(0xFFF4B41A),
                          ),
                          label: Text(
                            'Add New',
                            style: TextStyle(color: Color(0xFFF4B41A)),
                          )),
                    ],
                  ),
                ),
              ),
              TabBar(
                  labelColor: Color(0xFF143D59),
                  indicatorColor: Color(0xFF143D59),
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(
                      text: "PUBLISHED",
                    ),
                    Tab(
                      text: "UN PUBLISHED",
                    ),
                  ]),
              Expanded(
                child: Container(
                  child: TabBarView(children: [
                    PublishedProduct(),
                    UnPublishedProducts(),
                  ]),
                ),
              )
            ],
          )),
    );
  }
}
