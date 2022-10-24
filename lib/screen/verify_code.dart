import 'package:chic_store/constants/constants.dart';
import 'package:chic_store/model/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class verifyCode extends StatefulWidget {
  final String verification;
  final RegisterModel registerModel;
  const verifyCode(
      {Key? key, required this.verification, required this.registerModel})
      : super(key: key);

  @override
  State<verifyCode> createState() => _verifyCodeState();
}

class _verifyCodeState extends State<verifyCode> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  var register;

  TextEditingController? phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                ),
              ),
              elevation: 0,
            ),
            body: Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Verfiy Phone Number",
                          style: TextStyle(
                              color: kDefaultColoranAppText,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      child: Text("Enter your code",
                          style: TextStyle(
                            color: kDefaultColoranAppText,
                            fontSize: 16,
                          )),
                    ),
                    SizedBox(height: 25),
                    SizedBox(
                      child: Pinput(
                        length: 6,
                        keyboardType: TextInputType.number,
                        controller: phoneNumberController,
                        showCursor: true,
                        onCompleted: (pin) => print(pin),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              final credential = PhoneAuthProvider.credential(
                                  verificationId: widget.verification,
                                  smsCode: phoneNumberController!.text
                                      .trim()
                                      .toString());
                              await _auth
                                  .signInWithCredential(credential)
                                  .then((value) async => {
                                        if (value != null)
                                          {
                                            register = db
                                                .collection("users")
                                                .withConverter(
                                                  fromFirestore: RegisterModel
                                                      .fromFirestore,
                                                  toFirestore:
                                                      (RegisterModel user,
                                                              options) =>
                                                          user.toFirestore(),
                                                )
                                                .doc(_auth.currentUser?.uid),
                                            widget.registerModel.token =
                                                _auth.currentUser?.uid,
                                            await register
                                                .set(widget.registerModel),
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      title: Text(
                                                        "Successfully",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      titleTextStyle: TextStyle(
                                                          color: Colors.black),
                                                      content: Text(
                                                        "The registration process has been completed successfully",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                               Navigator.pushNamed(context, '/login');

                                                            },
                                                            child:
                                                                Text("Ok"))
                                                      ],
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ));
                                                }),
                                          }
                                      });
                            } on FirebaseAuthException catch (e) {
                              print("e ${e.message}");
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text(
                                          "Error",
                                          textAlign: TextAlign.center,
                                        ),
                                        titleTextStyle:
                                            TextStyle(color: Colors.black),
                                        content: Text(
                                          "The sms verification code used to create the phone auth credential is invalid",
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ));
                                  });
                            } catch (e) {
                              print("haned-credential ${e}");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kDefaultColorButton,
                          ),
                          child: Text("Verify Code ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: kDefaultSizeText,
                              ))),
                    )
                  ],
                ),
              ),
            )));
  }
}
