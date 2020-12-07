import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';

import 'package:tryme/App.dart';
import 'package:tryme/views/LandingView.dart';
import 'package:tryme/views/OrdersView.dart';
import 'package:tryme/views/OrderFinishedView.dart';
import 'package:tryme/views/ProductView.dart';
import 'package:tryme/views/PaymentView.dart';
import 'package:tryme/views/SearchResultView.dart';
import 'package:tryme/views/ShoppingCardView.dart';
import 'package:tryme/views/SignInView.dart';
import 'package:tryme/views/SignUpEmailView.dart';
import 'package:tryme/views/SignUpPasswordView.dart';

class MyRouter {
  static FluroRouter router = FluroRouter();
  static Handler _appIndexHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          App(index: params['index'][0]));
  static Handler _appHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          App());
  static Handler _landingHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LandingView());
  static Handler _ordersHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          OrdersView());
  static Handler _orderFinishedHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          OrderFinishedView());
  static Handler _productHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductView(id: params['id'][0]));
  static Handler _searchResultHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SearchResultView(
              category: params['category'][0],
              keywords: params['keywords'][0]));
  static Handler _shoppingCardHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ShoppingCardView());
  static Handler _signInHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SignInView());
  static Handler _signUpEmailViewHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SignUpEmailView());
  static Handler _signUpPasswordViewHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SignUpPasswordView(email: params['email'][0]));
  static Handler _paymentViewHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          PaymentView());

  static void setupRouter() {
    router.define(
      'app/:index',
      handler: _appIndexHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'app',
      handler: _appHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'landing',
      handler: _landingHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'orders',
      handler: _ordersHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'orderFinished',
      handler: _orderFinishedHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'product/:id',
      handler: _productHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'searchResult/:category/:keywords',
      handler: _searchResultHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'shoppingCard',
      handler: _shoppingCardHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'signIn',
      handler: _signInHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'signUpEmail',
      handler: _signUpEmailViewHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'signUpPassword/:email',
      handler: _signUpPasswordViewHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'payment',
      handler: _paymentViewHandler,
      transitionType: TransitionType.cupertino,
    );
  }
}
