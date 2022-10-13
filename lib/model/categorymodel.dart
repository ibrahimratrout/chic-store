import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? category_description;
  String? category_id;
  String? category_img_url;
  String? category_name;

  CategoryModel({
    this.category_description,
    this.category_id,
    this.category_img_url,
    this.category_name,
  });

  Map<String, dynamic> toJson() =>{
    'category_description': category_description,
    'category_id': category_id,
    'category_img_url': category_img_url,
    'category_name': category_name,
};
  factory CategoryModel.fromFirestore(Map<String, dynamic> json)
  {
    return CategoryModel(
      category_description: json?['category_description'],
      category_id: json?['category_id'],
      category_img_url: json?['category_img_url'],
      category_name: json?['category_name'],

    );
  }
}



