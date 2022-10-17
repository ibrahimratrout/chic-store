import 'package:flutter/material.dart';
import '../model/productmdel.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product}) ;
  final Product product ;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
            width:200,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3)
                  )
                ]
            ),
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(product.product_name,
                    style:TextStyle(fontSize:23 ,fontWeight: FontWeight.bold) ,
                  ),
                  SizedBox(height: 10,),
                  Text(product.product_description,
                      style:TextStyle(fontSize:15 ,fontWeight: FontWeight.bold)),
                  Row(children: [
                    Text(product.price.toString()),
                  ],)
                ],) ,
            ),

          ),
        ),
        Positioned(
            right: 20,
            bottom: 80,
            child: Image.network("https://img.freepik.com/premium-photo/blue-sport-running-shoes-white-background-sports-shoes-blue-color-trendy-sport-footwear_256259-2485.jpg?",height: 100,))
      ],

    );
  }
}
