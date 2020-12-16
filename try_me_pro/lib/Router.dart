import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';

import 'package:tryme/App.dart';
import 'package:tryme/views/AddProductView.dart';
import 'package:tryme/views/LandingView.dart';
import 'package:tryme/views/OrdersView.dart';
import 'package:tryme/views/ProductEditView.dart';
import 'package:tryme/views/ProductView.dart';
import 'package:tryme/views/SearchResultView.dart';
import 'package:tryme/views/SignInView.dart';

class MyRouter {
  static FluroRouter router = FluroRouter();
  static Handler _appIndexHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          App(index: params['index'][0]));
  static Handler _appHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          App());
  static Handler _addProductHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          AddProductView());
  static Handler _landingHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LandingView());
  static Handler _ordersHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          OrdersView());
  static Handler _productHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductView(id: params['id'][0]));
  static Handler _productEditHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductEditView(id: params['id'][0]));
  static Handler _searchResultHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SearchResultView(
              category: params['category'][0],
              keywords: params['keywords'][0]));
  static Handler _signInHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SignInView());

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
      'addProduct',
      handler: _addProductHandler,
      transitionType: TransitionType.cupertinoFullScreenDialog,
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
      'product/:id',
      handler: _productHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'productEdit/:id',
      handler: _productEditHandler,
      transitionType: TransitionType.cupertinoFullScreenDialog,
    );
    router.define(
      'searchResult/:category/:keywords',
      handler: _searchResultHandler,
      transitionType: TransitionType.cupertino,
    );
    router.define(
      'signIn',
      handler: _signInHandler,
      transitionType: TransitionType.cupertino,
    );
  }
}
