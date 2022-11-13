class Product {
  String? product_name ;
  String? product_id ;
  String? product_description ;
  dynamic? price ;
  List <dynamic>? image ;
  List<dynamic>? color ;
  String? catogery_id;

  Product(
      {  this.product_name,
        this.product_id,
        this.product_description,
        this.price,
        this.image,
        this.color,
        this.catogery_id
      });

  factory Product.fromJson (jsonData){
    return Product(product_name:jsonData['product_name'] ,
        product_id:jsonData['product_id'] ,
        product_description: jsonData['product_description'],
        price: jsonData['price'],
        image: jsonData['image_url'],
        color: jsonData['color'],
        catogery_id: jsonData['category_id']);
  }
}