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

  Widget _productCard({Cart cart}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Styles.cardRadius),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Styles.cardRadius),
                    child: cart.product.pictures.isNotEmpty
                        ? Image(
                            image: NetworkImage(cart.product.pictures[0]),
                            fit: BoxFit.contain,
                          )
                        : null,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          cart.product.name,
                          style: TextStyle(color: Styles.colors.text),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Durée de location: ',
                                  style: TextStyle(
                                    color: Styles.colors.unSelected,
                                  ),
                                ),
                                Text(
                                  '${cart.duration} mois',
                                  style: TextStyle(
                                    color: Styles.colors.text,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Prix / mois: ',
                                  style: TextStyle(
                                    color: Styles.colors.unSelected,
                                  ),
                                ),
                                Text(
                                  '${NumberFormatTool.formatPrice(cart.product.pricePerMonth)}€',
                                  style: TextStyle(
                                    color: Styles.colors.text,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                    Navigator.pushNamed(context, 'product/${cart.product.id}'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCardHeader({Order order}) {
    if (order.status == "En attente de paiement")
      order.status = "Paiement validé";
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                child: order.carts.isNotEmpty &&
                        order.carts.first.product.pictures.isNotEmpty
                    ? Image(
                        image:
                            NetworkImage(order.carts.first.product.pictures[0]),
                        fit: BoxFit.contain,
                      )
                    : null,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status: ',
                    style: TextStyle(
                      color: Styles.colors.unSelected,
                    ),
                  ),
                  Text(
                    '${order.status}',
                    style: TextStyle(
                      color: order.status == "Paiement validé"
                          ? Colors.green
                          : order.status == "En attente de paiement"
                              ? Colors.red
                              : order.status == "Commande remboursée"
                                  ? Colors.white54
                                  : Styles.colors.text,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Commande: ',
                    style: TextStyle(
                      color: Styles.colors.unSelected,
                    ),
                  ),
                  Text(
                    '${order.id}',
                    style: TextStyle(
                      color: Styles.colors.text,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ',
                    style: TextStyle(
                      color: Styles.colors.unSelected,
                    ),
                  ),
                  Text(
                    '${order.createdAt.substring(0, order.createdAt.indexOf('T'))}',
                    style: TextStyle(
                      color: Styles.colors.text,
                    ),
                  ),
                ],
              ),
              Divider(height: 10),
              Text(
                '${order.addressLine}, ${order.addressPostalCode} ${order.addressCity}, ${order.addressCountry}',
                style: TextStyle(
                  color: Styles.colors.text,
                ),
              ),
              Divider(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quantité: ',
                    style: TextStyle(
                      color: Styles.colors.unSelected,
                    ),
                  ),
                  Text(
                    '${order.carts.length}',
                    style: TextStyle(
                      color: Styles.colors.text,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Prix total / mois: ',
                    style: TextStyle(
                      color: Styles.colors.unSelected,
                    ),
                  ),
                  Text(
                    '${NumberFormatTool.formatPrice(order.total)}€',
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
              _orderCardHeader(order: order),
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
                      children: order.carts
                          .map((cart) => _productCard(cart: cart))
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
