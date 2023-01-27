import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bakul_app_vendor/providers/auth_provider.dart';

class ShopPicCard extends StatefulWidget {
  ShopPicCard({Key? key}) : super(key: key);

  @override
  State<ShopPicCard> createState() => _ShopPicCardState();
}

class _ShopPicCardState extends State<ShopPicCard> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          _authData.getImage().then((image) {
            setState(() {
              _image = image;
              print(_image!.path);
            });
            if (image != null) {
              _authData.isPicAvail = true;
            }
          });
        },
        child: SizedBox(
          height: 130,
          width: 150,
          child: Card(
            color: Color(0xFF143D59),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _image == null
                  ? Center(
                      child: Text(
                      'Add Shop Image',
                      style: TextStyle(color: Color(0xFFF4B41A)),
                    ))
                  : Image.file(
                      _image!,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
