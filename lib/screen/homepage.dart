import 'dart:ui';

import 'package:chic_store/model/categorymodel.dart';
import 'package:chic_store/screen/allProduct.dart';
import 'package:chic_store/widgets/productCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../model/productmdel.dart';
import '../widgets/loadingWidget.dart';
import 'loginpage.dart';

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
  Stream<List<Product>> getTimedProduct()=>
      db.collection("product")
          .where("created_at", isLessThanOrEqualTo: DateTime.now()).orderBy("created_at", descending: true).limit(6)
          .snapshots().map((event) => event.docs.map((e) =>
          Product.fromJson((e.data()))).toList());
  String? token;
  readToken() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access_token';
    token = prefs.getString(key);
  }
  logout() async{
    final prefs = await SharedPreferences.getInstance();
    final removeAccessToken = await prefs.remove(KEY_ACCESS_TOKEN);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()));
  }
  @override
  void initState() {
    super.initState();
    readToken();
  }
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: scaffoldState,
      drawer: Drawer(
        child:
        Column(
            children: [
              ListTile(
                leading: Icon(Icons.home,),
                title: Text("Home"),
                onTap: () {
                  scaffoldState.currentState!.closeDrawer();
                } ,
              ),
              ListTile(
                leading: Icon(Icons.person,),
                title: Text("My Account"),
                onTap: () { Navigator.pushNamed(context, '/infouser');} ,
              ),
              ListTile(
                leading: Icon(Icons.help,),
                title: Text("Help"),
                onTap: () {} ,
              ),

              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () {
                  logout();
                } ,
              ),


            ]),),
      appBar: AppBar(
        backgroundColor: kDefaultAppBarBackgroundColor,
        title: Text(
          "Chic Store",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        titleTextStyle:kDefaultStyleTextTitlte,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: kDefaultAppBarIconColor,
          ),
          splashColor: Colors.black,
          onPressed: () {

            scaffoldState.currentState!.openDrawer();
          },
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
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            children: [
              Column(
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
                            "Offers", style: kDefaultStyleTextHomePage),
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
                  ),   kDefaultSpace25,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Category List",
                          style: kDefaultStyleTextHomePage,
                        ),
                        Text(
                          "See All",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height:250,
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
                            return ListView.builder(
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
                                          print("object ${token}"),

                                          Navigator.push(context,
                                              MaterialPageRoute(builder:(context)=>AllProduct(catogeryId: data.category_id ,catogeryName: data.category_name,)))
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10),
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
                                                      blurRadius: 2,
                                                      offset: Offset(1, 4),
                                                    )
                                                  ],
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        '${data.category_img_url}'),
                                                    fit: BoxFit.fill,
                                                  )),

                                            ),
                                            SizedBox(height: 10,),
                                            Text(
                                                '${data.category_name}',
                                                style: kDefaultStyleTextCategory),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          }
                          return  Text("");
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Newly added",
                          style: kDefaultStyleTextHomePage,
                        ),
                        Text(
                          "See All",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 200,
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(2),
                    child: StreamBuilder(
                        stream: getTimedProduct(),
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
                            final timedProduct = snapshot.data;
                            return  ListView.builder(
                                itemCount: timedProduct!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext ctx, index){
                                  final dataTimedProduct = timedProduct[index];
                                  return ProductCard(product: dataTimedProduct);
                                }
                            );
                          }
                          return Text("");
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ]
        ),
      ),

    );
  }
}
