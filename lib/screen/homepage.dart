import 'package:chic_store/model/categorymodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          child: StreamBuilder<List<CategoryModel>>(
              stream: readData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error");
                }
                if (snapshot.connectionState == ConnectionState) {
                  return Text("Loading");
                }
                if (snapshot.hasData) {
                  final dataCategory = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    // implement GridView.builder
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemCount: dataCategory!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          final data = dataCategory[index];
                          return SingleChildScrollView(
                              child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(

                                alignment: Alignment.center,
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Image.network(
                                  '${data.category_img_url}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text('${data.category_name}'),
                            ],
                          ));
                        }),
                  );
                }
                return Text("no data");
              }),
        ),
      ),
    );
  }
}
