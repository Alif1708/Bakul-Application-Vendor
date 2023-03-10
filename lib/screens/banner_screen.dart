import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bakul_app_vendor/providers/product_provider.dart';
import 'package:bakul_app_vendor/services/firebase_services.dart';
import 'package:bakul_app_vendor/widgets/banner_card.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({Key? key}) : super(key: key);
  static const String id = 'banner-screen';

  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  File? _image;
  var _imagePathText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFFF4B41A),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          BannerCard(),
          Divider(
            thickness: 3,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Center(
              child: Text(
                'ADD NEW BANNER',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Color(0xFF143D59),
                      child: _image == null
                          ? Center(
                              child: Text(
                              'No Image Selected',
                              style: TextStyle(color: Color(0xFFF4B41A)),
                            ))
                          : Image.file(
                              _image!,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  TextFormField(
                    controller: _imagePathText,
                    enabled: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: _visible ? false : true,
                    child: Row(
                      children: [
                        Expanded(
                            child: FlatButton(
                          color: Color(0xFF143D59),
                          child: Text(
                            'Add New Banner',
                            style: TextStyle(
                                color: Color(0xFFF4B41A),
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            setState(() {
                              _visible = true;
                            });
                          },
                        ))
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _visible,
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: FlatButton(
                                color: Color(0xFF143D59),
                                child: Text(
                                  'Upload Image',
                                  style: TextStyle(
                                      color: Color(0xFFF4B41A),
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  getBannerImage().then((image) {
                                    setState(() {
                                      _imagePathText.text = _image!.path;
                                    });
                                  });
                                },
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: AbsorbPointer(
                                absorbing: _image != null ? false : true,
                                child: FlatButton(
                                  color: _image != null
                                      ? Theme.of(context).primaryColor
                                      : Colors.orange,
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    EasyLoading.show(status: 'Saving...');
                                    uploadBannerImage(
                                            _image!.path, _provider.shopName)
                                        .then((url) {
                                      if (url != null) {
                                        _services.saveBanenr(url);
                                        setState(() {
                                          _imagePathText.clear();
                                          _image = null;
                                        });
                                        EasyLoading.dismiss();
                                        _provider.alertDialog(
                                          content: 'Banner Upload Success',
                                          context: context,
                                          title: 'Banner Upload',
                                        );
                                      } else {
                                        EasyLoading.dismiss();
                                        _provider.alertDialog(
                                          content: 'Banner Upload Failed',
                                          context: context,
                                          title: 'Banner Upload',
                                        );
                                      }
                                    });
                                  },
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: FlatButton(
                                color: Colors.black54,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _visible = false;
                                    _imagePathText.clear();
                                    _image = null;
                                  });
                                },
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<File?> getBannerImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }

    return _image;
  }

  Future<String> uploadBannerImage(filePath, shopName) async {
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    try {
      await _storage.ref('vendorBanner/$shopName/$timeStamp').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('vendorBanner/$shopName/$timeStamp')
        .getDownloadURL();
    return downloadURL;
  }
}
