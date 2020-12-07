import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Queries.dart';
import 'package:tryme/widgets/Filter.dart';

enum OrderBy { PRICE, NEW, NAME }

class Request {
  static Future<bool> getShoppingCard() async {
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Queries.shoppingCard(auth0User.uid)),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    if (!result.hasException && result.data['cartItem'] != null) {
      shoppingCard.shoppingCard =
          QueryParse.getShoppingCard(result.data['cartItem']);
      await shoppingCardTotal();
    }
    return (result.hasException);
  }

  static Future<bool> shoppingCardTotal() async {
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Queries.shoppingCardTotal()),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    if (!result.hasException &&
        result.data['totalCart'] != null &&
        result.data['totalCart']['total'] != null)
      shoppingCard.total = result.data['totalCart']['total'].toDouble();
    return (result.hasException);
  }

  static Future<bool> deleteShoppingCard(int id) async {
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Mutations.deleteShoppingCard(id)));
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

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
        QueryOptions(documentNode: gql(Queries.categories()));
    QueryResult result = await client.value.query(queryOption);

    if (result.data['category'] != null)
      QueryParse.getCategories(result.data['category']);
    return (result.hasException);
  }

  static Future<bool> modifyUserFirstName(String firstName) async {
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.modifyUserFirstName(
            auth0User.uid, firstName != null ? firstName : "")));
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<bool> modifyUserName(String name) async {
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(
            Mutations.modifyUserName(auth0User.uid, name != null ? name : "")));
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<bool> modifyUserPhone(String phone) async {
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.modifyUserPhone(
            auth0User.uid, phone != null ? phone : "")));
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<bool> modifyUserEmail(String email) async {
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.modifyUserEmail(
            auth0User.uid, email != null ? email : "")));
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<bool> modifyUserBirthday(String birthday) async {
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.modifyUserBirthday(
            auth0User.uid, birthday != null ? birthday : "")));
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<bool> modifyUserAddress(
      String street, String postcode, String city, String country) async {
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Mutations.modifyUserAddress(
            auth0User.uid, street, postcode, city, country)));
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
            product.description.replaceAll('\n', '\\n'))));
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<QueryResult> order(
      String currency,
      String city,
      String country,
      String address,
      int postalCode,
      String billingCity,
      String billingCountry,
      String billingAddress,
      int billingPostalCode) async {
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Mutations.orderPayment(
          currency,
          city,
          country,
          address,
          postalCode,
          billingCity,
          billingCountry,
          billingAddress,
          billingPostalCode)),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    return (result);
  }

  static Future<bool> payOrder(int orderId) async {
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Mutations.payOrder(orderId)),      fetchPolicy: FetchPolicy.cacheAndNetwork,
        );
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<Product> getProduct(int id) async {
    Product product = Product();
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Queries.product(id)));
    QueryResult result = await client.value.query(queryOption);

    if (result.hasException) {
      print('Request exception');
      return (Product());
    }
    if (result.data['product'] != null)
      product = QueryParse.getProduct(result.data['product'][0]);
    return (product);
  }

  static Future<List<Product>> getProducts(String category) async {
    ProductListData productList = ProductListData();
    QueryOptions queryOption =
        QueryOptions(documentNode: gql(Queries.products(category)));
    QueryResult result = await client.value.query(queryOption);

    productList = QueryParse.getProductList(result.data);
    return (productList.products);
  }

  static Future<ProductListData> getProductsSearch(
      String keywords, FilterOptions filterOptions, String sort) async {
    ProductListData productList = ProductListData();
    QueryOptions queryOption = QueryOptions(
        documentNode: gql(Queries.productsSearch(
            keywords,
            filterOptions.selectedCategory,
            filterOptions.selectedBrands,
            filterOptions.priceCurrent,
            sort)));
    QueryResult result = await client.value.query(queryOption);

    productList = QueryParse.getProductList(result.data);
    return (productList);
  }

  static Future<bool> addProductShoppingCard(int id, int duration) async {
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Mutations.addProduct(id, 1, duration)),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    return (result.hasException);
  }

  static Future<List<Order>> getOrders() async {
    List<Order> orders = List();
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Queries.orders()),
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
      documentNode: gql(Queries.ordersNumber("")),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    QueryResult result = await client.value.query(queryOption);

    if (!result.hasException)
      ordersNumber = result.data['order_aggregate']['aggregate']['count'];
    return (ordersNumber);
  }
}
