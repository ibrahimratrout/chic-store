import 'package:chic_store/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoUser extends StatefulWidget {
  const InfoUser({Key? key}) : super(key: key);

  @override
  State<InfoUser> createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  String? token ;
  Stream<QuerySnapshot<Map<String, dynamic>>> getDataPerson() {
    return FirebaseFirestore.instance
        .collection("users")
        .where("token", isEqualTo: token)
        .snapshots();
  }
  readToken() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access_token';
    final value = prefs.get(key) ?? 0;
    setState(() {
      token=value.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readToken();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kDefaultAppBarBackgroundColor,
          title: Text(
            'About me',
            style: TextStyle(color: kDefaultColoranAppText),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: getDataPerson(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("${snapshot.error}",
                      style: TextStyle(
                          color: kDefaultColoranAppText,
                          fontSize: kDefaultSizeText));
                }
                if (snapshot.connectionState == ConnectionState) {
                  /// return Loading();
                }
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  return ListView.builder(
                    itemCount: data!.docs.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctx, index) {
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.all(15),
                            height: 60,
                            width: MediaQuery.of(context).size.width*  0.90,
                            child: Text('${data.docs[0]['name']}'),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: kDefaultHomeBoxShadow.withOpacity(0.5),
                                  blurRadius: 4,
                                  offset: Offset(4, 8),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(),
                          Container(
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(15),
                            height: 60,
                            width: MediaQuery.of(context).size.width* 0.90,
                            child: Text('${data.docs[0]['username']}'),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: kDefaultHomeBoxShadow.withOpacity(0.5),
                                  blurRadius: 4,
                                  offset: Offset(4, 8),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(),
                          Container(
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(15),
                            height: 60,
                            width: MediaQuery.of(context).size.width* 0.90,
                            child: Text('${data.docs[0]['address']}'),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: kDefaultHomeBoxShadow.withOpacity(0.5),
                                  blurRadius: 4,
                                  offset: Offset(4, 8),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(),
                        ],
                      );
                    },
                  );
                }
                return Text("");
              }),
        ),
      ),
    );
  }
}
