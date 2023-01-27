import 'package:flutter/material.dart';
import 'package:bakul_app_vendor/screens/login_screen.dart';
import 'package:bakul_app_vendor/widgets/image_picker.dart';
import 'package:bakul_app_vendor/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String id = 'register-screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF4B41A),
        appBar: AppBar(
          backgroundColor: Color(0xFF143D59),
          iconTheme: const IconThemeData(color: Color(0xFFF4B41A)),
          centerTitle: true,
          title: Text(
            'Register',
            style: TextStyle(color: Color(0xFFF4B41A)),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ShopPicCard(),
                  RegisterForm(),
                  Row(
                    children: [
                      FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Already have an account ? ',
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
