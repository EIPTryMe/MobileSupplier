import 'package:flutter/material.dart';

import 'package:tryme/Auth0API.dart';
import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/widgets/HeaderAuthentication.dart';
import 'package:tryme/widgets/Loading.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  var _email;
  var _password;
  String _error = '';
  bool _obscureText = true;
  bool _loading = false;

  void connection() {
    setState(() {
      _loading = true;
    });
    Request.getUser().whenComplete(() {
      if (user.companyId != null) {
        isLoggedIn = true;
        Navigator.pushNamedAndRemoveUntil(
            context, 'app', ModalRoute.withName('/'));
      } else {
        Auth0API.disconnect().whenComplete(() {
          setState(() {
            _error = 'Connectez-vous avec un compte entreprise';
            _loading = false;
          });
        });
      }
    });
  }

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
                  return "Vous n'avez pas saisi votre email";
                }
                _email = value;
                return null;
              },
            ),
          ),
        )),
      ],
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _passwordRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          color: Styles.colors.iconLock,
          size: 48.0,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Form(
            key: _formKeyPassword,
            child: TextFormField(
              obscureText: _obscureText,
              keyboardType: TextInputType.text,
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
                  hintText: "Mot de passe",
                  hintStyle: TextStyle(
                    color: Styles.colors.title,
                    fontSize: 13.0,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _toggle();
                    },
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_sharp
                          : Icons.visibility_off_sharp,
                      color: Styles.colors.title,
                    ),
                  )),
              validator: (value) {
                if (value.isEmpty) {
                  return "Vous n'avez pas saisi votre mot de passe";
                }
                _password = value;
                return null;
              },
            ),
          ),
        )),
      ],
    );
  }

  Widget goButton() {
    return Container(
      height: 58.0,
      child: RaisedButton(
        onPressed: () {
          if (_formKeyEmail.currentState.validate() &&
              _formKeyPassword.currentState.validate()) {
            setState(() {
              _loading = true;
            });
            Auth0API.login(_email, _password).then((isConnected) {
              if (isConnected) {
                connection();
              } else {
                setState(() {
                  _error = 'Email ou mot de passe invalide';
                  _loading = false;
                });
              }
            });
          }
        },
        textColor: Styles.colors.text,
        color: Styles.colors.main,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Go !"),
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30, bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderAuthentication(content: "Connectez-vous"),
                  _accountRow(),
                  _passwordRow(),
                  if (_error.isNotEmpty)
                    Text(
                      _error,
                      style: TextStyle(color: Colors.red),
                    ),
                  goButton(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(
                              color: Styles.colors.title, fontSize: 14.0),
                        ),
                        onTap: () {
                          Auth0API.resetPassword();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Loading(active: _loading),
          ],
        ),
      ),
    );
  }
}
