import 'package:flutter/material.dart';

import 'package:expand_widget/expand_widget.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/tools/NumberFormatTool.dart';
import 'package:tryme/widgets/GoBackTopBar.dart';
import 'package:tryme/widgets/Loading.dart';

class OrdersView extends StatefulWidget {
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  List<Order> _orders = List();
  bool _loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    Request.getOrders().then((orders) {
      setState(() {
        _orders = orders;
        _loading = false;
      });
    });
  }

  Widget _productCard({Product product}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Styles.cardRadius),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Styles.cardRadius),
                    child: product.pictures.isNotEmpty
                        ? Image(
                            image: NetworkImage(product.pictures[0]),
                            fit: BoxFit.contain,
                          )
                        : null,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: TextStyle(color: Styles.colors.text),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              product.description,
                              style: TextStyle(
                                  color: Styles.colors.unSelected,
                                  fontSize: 10),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '${NumberFormatTool.formatPrice(product.pricePerMonth)}€ / mois',
                              style: TextStyle(
                                color: Styles.colors.text,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(Styles.cardRadius),
                onTap: () =>
                    Navigator.pushNamed(context, 'product/${product.id}'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard({Order order}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Styles.colors.lightBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: order.products.isNotEmpty &&
                                  order.products.first.pictures.isNotEmpty
                              ? Image(
                                  image: NetworkImage(
                                      order.products.first.pictures[0]),
                                  fit: BoxFit.contain,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Commande: ${order.id}',
                          style: TextStyle(
                            color: Styles.colors.text,
                          ),
                        ),
                        Text(
                          'Total: ${NumberFormatTool.formatPrice(order.total)}€ / mois',
                          style: TextStyle(
                            color: Styles.colors.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ExpandChild(
                arrowPadding: const EdgeInsets.all(0.0),
                arrowColor: Styles.colors.background,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Divider(
                        color: Color(0xFF2A3C44),
                        thickness: 2.0,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: order.products
                          .map((product) => _productCard(product: product))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderList() {
    return ListView.builder(
      padding:
          const EdgeInsets.symmetric(horizontal: Styles.mainHorizontalPadding),
      itemCount: _orders.length,
      itemBuilder: (BuildContext context, int index) {
        return (_orderCard(order: _orders[index]));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Styles.mainHorizontalPadding),
              child: GoBackTopBar(title: "Commandes"),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _orderList(),
                  Loading(active: _loading),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
