import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:Scaffold(
        body: Center(
          child: LoadingAnimationWidget.inkDrop(
            color: Colors.black,
            size: 100,
          ),
        )));
  }
}
