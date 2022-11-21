import 'package:flutter/material.dart';

import '../constants/constants.dart';
class NoProducts extends StatelessWidget {
  const NoProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  height: 360,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network("https://i.pinimg.com/564x/c1/54/61/c15461a2984f9a7b183755bc85c55d49.jpg",height: 200,width: 200,),
                       Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text("There are no products less\nthan or equal to this price!",style: kDefaultStyleTextHomePage,),
                      ),
                    ],
                  ),
                ),
              )
            ));
  }
}
