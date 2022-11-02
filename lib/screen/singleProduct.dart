import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/loadingWidget.dart';

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
  var dataColor ;
  int indexB = 0 ;
  late bool isVisible = false ;
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
            if(snapshot.data?.docs[0]['category_id']=="1") {
              isVisible = true;
            }else{ isVisible = false;}
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
                                    'Product Name',style: TextStyle(fontSize: 20,color: Colors.grey)
                                ),
                                const SizedBox(height: 15),
                                Text(
                                    '${data['product_name']}',style: TextStyle(fontSize: 28)
                                ),
                                const SizedBox(height: 25),
                                Text(
                                    'Product Price ',style: TextStyle(fontSize: 20,color: Colors.grey)
                                ),
                                const SizedBox(height: 15),
                                Text(
                                    '₪ ${data['price']-1}.99',style: TextStyle(fontSize: 30)
                                ),
                                const SizedBox(height: 25),
                                Text("Description ",style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey
                                ),),
                                const SizedBox(height: 15),
                                Text('${data['product_description']}',style: TextStyle(fontSize: 25,color: Colors.black)),
                                const SizedBox(height: 30),
                                Visibility(
                                    visible: isVisible,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Color",style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.black
                                        ),),
                                        buildColorIcons(),
                                        const SizedBox(height: 50),
                                      ],
                                    )
                                ),
                                const SizedBox(height: 50),
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
            color: primaryColor == myColor ? Color(myColor)  : Colors.transparent,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.circle,
            color: Color(myColor).withOpacity(0.65),
            size: 25,
          ),
          onPressed: () {
            setState(() {
              indexB = il;
              activeIndex=il;
            });
          },
        ),
      ],
    ),
  );
}
