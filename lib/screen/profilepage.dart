import 'package:chic_store/constants/constants.dart';
import 'package:chic_store/widgets/profilewidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginpage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isSwitched =false;

  logout() async{
    final prefs = await SharedPreferences.getInstance();
    final removeAccessToken = await prefs.remove(KEY_ACCESS_TOKEN);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kDefaultAppBarBackgroundColor,
            centerTitle: true,
            title: Text(
              "Profile",
              style: TextStyle(color: kDefaultColoranAppText),
              textAlign: TextAlign.center,
            ),
          ),
          body: Container(
            child: Column(
              children: [
                // SizedBox(
                //   height: 115,
                //   width: 115,
                //   child: Container(
                //       margin: EdgeInsets.all(15),
                //       child: CircleAvatar(
                //         backgroundImage: AssetImage("images/664.jpg"),
                //       )),
                // ),
                ProfileWidget(
                  text: "My Account",
                  icon: Icons.person,
                  icon_end: Icons.arrow_forward_ios,
                  click:(){
                    Navigator.pushNamed(context, '/infouser');
                  }
                  ,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextButton(

                    style: TextButton.styleFrom(
                      primary:Colors.black,
                      padding: EdgeInsets.all(20),
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Color(0xFFF5F6F9),
                    ),
                    //  onPressed: press,
                    onPressed:(){},
                    child: Row(
                      children: [
                        Icon(Icons.notifications ,size: 22.0,color: Colors.black,),
                        SizedBox(width: 20),
                        Expanded(child: Text("Notifications")),
                        Container(
                          child: Switch(
                            value: isSwitched ,
                            activeTrackColor: Colors.black,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              print("VALUE : $value");
                              setState(() {
                                isSwitched = value;
                              });
                            },

                          ),
                        )
                        //  Icon(icon_end),

                      ],
                    ),
                  ),
                ),
                ProfileWidget(
                  text: "Settings",
                  icon: Icons.settings,
                  icon_end: Icons.arrow_forward_ios,
                  click: () {

                  },
                ),
                ProfileWidget(
                  text: "Logout",
                  icon: Icons.logout,
                  icon_end: Icons.arrow_forward_ios,
                  click: () {
                    logout();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
