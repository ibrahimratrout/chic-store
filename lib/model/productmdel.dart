import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? product_name ;
  String? product_id ;
  String? product_description ;
  dynamic? price ;
  List <dynamic>? image ;
  List<dynamic>? color ;
  String? catogery_id;
  Map <dynamic,dynamic>? size;
  Timestamp? createdAt ;

  Product(
      {  this.product_name,
        this.product_id,
        this.product_description,
        this.price,
        this.image,
        this.color,
        this.catogery_id,
        this.size,
        this.createdAt
      });

  factory Product.fromJson (jsonData){
    return Product(product_name:jsonData['product_name'] ,
        product_id:jsonData['product_id'] ,
        product_description: jsonData['product_description'],
        price: jsonData['price'],
        image: jsonData['image_url'],
        color: jsonData['color'],
        catogery_id: jsonData['category_id'],
        size: jsonData['size'],
        createdAt: jsonData['created_at']);
  }
}