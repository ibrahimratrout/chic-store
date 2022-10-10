import 'package:chic_store/model/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class verifyCode extends StatefulWidget {
  final String verification;
  final RegisterModel registerModel;
  const verifyCode({Key? key,required this.verification,required this.registerModel }) : super(key: key);

  @override
  State<verifyCode> createState() => _verifyCodeState();
}

class _verifyCodeState extends State<verifyCode> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  var register ;

  TextEditingController? phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
     child: Scaffold(
       body: Column(
         children: [
           Container(
             margin: EdgeInsets.all(3),
             padding: EdgeInsets.all(4),
             child: TextField(
               decoration: InputDecoration(labelText: "Phone"),
               keyboardType: TextInputType.phone,
               controller: phoneNumberController,
             ),
           ),
           GestureDetector(
               onTap: () async {
                 final credential = PhoneAuthProvider.credential(
                     verificationId: widget.verification, smsCode: phoneNumberController!.text.trim().toString());

                 try
                     {
                       _auth.signInWithCredential(credential).then((value) async =>  {
                         if (value != null)
                           {
                             register= db.collection("users").withConverter(
                               fromFirestore: RegisterModel.fromFirestore,
                               toFirestore: (RegisterModel user, options) =>
                                   user.toFirestore(),
                             ).doc(_auth.currentUser?.uid),
                             widget.registerModel.token=_auth.currentUser?.uid,
                             await  register.set(widget.registerModel),
                             await Navigator.pushNamed(context, '/login')
                           }
                         else{
                           print("no value")
                         }
                       });
                         await Navigator.pushNamed(context, '/login');

                     }catch(e){
                    print("e $e");

                 }
               },
               child: const CircleAvatar(
                 radius: 100,
                 backgroundColor: Colors.indigo,
                 child: Text(
                   'A Button',
                   style: TextStyle(fontSize: 30),
                 ),
               )),

         ],
       ),
     ),
    );
  }
}
