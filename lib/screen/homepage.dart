import 'dart:ui';

import 'package:chic_store/model/categorymodel.dart';
import 'package:chic_store/screen/allProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/loadingWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  Stream<List<CategoryModel>> readData() =>
      db.collection('category').snapshots().map((event) => event.docs
          .map((e) => CategoryModel.fromFirestore((e.data())))
          .toList());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: kDefaultAppBarBackgroundColor,
        title: Text(
          "Chic Store",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(color: kDefaultAppBarColorTitile),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: kDefaultAppBarIconColor,
          ),
          splashColor: Colors.black,
          onPressed: () {},
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: kDefaultAppBarIconColor,
              ))
        ],
      ),
      body: Column(
            children: [
              Container(
                  child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Offers",
                          style: TextStyle(
                              color: kDefaultColoranAppText,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 240,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: kDefaultHomeBoxShadow.withOpacity(0.5),
                            blurRadius: 4,
                            offset: Offset(4, 8),
                          )
                        ],
                        image: DecorationImage(
                            image: AssetImage('images/664.jpg'), fit: BoxFit.fill)),
                  )
                ],
              )),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Category List",
                  style: TextStyle(
                      color: kDefaultColoranAppText,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Text(
                  "See All",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            child: StreamBuilder<List<CategoryModel>>(
                stream: readData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}",
                        style: TextStyle(
                            color: kDefaultColoranAppText,
                            fontSize: kDefaultSizeText));
                  }
                  if (snapshot.connectionState == ConnectionState) {
                    return Loading();
                  }
                  if (snapshot.hasData) {
                    final dataCategory = snapshot.data;
                    return Expanded(
                      child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dataCategory!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext ctx, index) {
                            final data = dataCategory[index];
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: ()=>{
                                    Navigator.push(context,
                                        MaterialPageRoute(builder:(context)=>AllProduct(catogeryId: data.category_id ,catogeryName: data.category_name,)))
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.all(15),
                                          padding: EdgeInsets.all(2),
                                          height: 200,
                                          width: 168,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft: Radius.circular(10),
                                                  bottomRight:
                                                  Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:kDefaultHomeBoxShadow
                                                      .withOpacity(0.5),
                                                  blurRadius: 4,
                                                  offset: Offset(4, 8),
                                                )
                                              ],
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    '${data.category_img_url}'),
                                                fit: BoxFit.fill,
                                              )),
                                        ),
                                      ),
                                      Text(
                                        '${data.category_name}',
                                        style: TextStyle(
                                            color: kDefaultColoranAppText,
                                            fontSize: kDefaultSizeText),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                    );
                  }
                  return Loading();
                }),
          ),
          SizedBox(  height: 10,
          )
        ]
      ),
    );
  }
}
