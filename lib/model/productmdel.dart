class Product {
  final String product_name ;
  final int product_id ;
  final String product_description ;
  final int price ;
  final List <dynamic> image ;
  final List<dynamic> color ;

  Product(
      { required this.product_name,
        required this.product_id,
        required this.product_description,
        required this.price,
        required this.image,
        required this.color});

  factory Product.fromJson (jsonData){
    return Product(product_name:jsonData['product_name'] ,
        product_id:jsonData['product_id'] ,
        product_description: jsonData['product_description'],
        price: jsonData['price'],
        image: jsonData['image1_url'],
        color: jsonData['color'] );
  }
}