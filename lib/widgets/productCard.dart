import 'package:chic_store/screen/singleProduct.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/productmdel.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleProduct(
                    productId: product.product_id,
                  )))
        },
        child: Container(
          width: 200,
          height: 300,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 1))
              ]
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 10,left: 10,top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.network(
                    '${product.image?[0]}',
                    height: 80,
                    width: 100,
                  ),
                ),
                Text(
                  product.product_name!.length > 20 ? '${product.product_name!.substring(0, 16)}...':product.product_name!,
                  style: GoogleFonts.alef(
                      textStyle:
                      TextStyle(fontSize: 17)),
                ),
                const SizedBox(height: 10),
                Text(
                  "₪ ${product.price - 1}.99",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45)),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        )
    );
  }
}
