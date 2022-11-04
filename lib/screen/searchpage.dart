import 'package:chic_store/constants/constants.dart';
import 'package:chic_store/screen/singleProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _search = "";

  Stream<QuerySnapshot<Map<String, dynamic>>> getData() {
    return FirebaseFirestore.instance.collection('product').snapshots();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              actions: [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {});
                    })
              ],
              automaticallyImplyLeading: false,

              backgroundColor: Colors.black,
              title: Container(
                margin: EdgeInsets.all(1),
                child: TextFormField(
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Search...',
                  ),
                  onChanged: (val) {
                    setState(() {
                      _search = val;
                    });
                  },
                ),
              )),
          body: StreamBuilder<QuerySnapshot>(
            stream: getData(),
            builder: (context, snapshots) {
              if (snapshots.hasError) {
                return Text("Error",
                    style: TextStyle(
                        color: kDefaultColoranAppText,
                        fontSize: kDefaultSizeText));
              }
              if (snapshots.connectionState == ConnectionState) {
                return Text(
                  "Loading",
                  style: TextStyle(
                      color: kDefaultColoranAppText,
                      fontSize: kDefaultSizeText),
                );
              }

              if (snapshots.hasData) {
                return Container(
                  child: ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshots.data!.docs[index].data()
                            as Map<String, dynamic>;
                        if (data['product_name']
                            .toString()
                            .toLowerCase()
                            .startsWith(_search!.toLowerCase())) {
                          if (_search != "") {
                            return ListTile(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=> SingleProduct(productId: data['product_id'].toString())));

                              },
                              title: Text(
                                data['product_name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(data['image_url'][0]),
                              ),
                            );
                          }
                        }
                        return Container();
                      }),
                );
              }
              return Text("No Data");
            },
          )),
    );
  }
}
