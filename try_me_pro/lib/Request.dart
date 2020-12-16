import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Queries.dart';
import 'package:tryme/widgets/Filter.dart';

enum OrderBy { PRICE, NEW, NAME }

class Request {
  static Future<bool> getUser() async {
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Queries.user(auth0User.uid)));
    QueryResult result = await client.value.query(queryOption);

    if (result.data['user'] != null)
      await QueryParse.getUser(result.data['user'][0]);
    return (result.hasException);
  }

  static Future<bool> getCategories() async {
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Queries.categories(user.companyId)));
    QueryResult result = await client.value.query(queryOption);

    if (result.data['category'] != null)
      QueryParse.getCategories(result.data['category']);
    return (result.hasException);
  }

  static Future<bool> modifyUserName(String name) async {
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Mutations.modifyUserName(
          auth0User.uid, name != null ? name : "", user.companyId)),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<bool> modifyUserPhone(String phone) async {
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(
          Mutations.modifyUserPhone(auth0User.uid, phone != null ? phone : "")),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<bool> modifyUserEmail(String email) async {
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(
          Mutations.modifyUserEmail(auth0User.uid, email != null ? email : "")),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<bool> modifyUserAddress(
      String street, String postcode, String city, String country) async {
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Mutations.modifyUserAddress(
          auth0User.uid, street, postcode, city, country)),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<bool> modifyUserSiret(String siret) async {
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Mutations.modifyUserSiret(
          user.companyId, siret != null ? siret : "")),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<bool> modifyUserSiren(String siren) async {
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Mutations.modifyUserSiren(
          user.companyId, siren != null ? siren : "")),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<bool> modifyProduct(Product product) async {
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Mutations.modifyProduct(
          product.id,
          product.name,
          product.brand,
          product.pricePerMonth,
          product.stock,
          product.description.replaceAll('\n', '\\n'))),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<bool> addProduct(Product product, int categoryId) async {
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Mutations.addProduct(
          user.companyId,
          categoryId,
          product.name,
          product.description.replaceAll('\n', '\\n'),
          product.pricePerMonth,
          product.pictures.isNotEmpty ? product.pictures[0] : '',
          product.stock)),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<Product> getProduct(int id) async {
    Product product = Product();
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Queries.product(id)),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    if (result.hasException) {
      print('Request exception');
      return (Product());
    }
    if (result.data['product'] != null)
      product = QueryParse.getProduct(result.data['product'][0]);
    return (product);
  }

  static Future<ProductListData> getProductsSearch(
      String keywords, FilterOptions filterOptions, String sort) async {
    ProductListData productList = ProductListData();
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Queries.productsSearch(
          keywords,
          filterOptions.selectedCategory,
          filterOptions.priceCurrent,
          user.companyId,
          sort)),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    productList = QueryParse.getProductList(result.data);
    return (productList);
  }

  static Future<List<Order>> getOrders() async {
    List<Order> orders = List();
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Queries.orders(user.companyId)),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    if (result.data['order'] != null)
      (result.data['order'] as List).forEach((element) {
        orders.add(QueryParse.getOrder(element));
      });
    return (orders);
  }

  static Future<int> getOrdersNumber() async {
    int ordersNumber = 0;
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Queries.ordersNumber(user.companyId)),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    if (!result.hasException)
      ordersNumber = result.data['order_aggregate']['aggregate']['count'];
    return (ordersNumber);
  }
}
