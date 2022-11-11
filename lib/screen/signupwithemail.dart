import 'package:chic_store/constants/constants.dart';
import 'package:chic_store/screen/verify_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/usermodel.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignUpWithEmail extends StatefulWidget {
  @override
  State<SignUpWithEmail> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpWithEmail> {
  bool? findEmail;
  bool isLoading = false;
  var name;
  var username;
  var password;
  var address;
  var token;
  var _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  static Encrypted? encrypted;

  String encryptAES(plainText) {
    final key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted!.base64;
  }

  Future signup() async {
    isLoading = true;
    String? passEncrypted;
    setState(() {
      passEncrypted = encryptAES(password);
    });

    var register;
    final user = RegisterModel(
        name: name,
        username: username,
        password: passEncrypted,
        address: address,
        token: token);

    try {

      await auth
          .createUserWithEmailAndPassword(email: username, password: password).then((value) async =>
      {
        if (value != null)
          {
            register = db
                .collection("users")
                .withConverter(
              fromFirestore: RegisterModel.fromFirestore,
              toFirestore: (RegisterModel user, options) =>
                  user.toFirestore(),
            )
                .doc(auth.currentUser?.uid),
            user.token = auth.currentUser?.uid.toString(),
            await register.set(user),
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text(
                        "Successfully",
                        textAlign: TextAlign.center,
                      ),
                      titleTextStyle: TextStyle(color: Colors.black),
                      content: Text(
                        "The registration process has been completed successfully",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text("Ok"))
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ));
                })
          }
     }
     );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      setState(() {
        isLoading=false;
      });
      if (e.code == 'email-already-in-use') {
        _showDialog();
        print('email-already-in-use');
      }
    }
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "Registration Error",
                textAlign: TextAlign.center,
              ),
              titleTextStyle: TextStyle(color: Colors.black),
              content: Text(
                "The entered number is already registered",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
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

  _send() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();

      signup();
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
            body: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  Container(
                    margin: EdgeInsets.only(
                        right: 15, left: 15, top: 30, bottom: 15),
                    child: Center(
                      child: Text(
                        "WELCOME ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(4),
                    //height: 250,
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
                              decoration: InputDecoration(labelText: "Name"),
                              keyboardType: TextInputType.text,
                              validator: (text) {
                                if (text!.length < 3) {
                                  return "The name can not be less than three letters";
                                } else if (!RegExp(r"^[a-z A-Z]+")
                                    .hasMatch(text)) {
                                  return "The name can not contain numbers ";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                name = value;
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(kDefaultTextFieldMargin),
                            padding: EdgeInsets.all(kDefaultCategoryPaddin),
                            child: TextFormField(
                              decoration: InputDecoration(labelText: "Email"),
                              validator: (text) {
                                if (!RegExp(r"^[a-z A-Z]+").hasMatch(text!)) {
                                  return "The Email Valida";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                username = value;
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
                            margin: EdgeInsets.all(kDefaultTextFieldMargin),
                            padding: EdgeInsets.all(kDefaultCategoryPaddin),
                            child: TextFormField(
                              decoration: InputDecoration(labelText: "Address"),
                              keyboardType: TextInputType.text,
                              validator: (text) {
                                if (text!.length < 4) {
                                  return "The address can not be less than 4 characters";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                address = value;
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 14, right: 14, left: 14, bottom: 0),
                            child: ElevatedButton(
                              onPressed: () {
                                _send();
                              },
                              child: Text("SIGN UP"),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(300, 50),
                                maximumSize: const Size(300, 50),
                                backgroundColor: kDefaultColorButton,

                                textStyle: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                shadowColor: Colors.white,
                                elevation: 5,
                                side: BorderSide(
                                    color: Colors.black87, //change border color
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have account ? "),
                              Container(
                                  margin: EdgeInsets.only(bottom: 15, top: 15),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: Text(
                                      "SIGN IN",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )),
                            ],
                          ),
                          Visibility(
                            visible: isLoading,
                            child: Center(
                              child: SpinKitFadingCircle(
                                itemBuilder: (BuildContext context, int index) {
                                  return DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: index.isEven
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ])))
      ]),
    );
  }
}
