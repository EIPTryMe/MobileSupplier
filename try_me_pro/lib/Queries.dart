import 'package:flutter/material.dart';
import 'package:tryme/Globals.dart';
import 'package:tryme/tools/AddressTool.dart';

class QueryParse {
  static Future getUser(Map result) async {
    user = User();
    if (result['address'] != null) user.address.street = result['address'];
    if (result['city'] != null) user.address.city = result['city'];
    if (result['postcode'] != null) user.address.postCode = result['postcode'];
    if (result['country'] != null) user.address.country = result['country'];
    user.address.fullAddress = await AddressTool.getAddressFromString(
        '${user.address.street} ${user.address.postCode} ${user.address.city} ${user.address.country}');
    if (result['phone'] != null) user.phone = result['phone'];
    if (result['email'] != null) user.email = result['email'];
    user.companyId = result['company_id'];
    if (result['company'] != null) {
      if (result['company']['name'] != null)
        user.name = result['company']['name'];
      if (result['company']['siret'] != null)
        user.siret = result['company']['siret'];
      if (result['company']['siren'] != null)
        user.siren = result['company']['siren'];
    }
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
        if (element['user'] != null) {
          if (element['user']['name'] != null)
            review.userName = element['user']['name'];
          if (element['user']['first_name'] != null)
            review.userFirstName = element['user']['first_name'];
        }
        if (element['score'] != null)
          review.score = element['score'].toDouble();
        if (element['description'] != null)
          review.description = element['description'];
        product.reviews.reviews.add(review);
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

  static Order getOrder(Map result) {
    Order order = Order();

    if (result['id'] != null) order.id = result['id'];
    if (result['status'] != null) order.status = result['status'];
    if (result['created_at'] != null) order.createdAt = result['created_at'];
    if (result['address_line_1'] != null)
      order.addressLine = result['address_line_1'];
    if (result['address_postal_code'] != null)
      order.addressPostalCode = result['address_postal_code'];
    if (result['address_city'] != null)
      order.addressCity = result['address_city'];
    if (result['address_country'] != null)
      order.addressCountry = result['address_country'];

    if (result['order_items'] != null) {
      (result['order_items'] as List).forEach((element) {
        Cart cart = Cart();
        if (element['quantity'] != null) cart.quantity = element['quantity'];
        if (element['duration'] != null) cart.duration = element['duration'];
        if (element['product'] != null)
          cart.product = getProduct(element['product']);
        order.carts.add(cart);
      });
    }
    order.carts.forEach((cart) {
      order.total += cart.product.pricePerMonth;
    });
    return (order);
  }

  static void getCategories(List result) {
    result.forEach((element) {
      Category category = Category();
      if (element['id'] != null) category.id = element['id'];
      if (element['name'] != null) category.name = element['name'];
      if (element['image'] != null) category.picture = element['image'];
      categories.add(category);
    });
  }
}

class Mutations {
  static String modifyUserName(String uid, String name, int companyId) => '''
  mutation {
    update_company(where: {id: {_eq: $companyId}}, _set: {name: "$name"}) {
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

  static String modifyUserAddress(String uid, String street, String postcode,
          String city, String country) =>
      '''
  mutation {
    update_user(where: {uid: {_eq: "$uid"}}, _set: {address: "$street", postcode: "$postcode", city: "$city", country: "$country"}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserSiret(int companyId, String siret) => '''
  mutation {
    update_company(where: {id: {_eq: $companyId}}, _set: {siret: "$siret"}) {
      affected_rows
    }
  }
  ''';

  static String modifyUserSiren(int companyId, String siren) => '''
  mutation {
    update_company(where: {id: {_eq: $companyId}}, _set: {siret: "$siren"}) {
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

  static String addProduct(
          int companyId,
          int categoryId,
          String name,
          String description,
          double pricePerMonth,
          String pictureUrl,
          int stock) =>
      '''
  mutation {
    createProduct(company_id: $companyId, category_id: $categoryId, name: "$name", description: "$description", price_per_month: $pricePerMonth, picture_url: "$pictureUrl", stock: $stock) {
      id
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
      picture_url
      reviews(order_by: {created_at: desc}) {
        created_at
        description
        score
        user {
          name
          first_name
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

  static String getKeywordsFilter(String keywords) =>
      '_or: [{name: {_ilike: "%$keywords%"}}]';

  static String getCategoryFilter(String category) =>
      category.isNotEmpty ? 'category: {name: {_eq: "$category"}}' : '';

  static String getPriceFilter(RangeValues price) =>
      price != RangeValues(0.0, 0.0)
          ? 'price_per_month: {_gte: ${price.start}, _lte: ${price.end}}'
          : '';

  static String getAllFilter(
          String keywords, String category, RangeValues price, int companyId) =>
      '${getKeywordsFilter(keywords)}, _and: {${getCategoryFilter(category)}, ${getPriceFilter(price)}, _and: {company: {id: {_eq: $companyId}}}}';

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
          RangeValues price, int companyId, String sort) =>
      '''
  query {
    product(where: {${getAllFilter(keywords, category, price, companyId)}}, order_by: {${getSorting(sort)}}) {
      id
      name
      brand
      price_per_month
      picture_url
    }
    product_aggregate(where: {${getAllFilter(keywords, category, RangeValues(0.0, 0.0), companyId)}}) {
      aggregate {
        max {
          price_per_month
        }
        min {
          price_per_month
        }
      }
    }
    category(where: {products: {${getAllFilter(keywords, category, price, companyId)}}}) {
      name
    }
  }
  ''';

  static String orders(int companyId) => '''
  query {
    order(where: {order_items: {product: {company_id: {_eq: $companyId}}}}, order_by: {created_at: desc}) {
      id
      status
      created_at
      address_line_1
      address_postal_code
      address_city
      address_country
      order_items(where: {product: {company_id: {_eq: $companyId}}}) {
        quantity
        duration
        product {
          id
          name
          description
          price_per_month
          picture_url
        }
      }
    }
  }
  ''';

  static String ordersNumber(int companyId) => '''
  query MyQuery {
    order_aggregate(where: {order_items: {product: {company_id: {_eq: $companyId}}}}, order_by: {created_at: desc}) {
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
      company {
        name
        siret
        siren
      }
    }
  }
  ''';

  static String categories(int companyId) => '''
  query {
    category(where: {products: {company: {id: {_eq: $companyId}}}}) {
      id
      name
      image
    }
  }
  ''';
}
