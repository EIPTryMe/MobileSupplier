import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/views/HomeView.dart';
import 'package:tryme/views/ShoppingCardView.dart';
import 'package:tryme/views/UserInformationView.dart';

class App extends StatefulWidget {
  App({this.index});

  final String index;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List _widgets = [
    ShoppingCardView(),
    HomeView(),
    UserInformationView(),
  ];
  int _currentIndex = 1;

  @override
  void initState() {
    if (widget.index != null) _currentIndex = int.parse(widget.index);
    super.initState();
  }

  Widget _bottomNavBar() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Styles.cardRadius)),
        boxShadow: [
          BoxShadow(
            color: Styles.colors.background,
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        child: BottomNavigationBar(
          backgroundColor: Styles.colors.lightBackground,
          selectedItemColor: Styles.colors.main,
          unselectedItemColor: Styles.colors.unSelected,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              label: 'Panier',
              icon: Icon(
                Icons.shopping_cart,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Accueil',
              icon: Icon(
                Icons.home_filled,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Compte',
              icon: Icon(
                Icons.person,
                size: 30,
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              if (isLoggedIn == false && (index == 0 || index == 2))
                Navigator.pushNamed(context, 'signIn');
              else
                _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: SafeArea(
        child: _widgets[_currentIndex],
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }
}
