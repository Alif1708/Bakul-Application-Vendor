import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:bakul_app_vendor/providers/product_provider.dart';
import 'package:bakul_app_vendor/widgets/category_list.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({Key? key}) : super(key: key);
  static const String id = 'addnewproduct-screen';

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  bool _visibility = false;
  bool _track = false;

  final List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added',
  ];
  String? dropdownValue;

  final _productNameTextController = TextEditingController();
  final _aboutProductTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _quantityTextController = TextEditingController();
  final _lowStockQuantityTextController = TextEditingController();

  final _categoryTextController = TextEditingController();
  final _subCategoryTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: Color(0xFFF4B41A),
        appBar: AppBar(
          backgroundColor: Color(0xFF143D59),
          iconTheme: const IconThemeData(color: Color(0xFFF4B41A)),
        ),
        body: Form(
          key: _formKey,
          child: Column(
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
                          child: Text(
                            'Products / Add',
                            style: TextStyle(color: Color(0xFF143D59)),
                          ),
                        ),
                      ),
                      FlatButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_image != null) {
                                EasyLoading.show(status: 'Saving...');
                                _provider
                                    .uploadProductImage(_image!,
                                        _productNameTextController.text)
                                    .then((productImage) {
                                  if (productImage != null) {
                                    EasyLoading.dismiss();
                                    _provider
                                        .saveProductDataToDb(
                                            _productNameTextController.text,
                                            _aboutProductTextController.text,
                                            _priceTextController.text,
                                            dropdownValue,
                                            _quantityTextController.text,
                                            _lowStockQuantityTextController
                                                .text,
                                            context)!
                                        .then((value) {
                                      setState(() {
                                        dropdownValue = null;
                                        _formKey.currentState!.reset();
                                        _productNameTextController.clear();
                                        _aboutProductTextController.clear();
                                        _priceTextController.clear();

                                        _quantityTextController.clear();
                                        _lowStockQuantityTextController.clear();
                                        _visibility = false;
                                        _image = null;
                                        _track = false;
                                      });
                                    });
                                  } else {
                                    _provider.alertDialog(
                                        context: context,
                                        title: 'IMAGE UPLOAD',
                                        content:
                                            'Failed to upload poduct image');
                                  }
                                });
                              } else {
                                _provider.alertDialog(
                                    context: context,
                                    content: 'ProductImage not selected',
                                    title: 'PRODUCT IMAGE');
                              }
                            }
                          },
                          color: Color(0xFF143D59),
                          icon: Icon(
                            Icons.save,
                            color: Color(0xFFF4B41A),
                          ),
                          label: Text(
                            'Save',
                            style: TextStyle(color: Color(0xFFF4B41A)),
                          )),
                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Color(0xFF143D59),
                labelColor: Color(0xFF143D59),
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'GENERAL',
                  ),
                  Tab(
                    text: 'INVENTORY',
                  ),
                ],
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Color(0xFF143D59),
                  child: TabBarView(
                    children: [
                      ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  controller: _productNameTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Product Name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Product Name*',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))),
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  maxLength: 500,
                                  controller: _aboutProductTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter About Product';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'About Product*',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      _provider.getProductImage().then((value) {
                                        setState(() {
                                          _image = value;
                                        });
                                      });
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Card(
                                        color: Color(0xFFF4B41A),
                                        child: Center(
                                          child: _image == null
                                              ? Text('Select Image')
                                              : Image.file(_image!),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  controller: _priceTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Product Price';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Price*',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Collection',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      DropdownButton<String>(
                                        hint: Text('Select Collection',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        value: dropdownValue,
                                        icon: Icon(Icons.arrow_drop_down),
                                        dropdownColor: Color(0xFFF4B41A),
                                        onChanged: (value) {
                                          setState(() {
                                            dropdownValue = value;
                                          });
                                        },
                                        items: _collections
                                            .map<DropdownMenuItem<String>>(
                                                (value) {
                                          return DropdownMenuItem<String>(
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            value: value,
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Category',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: TextFormField(
                                            style:
                                                TextStyle(color: Colors.white),
                                            controller: _categoryTextController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Select Category ';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                hintText: 'Not Selected',
                                                hintStyle: TextStyle(
                                                    color: Colors.white),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white))),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CategoryList();
                                              }).whenComplete(() {
                                            setState(() {
                                              _categoryTextController.text =
                                                  _provider.selectedCategory!;
                                              _visibility = true;
                                            });
                                          });
                                        },
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          color: Color(0xFFF4B41A),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _visibility,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Sub Category',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: AbsorbPointer(
                                            absorbing: true,
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller:
                                                  _subCategoryTextController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Select Sub Category';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: 'Not Selected',
                                                  hintStyle: TextStyle(
                                                      color: Colors.white),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white))),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return SubCategoryList();
                                                }).whenComplete(() {
                                              setState(() {
                                                _subCategoryTextController
                                                        .text =
                                                    _provider
                                                        .selectedSubCategory!;
                                              });
                                            });
                                          },
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            color: Color(0xFFF4B41A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SwitchListTile(
                              value: _track,
                              onChanged: (selected) {
                                setState(() {
                                  _track = !_track;
                                });
                              },
                              activeColor: Theme.of(context).primaryColor,
                              title: Text(
                                'Track Inventory',
                                style: TextStyle(color: Color(0xFFF4B41A)),
                              ),
                              subtitle: Text(
                                'Switch ON to track Inventory',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            Visibility(
                              visible: _track,
                              child: SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Card(
                                  color: Color(0xFFF4B41A),
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          controller: _quantityTextController,
                                          validator: (value) {
                                            if (_track) {
                                              if (value!.isEmpty) {
                                                return 'Enter Quantity ';
                                              }
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText: 'Inventory Quantity*',
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.white))),
                                        ),
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          controller:
                                              _lowStockQuantityTextController,
                                          validator: (value) {
                                            if (_track) {
                                              if (value!.isEmpty) {
                                                return 'Enter Low Stock Quantity ';
                                              }
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Inventory Low Stock Quantity',
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.white))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
