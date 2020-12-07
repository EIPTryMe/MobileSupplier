library my_prj.globals;

import 'package:flutter/material.dart';

import 'package:geocoder/geocoder.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tryme/GraphQLConfiguration.dart';

class Auth0User {
  Auth0User({this.uid = "", this.picture = "", this.isEmailVerified = false});

  String uid;
  String picture;
  bool isEmailVerified;
}

class User {
  User(
      {this.id = 0,
      this.firstName = "",
      this.lastName = "",
      this.address,
      this.phone = "",
      this.email = "",
      this.birthday = "",
      this.picture = "",
      this.companyId}) {
    if (address == null) address = UserAddress();
  }

  int id;
  String firstName;
  String lastName;
  UserAddress address;
  String phone;
  String email;
  String birthday;
  String picture;
  int companyId;
}

class UserAddress {
  UserAddress(
      {this.street = "",
      this.postCode = "",
      this.city = "",
      this.country = "",
      this.fullAddress}) {
    if (fullAddress == null) fullAddress = Address();
  }

  String street;
  String postCode;
  String city;
  String country;
  Address fullAddress;
}

class Review {
  Review({this.date = "", this.user = "", this.score = 0.0, this.description = ""});

  String date;
  String user;
  double score;
  String description;
}

class Reviews {
  Reviews({this.reviews, this.averageRating = 0.0}) {
    if (reviews == null) reviews = List();
  }

  List<Review> reviews;
  double averageRating;
}

class Product {
  Product(
      {this.id = 0,
      this.name = "",
      this.brand = "",
      this.pricePerMonth = 0.0,
      this.stock = 0,
      this.description = "",
      this.specifications,
      this.reviews,
      this.pictures}) {
    if (specifications == null) specifications = List();
    if (reviews == null) reviews = Reviews();
    if (pictures == null) pictures = List();
  }

  int id;
  String name;
  String brand;
  double pricePerMonth;
  int stock;
  String description;
  List specifications;
  Reviews reviews;
  List pictures;
}

class Cart {
  Cart({this.product, this.duration = 0, this.quantity = 0, this.id = 0}) {
    if (product == null) product = Product();
  }

  Product product;
  int duration;
  int quantity;
  int id;
}

class Order {
  Order({this.id = 0, this.total = 0.0, this.status = "", this.products}) {
    if (products == null) products = List();
  }

  int id;
  double total;
  String status;
  List<Product> products;
}

class Category {
  Category({this.name = "", this.picture = ""});

  String name;
  String picture;
}

class ProductListData {
  ProductListData(
      {this.products, this.categories, this.brands, this.priceRange}) {
    if (products == null) products = List();
    if (categories == null) categories = List();
    if (brands == null) brands = List();
    if (priceRange == null) priceRange = RangeValues(0.0, 0.0);
  }

  List<Product> products;
  List<String> categories;
  List<String> brands;
  RangeValues priceRange;
}

class ShoppingCard {
  ShoppingCard({this.shoppingCard, this.total = 0.0}) {
    if (shoppingCard == null) shoppingCard = List();
  }

  List<Cart> shoppingCard;
  double total;
}

ValueNotifier<GraphQLClient> client = getGraphQLClient();

bool isLoggedIn = false;

Auth0User auth0User = Auth0User();
User user = User();

List<Category> categories = List();
ShoppingCard shoppingCard = ShoppingCard();

const String mapApiKey = 'AIzaSyBOfQxDPTnCGCVw-OMy4yt4Iy9LgMCKbcQ';
