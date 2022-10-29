import 'package:chic_store/constants/constants.dart';
import 'package:chic_store/screen/homepage.dart';
import 'package:chic_store/screen/loginpage.dart';
import 'package:chic_store/screen/profilepage.dart';
import 'package:chic_store/screen/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homeNavigationBar extends StatefulWidget {
  const homeNavigationBar({Key? key}) : super(key: key);
  @override
  State<homeNavigationBar> createState() => _homeNavigationBarState();
}

class _homeNavigationBarState extends State<homeNavigationBar> {
  final screen = [HomePage(), SearchPage(),Profile()];
  int _selectedScreenIndex = 0;
  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }
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

          drawer: Drawer(
            child: Column(children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
                accountName: Text("sessionUsername"),
                accountEmail: Text("mail"),
                currentAccountPicture:
                CircleAvatar(backgroundColor: Colors.black, child: Text("--")),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.home,
                ),
                title: Text("Home"),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.help,
                ),
                title: Text("Help"),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.help_center,
                ),
                title: Text("About"),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: ()  {
                  logout();
                },
              ),
            ]),
          ),
          body: screen[_selectedScreenIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedScreenIndex,
            unselectedItemColor: kDefaultNavigationBarIconColor,
            selectedItemColor: kDefaultNavigationBarIconColorselected,
            onTap: _selectScreen,
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }
}
