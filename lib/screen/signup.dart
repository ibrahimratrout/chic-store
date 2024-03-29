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

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool? findPhone;
  bool isLoading = false;
  var name;
  var phoneNumber;
  var password;
  var address;
  var username;
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
    String? passEncrypted;
    setState(() {
      passEncrypted = encryptAES(password);
    });

    final user = RegisterModel(
      name: name,
      username: username,
      password: passEncrypted,
      address: address,
    );

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential)  {
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          isLoading=false;

        });
        print(e.message);
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          isLoading=false;

        });
        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return VerifyCode(
            verification: verificationId.toString(),
            registerModel: user,
          );
        }));
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
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
      await db
          .collection("users")
          .where("username", isEqualTo: username)
          .get()
          .then((value) => {
                findPhone = value.docs.isEmpty,
              });
      if (findPhone == false) {
        _showDialog();
      } else if (findPhone == true) {
        isLoading = true;
        signup();
      }
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
                              decoration: InputDecoration(labelText: "Phone"),
                              keyboardType: TextInputType.phone,
                              validator: (text) {
                                if (text!.length < 10) {
                                  return "The number cannot be less than 10 digits";
                                } else if (text!.length > 10) {
                                  return "The number cannot be more than 10 digits";
                                } else if (!RegExp(r"^[0-9]+").hasMatch(text)) {
                                  return "The number cannot contain letters or symbols";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                phoneNumber = '+970${value}';
                                username=value;
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
