import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bakul_app_vendor/providers/product_provider.dart';
import 'package:bakul_app_vendor/services/firebase_services.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Dialog(
      backgroundColor: Color(0xFFF4B41A),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color(0xFF143D59),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Category',
                    style: TextStyle(
                        color: Color(0xFFF4B41A), fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Color(0xFFF4B41A),
                      )),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _services.category.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Expanded(
                  child: ListView(
                    children: snapshot.data!.docs.map((document) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(document['image']),
                        ),
                        title: Text(
                          document['categoryName'],
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          _provider.selectCategory(
                              document['categoryName'], document['image']);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class SubCategoryList extends StatefulWidget {
  const SubCategoryList({Key? key}) : super(key: key);

  @override
  _SubCategoryListState createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Dialog(
      backgroundColor: Color(0xFFF4B41A),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color(0xFF143D59),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Sub Category',
                    style: TextStyle(
                        color: Color(0xFFF4B41A), fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Color(0xFFF4B41A),
                      )),
                ],
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
              future: _services.category.doc(_provider.selectedCategory).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!.data();
                    return Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(
                              children: [
                                Text('Main Category: '),
                                FittedBox(
                                  child: Text(
                                    _provider.selectedCategory!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 3,
                        ),
                        Container(
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView.builder(
                                  itemCount: (data as Map)['subCat'] == null
                                      ? 0
                                      : (data)['subCat'].length,
                                  itemBuilder: (context, int index) {
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        child: Text('${index + 1}'),
                                      ),
                                      title: Text(
                                        (data)['subCat'][index]['name'],
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onTap: () {
                                        _provider.selectSubCategory(
                                            (data)['subCat'][index]['name']);
                                        Navigator.pop(context);
                                      },
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ));
                  } else {
                    return Text('No data');
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ],
      ),
    );
  }
}
