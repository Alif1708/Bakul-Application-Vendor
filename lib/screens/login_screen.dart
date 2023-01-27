import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:bakul_app_vendor/providers/auth_provider.dart';
import 'package:bakul_app_vendor/screens/home_screen.dart';
import 'package:bakul_app_vendor/screens/register_screen.dart';
import 'package:bakul_app_vendor/screens/reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obsecure = true;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF4B41A),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                          tag: "logo",
                          child: Image.asset(
                            'images/bakullogo2.png',
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(fontSize: 50),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailTextController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                          ),
                          focusColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordTextController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          }
                        },
                        obscureText: _obsecure,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _obsecure
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obsecure = !_obsecure;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                          ),
                          focusColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ResetPasswordScreen.id);
                            },
                            child: Text(
                              'Forgot Password?',
                              textAlign: TextAlign.end,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF143D59)),
                              child: _loading
                                  ? LinearProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : Text(
                                      'Login',
                                      style:
                                          TextStyle(color: Color(0xFFF4B41A)),
                                    ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _loading = true;
                                  });
                                  _authData
                                      .loginVendor(_emailTextController.text,
                                          _passwordTextController.text)
                                      .then((credential) {
                                    if (credential?.user!.uid != null) {
                                      Navigator.pushReplacementNamed(
                                          context, HomeScreen.id);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(_authData.error)));
                                    }
                                  });
                                }
                                setState(() {
                                  _loading = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pushNamed(context, RegisterScreen.id);
                            },
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Don not have an account yet ? ',
                                      style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                    text: 'Register',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF143D59)),
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
        ),
      ),
    );
  }
}
