import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/constants.dart';
import '../model/productmdel.dart';
import '../widgets/loadingWidget.dart';
import '../widgets/noProducts.dart';
import '../widgets/productCard.dart';

class AllProduct extends StatefulWidget {
  AllProduct({required this.catogeryId , required this.catogeryName});
  String? catogeryId;
  String? catogeryName;
  @override
  State<AllProduct> createState() => _AllProductState();
}
class _AllProductState extends State<AllProduct> {
  double? filter=0;
  final myController = TextEditingController();
  final db = FirebaseFirestore.instance;
  Stream<List<Product>> readDataProdect() =>
      db.collection('product').where('category_id',isEqualTo: widget.catogeryId )
          .snapshots()
          .map((value) =>
          value.docs
              .map((e) => Product.fromJson((e.data())))
              .toList());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: kDefaultAppBarColorTitile,
                iconSize: 20.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('${widget.catogeryName}',style: kDefaultStyleTextTitlte),
              backgroundColor: kDefaultAppBarBackgroundColor,
              actions: [
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        enableDrag: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          height: 400,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Filter by price ",style: TextStyle(fontSize: 20),),
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: 'The highest price of products ?',
                                  labelText: 'Price',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (val){
                                  if(val=="")
                                  {
                                    setState(() {
                                      filter=0;
                                    });
                                  }else
                                    setState(() {
                                      filter = double.parse(val).toDouble();
                                    });
                                },
                                validator: (String? value) {
                                  return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                },
                              ),
                            ],
                          ),
                        ),);
                    },
                    icon: Icon(
                      Icons.filter_alt,
                      color: kDefaultAppBarIconColor,
                    ))
              ],
            ),
            body: Container(
              child: StreamBuilder <List<Product>>(
                  stream: readDataProdect(),
                  builder: (context,snapshot){
                    if(snapshot.hasError){
                      return Text("${snapshot.error}");
                    }
                    if (snapshot.connectionState == ConnectionState) {
                      return Loading();
                    }
                    var product=snapshot.data;
                    if(snapshot.hasData){
                      if(filter!=0){
                        product = product!.where((item) =>
                        item.price!<=filter!).toList();
                      }
                      if(product!.length!=0){
                        return
                          GridView.builder(
                              itemCount: product!.length,
                              clipBehavior: Clip.none,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.8
                              ),
                              itemBuilder: (context,index) {
                                return ProductCard(product: product![index]);
                              });
                      }
                      else {return NoProducts();}
                    }
                    return Loading();
                  }
              ),
            ))
    );
  }
}