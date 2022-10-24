import 'package:carousel_slider/carousel_slider.dart';
import 'package:chic_store/model/productmdel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/constants.dart';
import '../widgets/loadingWidget.dart';

class SingleProduct extends StatefulWidget {
  SingleProduct({required this.productId});
  final String? productId;

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {

  Stream<QuerySnapshot<Map<String, dynamic>>> getSingleProduct() {
    return  FirebaseFirestore.instance
        .collection("product")
        .where("product_id", isEqualTo: widget.productId)
        .snapshots();
  }
  Widget buildIndicator()=>AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: dataimages.length,
     effect: SlideEffect(dotWidth: 15,dotHeight: 15 ,
         activeDotColor: Colors.black,
         dotColor: Colors.white54),
  );
  int activeIndex = 0;
  var dataimages;
  var data;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: getSingleProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState) {
            return  Loading();
          }
          if (snapshot.hasData) {
             dataimages = snapshot.data?.docs[0]['image_url'];
             data = snapshot.data?.docs[0];
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 20.0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Colors.black,
              ),
               backgroundColor: Colors.black,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        CarouselSlider.builder(
                            itemCount: dataimages.length,
                            options: CarouselOptions(
                              height: 360,
                              viewportFraction: 1,
                              onPageChanged: (index,reason)=>
                                  setState(()=>activeIndex=index),
                            ),
                            itemBuilder: (context,index,realIndex){
                              return Image.network('${dataimages[index]}',
                                fit: BoxFit.cover,
                              );
              },
              ),
                        // const SizedBox(height: 10),
                        Positioned(
                          bottom: 20,
                            left: 180,
                            child: buildIndicator()),
                      ],
                    ),
                  ),
                  Expanded(
                      child:Stack(
                        children:[
                          Container(
                            padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                          ),
                            child:SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${data['product_name']}',style: TextStyle(fontSize: 30)
                                        ),
                                      Text(
                                        '\$${data['price']}',style: TextStyle(fontSize: 30)
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Text("Description ",style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black
                                  ),),
                                  Text('${data['product_description']}',style: TextStyle(fontSize: 25,color: Colors.grey)),
                                  const SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: SizedBox(
                                          height: 50,
                                          width: 300,
                                          child: ElevatedButton(
                                              onPressed: ()=>{},
                                              child: Text("BUY",style: TextStyle(fontSize: 20),),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black, //background color of button
                                                  side: BorderSide(width:1.5, color:Colors.brown), //border width and color
                                                 //elevation of button
                                                  shape: RoundedRectangleBorder( //to set border radius to button
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  padding: EdgeInsets.all(10) //content padding inside button
                                              )
                                            ),
                                        ),
                                      )
                                    ],
                                  ),

                                ],
                              ),
                            ),
                        ),

                        ],
                      ),

                  ),
                ],

              ),
            );
          }else return Loading();
        });

  }
}
