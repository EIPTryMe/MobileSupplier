import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

class HeaderAuthentication extends StatefulWidget {
  final String content;

  HeaderAuthentication({Key key, @required this.content}) : super(key: key);

  @override
  _HeaderAuthenticationState createState() =>
      _HeaderAuthenticationState(content);
}

class _HeaderAuthenticationState extends State<HeaderAuthentication> {
  String content;

  _HeaderAuthenticationState(this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Image(image: AssetImage("assets/logoTryMe.png"), fit: BoxFit.contain,
              width: 150,),
          ),
          Text(
            'Bienvenue !',
            style: TextStyle(
              fontSize: 42.0,
              color: Styles.colors.text,
            ),
          ),
          Text(
            this.content,
            style: TextStyle(
              fontSize: 24.0,
              color: Styles.colors.title,
            ),
          ),
        ],
      ),
    );
  }
}
