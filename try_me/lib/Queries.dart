import 'package:flutter/material.dart';
import 'package:tryme/Globals.dart';
import 'package:tryme/tools/AddressTool.dart';

class QueryParse {
  static Future getUser(Map result) async {
    user = User();
    if (user.picture == null) print('fuck');
    if (result['id'] != null) user.id = result['id'];
    if (result['first_name'] != null) user.firstName = result['first_name'];
    if (result['name'] != null) user.lastName = result['name'];
    if (result['address'] != null) user.address.street = result['address'];
    if (result['city'] != null) user.address.city = result['city'];
    if (result['postcode'] != null) user.address.postCode = result['postcode'];
    if (result['country'] != null) user.address.country = result['country'];
    user.address.fullAddress = await AddressTool.getAddressFromString(
        '${user.address.street} ${user.address.postCode} ${user.address.city} ${user.address.country}');
    if (result['phone'] != null) user.phone = result['phone'];
    if (result['email'] != null) user.email = result['email'];
    if (result['birth_date'] != null) user.birthday = result['birth_date'];
    user.companyId = result['company_id'];
    user.picture = auth0User.picture;
  }

  static Product getProduct(Map result) {
    Product product = Product();

    if (result['id'] != null) product.id = result['id'];
    if (result['name'] != null) product.name = result['name'];
    if (result['brand'] != null) product.brand = result['brand'];
    if (result['stock'] != null) product.stock = result['stock'];
    if (result['price_per_month'] != null)
      product.pricePerMonth = result['price_per_month'] != null
          ? result['price_per_month'].toDouble()
          : null;
    if (result['stock'] != null) product.stock = result['stock'];
    if (result['description'] != null)
      product.description = result['description'];
    if (result['product_specifications'] != null)
      product.specifications = result['product_specifications'];
    if (result['reviews'] != null) {
      (result['reviews'] as List).forEach((element) {
        Review review = Review();
        if (element['created_at'] != null) review.date = element['created_at'];
        if (element['user'] != null && element['user']['name'] != null)
          review.user = element['user']['name'];
        if (element['score'] != null)
          review.score = element['score'].toDouble();
        if (element['description'] != null)
          review.description = element['description'];
        product.reviews.reviews.add(review);
        print(review.user);
      });
    }
    if (result['reviews_aggregate'] != null &&
        result['reviews_aggregate']['aggregate'] != null &&
        result['reviews_aggregate']['aggregate']['avg'] != null &&
        result['reviews_aggregate']['aggregate']['avg']['score'] != null)
      product.reviews.averageRating =
          result['reviews_aggregate']['aggregate']['avg']['score'].toDouble();
    if (result['picture_url'] != null) {
      product.pictures.add(result['picture_url'].trim());
    }
    return (product);
  }

  static ProductListData getProductList(Map result) {
    ProductListData productList = ProductListData();
    double min = 0.0;
    double max = 0.0;

    if (result['product'] != null)
      (result['product'] as List).forEach((element) {
        productList.products.add(getProduct(element));
      });
    if (result['product_aggregate'] != null &&
        result['product_aggregate']['aggregate'] != null) {
      if (result['product_aggregate']['aggregate']['min'] != null &&
          result['product_aggregate']['aggregate']['min']['price_per_month'] !=
              null)
        min = result['product_aggregate']['aggregate']['min']['price_per_month']
            .toDouble();
      if (result['product_aggregate']['aggregate']['max'] != null &&
          result['product_aggregate']['aggregate']['max']['price_per_month'] !=
              null)
        max = result['product_aggregate']['aggregate']['max']['price_per_month']
            .toDouble();
    }
    if (result['category'] != null)
      (result['category'] as List).forEach((category) {
        if (category['name'] != null)
          productList.categories.add(category['name']);
      });
    productList.priceRange = RangeValues(min, max);
    return (productList);
  }

  static List<Cart> getShoppingCard(List result) {
    List<Cart> shoppingCard = List();

    result.forEach((element) {
      Product product = Product();
      int duration = 0;
      int quantity = 0;
      int id = 0;
      if (element['duration'] != null) duration = element['duration'];
      if (element['quantity'] != null) quantity = element['quantity'];
      if (element['id'] != null) id = element['id'];
      if (element['product'] != null) {
        if (element['product']['id'] != null)
          product.id = element['product']['id'];
        if (element['product']['name'] != null)
          product.name = element['product']['name'];
        if (element['product']['price_per_month'] != null)
          product.pricePerMonth =
              element['product']['price_per_month'].toDouble();
        if (element['product']['picture_url'] != null)
          product.pictures.add(element['product']['picture_url']);
        shoppingCard.add(Cart(
            product: product, duration: duration, quantity: quantity, id: id));
      }
    });
    return (shoppingCard);
  }

  static Order getOrder(Map result) {
    Order order = Order();
    List<Product> products = List();

    if (result['id'] != null) order.id = result['id'];

    (result['order_items'] as List).forEach((element) {
      products.add(getProduct(element['product']));
    });
    order.products = products;
    if (result['order_items_aggregate'] != null &&
        result['order_items_aggregate']['aggregate'] != null &&
        result['order_items_aggregate']['aggregate']['sum'] != null &&
        result['order_items_aggregate']['aggregate']['sum']['price'] != null)
      order.total = result['order_items_aggregate']['aggregate']['sum']['price']
          .toDouble();
    return (order);
  }

  static void getCategories(List result) {
    result.forEach((element) {
      Category category = Category();
      if (element['name'] != null) category.name = element['name'];
      if (element['image'] != null) category.picture = element['image'];
      categories.add(category);
    });
  }
}

class Mutations {
  static String addProduct(int id, int quantity, int duration) => '''
  mutation {
    createCartItem(product_id: $id, quantity: $quantity, duration: $duration) {
      id
    }
  }
  ''';

  static String deleteShoppingCard(int id) => '''
  mutation {
    delete_cartItem(where: {id: {_eq: $id}}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserFirstName(String uid, String firstName) => '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {first_name: "$firstName"}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserName(String uid, String name) => '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {name: "$name"}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserPhone(String uid, String phone) => '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {phone: "$phone"}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserEmail(String uid, String email) => '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {email: "$email"}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserBirthday(String uid, String birthday) => '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {birth_date: "$birthday"}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserAddress(String uid, String street, String postcode,
          String city, String country) =>
      '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {address: "$street", postcode: "$postcode", city: "$city", country: "$country"}) {
      affected_rows
    }
  }
  ''';

  static String modifyProduct(int id, String title, String brand,
          double monthPrice, int stock, String description) =>
      '''
  mutation {
    update_product(_set: {name: "$title", brand: "$brand", price_per_month: "$monthPrice", stock: $stock, description: "$description"}, where: {id: {_eq: $id}}) {
      affected_rows
    }
  }
  ''';

  static String orderPayment(
          String currency,
          String city,
          String country,
          String address,
          int postalCode,
          String billingCity,
          String billingCountry,
          String billingAddress,
          int billingPostalCode) =>
      '''
  mutation {
    orderPayment(currency: "$currency", addressDetails: {address_city: "$city", address_country: "$country", address_line_1: "$address", address_postal_code: $postalCode}, billingDetails: {billing_city: "$billingCity", billing_country: "$billingCountry", billing_address_line_1: "$billingAddress", billing_postal_code: $billingPostalCode}) {
      order_id
      clientSecret
      publishableKey
    }
  }
  ''';

  static String payOrder(int orderId) => '''
  mutation {
    payOrder(order_id: $orderId) {
      stripe_id
    }
  }
  ''';
}

class Queries {
  static String product(int id) => '''
  query {
    product(where: {id: {_eq: $id}}) {
      id
      name
      brand
      price_per_month
      stock
      description
      product_specifications {
        name
      }
      picture_url
      reviews(order_by: {created_at: desc}) {
        created_at
        description
        score
        user {
          name
        }
      }
      reviews_aggregate {
        aggregate {
          avg {
            score
          }
        }
      }
    }
  }
  ''';

  static String products(String category) => '''
  query {
    product(where: {category: {name: {_eq: "$category"}}}) {
      id
      name
      price_per_month
      picture_url
    }
  }
  ''';

  static String getKeywordsFilter(String keywords) =>
      '_or: [{name: {_ilike: "%$keywords%"}}, {category: {name: {_ilike: "%$keywords%"}}}, {brand: {_ilike: "%$keywords%"}}]';

  static String getCategoryFilter(String category) =>
      category.isNotEmpty ? 'category: {name: {_eq: "$category"}}' : '';

  static String getBrandFilter(List<String> brands) {
    String brandsStr = '';

    for (int i = 0; i < brands.length; ++i) {
      brandsStr += '"${brands[i]}"';
      if (i + 1 >= brands.length) brandsStr += ', ';
    }
    return (brands.isNotEmpty ? 'brand: {_in: [$brandsStr]}' : '');
  }

  static String getPriceFilter(RangeValues price) =>
      price != RangeValues(0.0, 0.0)
          ? 'price_per_month: {_gte: ${price.start}, _lte: ${price.end}}'
          : '';

  static String getAllFilter(String keywords, String category,
          List<String> brands, RangeValues price) =>
      '${getKeywordsFilter(keywords)}, _and: {${getCategoryFilter(category)}, ${getBrandFilter(brands)}, ${getPriceFilter(price)}}';

  static String getSorting(String sort) {
    String orderBy = '';

    if (sort == 'Pertinence')
      orderBy = '';
    else if (sort == 'Prix (Croissant)')
      orderBy = 'price_per_month: asc';
    else if (sort == 'Prix (Décroissant)')
      orderBy = 'price_per_month: desc';
    else if (sort == 'Note moyenne')
      orderBy = 'reviews_aggregate: {avg: {score: desc_nulls_last}}';
    else if (sort == 'Nouveauté') orderBy = 'created_at: desc';
    return (orderBy);
  }

  static String productsSearch(String keywords, String category,
          List<String> brands, RangeValues price, String sort) =>
      '''
  query {
    product(where: {${getAllFilter(keywords, category, brands, price)}}, order_by: {${getSorting(sort)}}) {
      id
      name
      brand
      price_per_month
      picture_url
    }
    product_aggregate(where: {${getAllFilter(keywords, category, brands, RangeValues(0.0, 0.0))}}) {
      aggregate {
        max {
          price_per_month
        }
        min {
          price_per_month
        }
      }
    }
    category(where: {products: {${getAllFilter(keywords, category, brands, price)}}}) {
      name
    }
  }
  ''';

  static String shoppingCard(String uid) => '''
  query {
    cartItem(where: {userUid: {_eq: "$uid"}}, order_by: {id: desc}) {
      duration
      product {
        name
        price_per_month
        picture_url
        id
      }
      quantity
      id
    }
  }
  ''';

  static String shoppingCardTotal() => '''
  query totalCart {
    totalCart {
      total
    }
  }
  ''';

  static String orders() => '''
  query {
    order(where: {user_uid: {_eq: "${auth0User.uid}"}}, order_by: {created_at: desc}) {
      order_items {
        product {
          id
          name
          description
          price_per_month
          picture_url
        }
      }
      id
      order_items_aggregate {
        aggregate {
          sum {
            price
          }
        }
      }
    }
  }
  ''';

  static String ordersNumber(String status) => '''
  query MyQuery {
    order_aggregate(where: {user_uid: {_eq: "${auth0User.uid}"}}) {
      aggregate {
        count
      }
    }
  }
  ''';

  static String user(String uid) => '''
  query {
    user(where: {uid: {_eq: "$uid"}}) {
      id
      first_name
      name
      address
      city
      country
      postcode
      birth_date
      phone
      email
      company_id
    }
  }
  ''';

  static String categories() => '''
  query {
    category {
      name
      image
    }
  }
  ''';
}
