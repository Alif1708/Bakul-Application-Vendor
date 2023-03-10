import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bakul_app_vendor/providers/product_provider.dart';
import 'package:bakul_app_vendor/screens/splash_screen.dart';

class MenuWidget extends StatefulWidget {
  final Function(String)? onItemClick;

  const MenuWidget({Key? key, this.onItemClick}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  User? user = FirebaseAuth.instance.currentUser;

  DocumentSnapshot<Map<String, dynamic>>? vendorData;

  @override
  void initState() {
    getVendorData();
    super.initState();
  }

  Future<DocumentSnapshot> getVendorData() async {
    var result = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(user!.uid)
        .get();
    setState(() {
      vendorData = result;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    _provider
        .getShopName(vendorData != null ? vendorData!.data()!['shopName'] : "");
    return Container(
      color: Color(0xFF143D59),
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FittedBox(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xFFF4B41A),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: vendorData != null
                          ? NetworkImage(vendorData!.data()!['imageUrl'])
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      vendorData != null
                          ? vendorData!.data()!['shopName']
                          : 'Shop Name',
                      style: TextStyle(
                        color: Color(0xFFF4B41A),
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          sliderItem('Dashboard', Icons.dashboard_outlined),
          sliderItem('Product', Icons.shopping_bag_outlined),
          sliderItem('Banner', CupertinoIcons.photo),
          sliderItem('Orders', Icons.list_alt_outlined),
          sliderItem('Reports', Icons.stacked_bar_chart),
          sliderItem('LogOut', Icons.arrow_back_ios)
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons) => InkWell(
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Icon(
                  icons,
                  color: Color(0xFFF4B41A),
                  size: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(color: Color(0xFFF4B41A), fontSize: 20),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        if (title == 'LogOut') {
          showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title:
                      Text("Log out", style: TextStyle(color: Colors.orange)),
                  content: Text("Are you sure you want to Logout",
                      style: TextStyle(color: Colors.orange)),
                  actions: [
                    CupertinoDialogAction(
                        child:
                            Text("YES", style: TextStyle(color: Colors.orange)),
                        onPressed: () {
                          _signOut().then((value) {
                            Navigator.pushReplacementNamed(
                                context, SplashScreen.id);
                          });
                          Navigator.of(context).pop();
                        }),
                    CupertinoDialogAction(
                        child:
                            Text("NO", style: TextStyle(color: Colors.orange)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        } else {
          widget.onItemClick!(title);
        }
      });

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
