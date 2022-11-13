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
  final screen = [HomePage(), SearchPage(), Profile()];
  int _selectedScreenIndex = 0;
  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
          child: Scaffold(
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
      )),
    );
  }
}
