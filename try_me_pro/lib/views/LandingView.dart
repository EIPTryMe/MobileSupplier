import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tryme/Auth0API.dart';
import 'package:tryme/Globals.dart';

class LandingView extends StatefulWidget {
  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  int _seconds = 3;
  bool _lock = true;
  Timer _timer;

  void viewTimeout() {
    if (!_lock) {
      if (isLoggedIn)
        Navigator.pushNamedAndRemoveUntil(
            context, 'app', ModalRoute.withName('/'));
      else
        Navigator.popAndPushNamed(context, 'signIn');
    }
  }

  void autoLogin() async {
    Auth0API.getLastUser().then((success) {
      setState(() {
        _lock = false;
      });
      if (success)
        Auth0API.initData().whenComplete(() {
          if (!_timer.isActive) viewTimeout();
        });
    });
  }

  @override
  void initState() {
    _timer = Timer(Duration(seconds: this._seconds), viewTimeout);
    autoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image(
        image: AssetImage("assets/landingView.jpg"),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
