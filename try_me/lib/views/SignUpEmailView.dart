import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

import 'package:tryme/widgets/HeaderAuthentication.dart';

import 'package:tryme/tools/Validator.dart';

class SignUpEmailView extends StatefulWidget {
  @override
  _SignUpEmailViewState createState() => _SignUpEmailViewState();
}

Widget backButton(BuildContext context) {
  return Container(
    height: 58.0,
    width: 58.0,
    child: RaisedButton(
      onPressed: () => Navigator.pop(context),
      textColor: Styles.colors.text,
      color: Styles.colors.mainAlpha50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back),
        ],
      ),
    ),
  );
}

class _SignUpEmailViewState extends State<SignUpEmailView> {
  final _formKeyEmail = GlobalKey<FormState>();
  var _email;
  String error = '';

  Widget _accountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.account_box_rounded,
          color: Styles.colors.iconAccount,
          size: 48.0,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Form(
            key: _formKeyEmail,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Styles.colors.title,
                fontSize: 18.0,
              ),
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Styles.colors.title, width: 1.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Styles.colors.title, width: 1.0)),
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Styles.colors.title,
                    fontSize: 13.0,
                  )),
              validator: (value) {
                if (value.isEmpty) {
                  return "Vous n\'avez pas saisi votre email";
                }
                _email = value;
                return Validator.emailValidator(value);
              },
            ),
          ),
        )),
      ],
    );
  }

  Widget nextButton() {
    return Container(
      height: 58.0,
      child: RaisedButton(
        onPressed: () {
          if (_formKeyEmail.currentState.validate())
            Navigator.pushNamed(context, 'signUpPassword/$_email');
        },
        textColor: Styles.colors.text,
        color: Styles.colors.main,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Suivant"),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 58.0, horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderAuthentication(content: "Entrez votre email !"),
                _accountRow(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Row(
                    children: [
                      backButton(context),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: nextButton(),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}