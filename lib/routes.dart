
import 'package:chic_store/screen/index.dart';
import 'package:chic_store/screen/homepage.dart';
import 'package:chic_store/screen/infouser.dart';
import 'package:chic_store/screen/loginpage.dart';
import 'package:chic_store/screen/signup.dart';
import 'package:chic_store/screen/singleProduct.dart';

var kRoutes = {
   '/login': (context) => LoginPage(),
   '/signup': (context) => SignUp(),
   '/homepage':(context)=>HomePage(),
   '/':(context)=>homeNavigationBar(),
   '/infouser':(context)=>InfoUser(),
};
