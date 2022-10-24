import 'package:chic_store/screen/singleProduct.dart';
import 'package:flutter/material.dart';
import '../model/productmdel.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product}) ;
  final Product product ;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>{
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> SingleProduct(productId: product.product_id,)))
      },
      child: Stack(
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
                    Text(product.product_name!,
                      style:TextStyle(fontSize:23 ,fontWeight: FontWeight.bold) ,
                    ),
                    SizedBox(height: 10,),
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
              child: Image.network('${product.image?[0]}',height: 100,width: 100,))
        ],

      ),
    );
  }
}
