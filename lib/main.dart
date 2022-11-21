import 'package:chic_store/constants/constants.dart';
import 'package:chic_store/routes.dart';
import 'package:chic_store/widgets/loadingWidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? token;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? token;
  bool login = true;

  @override
  Widget build(BuildContext context) {
    if (login) {
      final prefs = SharedPreferences.getInstance().then((value) => {
            setState(() {
              login = false;
              token = value.getString(KEY_ACCESS_TOKEN);
            })
          });
      return Loading();
    } else {
      if (token == null) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/login',
            routes: kRoutes);
      } else {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: kRoutes);
      }
    }
  }
}
