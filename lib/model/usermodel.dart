import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterModel {
  String? name;
  String? phone;
  String? password;
  String? address;
  String ? token;

  RegisterModel({
    this.name,
    this.phone,
    this.password,
    this.address,
    this.token
  });

  factory RegisterModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,)
  {
    final data = snapshot.data();
    return RegisterModel(
      name: data?['name'],
      phone: data?['phone'],
      password: data?['password'],
      address: data?['address'],
      token:data?['token']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (phone != null) "phone": phone,
      if (password != null) "password": password,
      if (address != null) "address": address,
      if (token != null) "token": token,


    };
  }
}