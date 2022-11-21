import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constants/constants.dart';
import '../widgets/loadingWidget.dart';
import '../widgets/sizeSelector.dart';

class SingleProduct extends StatefulWidget {
  SingleProduct({required this.productId,});
  String? productId;
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
  int activeIndex = 0;
  var dataimages;
  var data;
  late int primaryColor ;
  late int primaryColorS ;
  var dataColor ;
  late Map<dynamic,dynamic> dataSizes;
  int indexB = 0 ;
  int indexS = 0 ;
  late bool isVisibleColors = false ;
  late bool isVisibleSize = false ;
  hexColor(String colorHex){
    String colornew = '0xFF'+colorHex ;
    colornew = colornew.replaceAll('#','');
    int colorInt = int.parse(colornew);
    return colorInt;
  }

  Widget buildIndicator()=>AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: dataimages.length,
    effect: SlideEffect(dotWidth: 15,dotHeight: 15 ,
        activeDotColor: Colors.black,
        dotColor: Colors.white54),
  );
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
            dataColor = snapshot.data?.docs[0]['color'];
            primaryColor = hexColor(dataColor[indexB]);
            primaryColorS = hexColor(dataColor[indexS]);
            if(snapshot.data?.docs[0]['category_id']=="1" || snapshot.data?.docs[0]['category_id']=="3") {
              isVisibleColors = true;
            }else{ isVisibleColors = false;}
            if(snapshot.data?.docs[0]['category_id']=="3") {
              dataSizes = snapshot.data?.docs[0]['size'];
              isVisibleSize = true;
            }else{ isVisibleSize = false;}
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
              backgroundColor: Color(primaryColor),
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
                            enableInfiniteScroll: false,
                            onPageChanged: (index,reason)=>
                                setState(() {
                                  activeIndex = index;
                                  indexB = index;
                                }),
                          ),
                          itemBuilder: (context,index,realIndex){
                            return Image.network('${dataimages[index]}',
                              fit: BoxFit.fill,
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
                          padding: const EdgeInsets.only(top: 14, right: 14, left: 14),
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(22),
                                topLeft: Radius.circular(22),
                              )
                          ),
                          child:SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Product Name',style: kDefaultStyleHeadTextSingleProduct
                                ),
                                kDefaultSpace15,
                                Text('${data['product_name']}',
                                  style: kDefaultStyleTextSingleProduct,
                                ),
                                kDefaultSpace25,
                                Text(
                                    'Product Price ',style: kDefaultStyleHeadTextSingleProduct
                                ),

                                kDefaultSpace15,
                                Text('₪ ${data['price']-1}.99',style: kDefaultStyleTextSingleProduct
                                ),
                                kDefaultSpace25,
                                Visibility(
                                    visible: isVisibleColors,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Color",style: kDefaultStyleHeadTextSingleProduct),
                                        kDefaultSpace15,
                                        buildColorIcons(),
                                        kDefaultSpace25,
                                      ],
                                    )
                                ),
                                Visibility(
                                    visible: isVisibleSize,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Size",style: kDefaultStyleHeadTextSingleProduct),
                                        kDefaultSpace15,
                                        if(snapshot.data?.docs[0]['category_id']=="3")
                                        SizeSelector(sizes: dataSizes),
                                        kDefaultSpace25,
                                      ],
                                    )
                                ),
                                Text("Description ",style: kDefaultStyleHeadTextSingleProduct),
                                kDefaultSpace15,
                                Text('${data['product_description']}',style: kDefaultStyleTextSingleProduct),
                                const SizedBox(height: 60),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: SizedBox(
                                  height: 50,
                                  width: 300,
                                  child: ElevatedButton(
                                      onPressed: ()=>{},
                                      child: Text("BUY",style: TextStyle(fontSize: 20)),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          side: BorderSide(width:1.5, color:Colors.brown),
                                          //elevation of button
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          padding: EdgeInsets.all(10)
                                      )
                                  ),
                                ),
                              )
                            ],
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
  Widget buildColorIcons() => Row(
    children: [for (var i = 0; i < dataColor.length; i++) buildIconBtn(hexColor(dataColor[i]),i)],
  );
  Widget buildIconBtn(int myColor,int il) => Container(
    child: Stack(
      children: [
        Positioned(
          top: 12.5,
          left: 12.5,
          child: Icon(
            Icons.check,
            size: 22,
            color: primaryColorS == myColor ? Color(myColor)  : Colors.transparent,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.square,
            color: Color(myColor).withOpacity(0.65),
            size: 25,
          ),
          onPressed: () {
            setState(() {
              indexS = il;
            });
          },
        ),
      ],
    ),
  );
}
