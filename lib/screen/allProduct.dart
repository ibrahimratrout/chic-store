import 'package:chic_store/screen/singleProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../constants/constants.dart';
import '../model/productmdel.dart';
import '../widgets/loadingWidget.dart';
import '../widgets/productCard.dart';

class AllProduct extends StatelessWidget {
  AllProduct({required this.catogeryId , required this.catogeryName});

  String? catogeryId;
  String? catogeryName;
  final db = FirebaseFirestore.instance;
  Stream<List<Product>> readDataProdect() =>
      db.collection('product').where('category_id',isEqualTo: catogeryId )
          .snapshots()
          .map((value) =>
          value.docs
              .map((e) => Product.fromJson((e.data())))
              .toList());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder <List<Product>>(
        stream: readDataProdect(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Text("${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState) {
            return  Loading();
          }
          if(snapshot.hasData){
            final product = snapshot.data;
            return MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text('${catogeryName}'),
                  backgroundColor: Colors.black,
                ),
                body: Padding(
                  padding: const EdgeInsets.only(right: 16,left: 16,top: 5),
                  child: GridView.builder(
                      itemCount: product!.length,
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
              return  Loading();
          }
        }
    );
  }
}
