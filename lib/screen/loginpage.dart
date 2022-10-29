import 'dart:async';
import 'package:chic_store/screen/index.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../constants/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isFailed = false;
  var password;
  var phoneNumber;
  var _formKey = GlobalKey<FormState>();
  String?passDecrypt;
  static var decrypted;

  final db = FirebaseFirestore.instance;

  String decryptAES(plainText){
    final key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted!.base64;
  }
  _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final value = token;
    prefs.setString(KEY_ACCESS_TOKEN, value);
  }

  void login() async {
    bool x = false;
    db
        .collection("users")
        .where("phone", isEqualTo: phoneNumber)
        .where("password", isEqualTo: passDecrypt)
        .get()
        .then((value) {
      x = value.docs.isEmpty;
      value.docs.forEach((element) {
        _saveToken(element.data()['token']);
       if(element.data()['token']!=null)
         {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => homeNavigationBar()));
         }
      });
      setState(() {
        isFailed = x;
      });
      if (isFailed == true) {
        _showDialog();
      }
    });
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Login Error ",textAlign: TextAlign.center,),titleTextStyle:TextStyle(color: kTextColor),
              content:
                  Text("the phone number or password entered is incorrect try again ",textAlign: TextAlign.center,style: TextStyle(color: kTextColor)),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Chanel"))
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ));
        });
  }
  _send() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        passDecrypt=decryptAES(password);
      });
      login();
    } else {
      setState(() {
        isFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              color: kDefaultBackGroundSign_in_up,
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                         child: Image(

                         image: AssetImage("images/logo.png"),

                        ),),
                    Container(
                      margin: EdgeInsets.only(
                          right: 15, left: 15, top: 30, bottom: 15),
                      child: Center(
                        child: Text(
                          "WELCOME ",
                          style: TextStyle(
                              color: kTextColor,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.all(kDefaultTextFieldMargin),
                                padding: EdgeInsets.all(kDefaultCategoryPaddin),
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: "Phone"),
                                  keyboardType: TextInputType.phone,
                                  validator: (text) {
                                    if (text!.length < 10) {
                                      return "The number cannot be less than 10 digits";
                                    } else if (text!.length > 10) {
                                      return "The number cannot be more than 10 digits";
                                    } else if (!RegExp(r"^[0-9]+")
                                        .hasMatch(text)) {
                                      return "The number cannot contain letters or symbols";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    phoneNumber = "+972${value}";
                                    print(phoneNumber);
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(kDefaultTextFieldMargin),
                                padding: EdgeInsets.all(kDefaultCategoryPaddin),
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: "Password"),
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  validator: (text) {
                                    if (text!.length < 6) {
                                      return "The password cannot be less than six characters";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    password = value;
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 14, right: 14, left: 14, bottom: 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _send();
                                    //Navigator.pushNamed(context, '/');
                                  },
                                  child: Text("SIGN IN"),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(300, 50),
                                    maximumSize: const Size(300, 50),
                                    backgroundColor: kDefaultColorButton,
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    shadowColor: Colors.white,
                                    elevation: 5,
                                    side: BorderSide(
                                        color: Colors
                                            .black87, //change border color
                                        width: 2, //change border width
                                        style: BorderStyle
                                            .solid), // change border side of this beautiful button
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), //change border radius of this beautiful button thanks to BorderRadius.circular function
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(bottom: 15, top: 15),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/signup');
                                    },
                                    child: Text(
                                      "Create New Accent",
                                      style: TextStyle(color: kTextColor),
                                    ),
                                  )),
                            ],
                          ),
                        ))
                  ])),
            ))
      ]),
    );
  }
}
