import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/productmdel.dart';

class AllProduct extends StatelessWidget {
  AllProduct({ required this.catogery_id});
  final String catogery_id ;
  CollectionReference products = FirebaseFirestore.instance.collection("category").doc('XNnn3CTVTtB6lT9aGT4V').collection('product');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder <QuerySnapshot>(
        stream: products.snapshots() ,
        builder: (context,snapshot){
          if(snapshot.hasData){
            List<Product> product = [];
            for(int i = 0;i<snapshot.data!.docs.length;i++){
              print(snapshot.data!.docs[i]['image1_url']);
              product.add(Product.fromJson(snapshot.data!.docs[i]));
            }
            return MaterialApp(
              home: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text("datdfa"),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(right: 16,left: 16,top: 50),
                  child: GridView.builder(
                      itemCount: product.length,
                      clipBehavior: Clip.none,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.8
                      ),
                      itemBuilder: (context,index){
                        return ProductCard(product: product[index]);
                      }
                  ),
                ),
              ),
            );
          }else {
            return  MaterialApp(home: Text("sdfasdf"));
          }
        }
    );
  }
}
