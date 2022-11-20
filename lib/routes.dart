
import 'package:chic_store/screen/index.dart';
import 'package:chic_store/screen/homepage.dart';
import 'package:chic_store/screen/infouser.dart';
import 'package:chic_store/screen/loginpage.dart';
import 'package:chic_store/screen/signup.dart';
import 'package:chic_store/screen/signupwithemail.dart';


var kRoutes = {
   '/login': (context) => LoginPage(),
   '/signup': (context) => SignUp(),
   '/homepage':(context)=>HomePage(),
   '/':(context)=>HomeNavigationBar(),
   '/infouser':(context)=>InfoUser(),
   '/signupemail':(context)=>SignUpWithEmail(),
};
