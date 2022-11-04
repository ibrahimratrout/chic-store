import 'package:chic_store/screen/singleProduct.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            padding: const EdgeInsets.only(top: 85),
            child: Container(
              width:200,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 1)
                    )
                  ]
              ),
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(product.product_name!,
                      style:GoogleFonts.breeSerif(textStyle: TextStyle(fontSize:18 ,fontWeight: FontWeight.bold) ),
                    ),
                    const SizedBox(height: 10),
                    Text("₪ ${product.price-1}.99",style: GoogleFonts.breeSerif(textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black45)),
                    ),
                    const SizedBox(height: 5),
                  ],) ,
              ),

            ),
          ),
          Positioned(
              right:
              product.catogery_id == "2"? 30 :40,
              bottom: product.catogery_id == "2"? 85 :110,
              child: Image.network('${product.image?[0]}',height: 100,width: 100,))
        ],
      ),
    );
  }
}
