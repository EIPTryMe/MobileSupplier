import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/tools/NumberFormatTool.dart';

class ProductList extends StatefulWidget {
  ProductList({this.products});

  final List<Product> products;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Widget _productCard({Product product}) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Styles.cardRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Styles.cardRadius),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: product.pictures.isNotEmpty
                        ? Image(
                      image: NetworkImage(product.pictures[0]),
                      fit: BoxFit.contain,
                    )
                        : null,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Styles.colors.title, fontSize: 11),
                  ),
                  Text(
                    NumberFormatTool.formatPrice(product.pricePerMonth) +
                        '€ / mois',
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    const double crossAxisSpacing = 16.0;

    return AnimationLimiter(
      child: GridView.builder(
          padding: const EdgeInsets.only(
              left: Styles.mainHorizontalPadding,
              right: Styles.mainHorizontalPadding,
              bottom: crossAxisSpacing),
          itemCount: widget.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: widget.products.length,
              child: ScaleAnimation(
                child: _productCard(product: widget.products[index]),
              ),
            );
          }),
    );
  }
}
