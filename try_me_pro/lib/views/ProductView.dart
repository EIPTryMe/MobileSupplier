import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/tools/NumberFormatTool.dart';
import 'package:tryme/widgets/GoBackTopBar.dart';
import 'package:tryme/widgets/Loading.dart';

class ProductView extends StatefulWidget {
  ProductView({this.id});

  final String id;

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  Product _product = Product();
  String _pricePerMonth = "";
  bool _loading = true;
  int _duration = 1;
  ButtonState _buttonState = ButtonState.idle;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    int id;

    if (widget.id != null) id = int.tryParse(widget.id);
    if (id != null)
      Request.getProduct(id).then((product) {
        setState(() {
          _product = product;
          _pricePerMonth = NumberFormatTool.formatPrice(_product.pricePerMonth);
          _loading = false;
        });
      });
  }

  void _showDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            initialIntegerValue: _duration,
            minValue: 1,
            maxValue: 24,
            title: Text("Durée de la location (mois)"),
          );
        }).then((value) {
      if (value != null) setState(() => _duration = value);
    });
  }

  Widget _carouselFullScreen({List images, int current}) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: SafeArea(
        child: CarouselSlider(
          items: images
              .map((item) => GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.network(
                      item,
                      height: height,
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
              height: height, viewportFraction: 1.0, initialPage: current),
        ),
      ),
    );
  }

  Widget _card({Widget child, String title = ""}) {
    return Container(
      color: Styles.colors.lightBackground,
      padding: const EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
          right: Styles.mainHorizontalPadding,
          left: Styles.mainHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                title,
                style: TextStyle(
                  color: Styles.colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }

  Widget _carousel({double height = 400.0}) {
    return _card(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Styles.cardRadius),
        ),
        child: _product.pictures == null
            ? null
            : ClipRRect(
                borderRadius: BorderRadius.circular(Styles.cardRadius),
                child: CarouselSlider(
                  items: _product.pictures == null
                      ? null
                      : _product.pictures
                          .asMap()
                          .map(
                            (i, item) => MapEntry(
                              i,
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => _carouselFullScreen(
                                        images: _product.pictures, current: i),
                                  ),
                                ),
                                child: Image.network(
                                  item,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  //width: width,
                                ),
                              ),
                            ),
                          )
                          .values
                          .toList(),
                  options:
                      CarouselOptions(height: height, viewportFraction: 1.0),
                ),
              ),
      ),
    );
  }

  Widget _ratingStars({double stars = 0.0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(5, (index) {
        IconData icon;

        if (stars.floor() >= index + 1)
          icon = Icons.star;
        else if (stars.round() == index + 1)
          icon = Icons.star_half;
        else
          icon = Icons.star_border;
        return Icon(
          icon,
          color: Colors.white,
          size: 20,
        );
      }),
    );
  }

  Widget _header() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _product.name,
                  style: TextStyle(
                    color: Styles.colors.text,
                    fontSize: 16,
                  ),
                ),
              ),
              _product.reviews.reviews.isEmpty
                  ? Text('Pas encore noté',
                      style: TextStyle(color: Styles.colors.title))
                  : _ratingStars(stars: _product.reviews.averageRating),
            ],
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Text(
                '€ $_pricePerMonth',
                style: TextStyle(
                    color: Styles.colors.text, fontWeight: FontWeight.w700),
              ),
              Text(
                ' / mois',
                style: TextStyle(color: Styles.colors.unSelected),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _description() {
    return _card(
      title: 'Description',
      child: Text(
        _product.description,
        style: TextStyle(color: Styles.colors.text),
      ),
    );
  }

  Widget _specification() {
    return _card(
      title: 'Spécification',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _product.specifications
            .map((spec) => Text(
                  spec,
                  style: TextStyle(color: Styles.colors.text),
                ))
            .toList(),
      ),
    );
  }

  Widget _reviews() {
    List<Review> reviews = _product.reviews.reviews;

    return _card(
      title: 'Commentaires',
      child: reviews.isNotEmpty
          ? Column(
              children: List.generate(
                  reviews.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                reviews[index].user.isNotEmpty
                                    ? '${reviews[index].user[0]}***${reviews[index].user[reviews[index].user.length - 1]}'
                                    : '',
                                style: TextStyle(color: Styles.colors.text),
                              ),
                              _ratingStars(stars: reviews[index].score),
                            ],
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            reviews[index].date.substring(0, reviews[index].date.indexOf('T')),
                            style: TextStyle(color: Styles.colors.unSelected),
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            reviews[index].description,
                            style: TextStyle(color: Styles.colors.text),
                          ),
                          if (index + 1 < reviews.length)
                            Divider(thickness: 2.0),
                        ],
                      )),
            )
          : Text(
              'Pas encore noté',
              style: TextStyle(color: Styles.colors.text),
              textAlign: TextAlign.center,
            ),
    );
  }

  Widget _productInfo() {
    return ListView(
      children: [
        _carousel(),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: _header(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: _description(),
        ),
        if (_product.specifications.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: _specification(),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: _reviews(),
        ),
      ],
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
              child: GoBackTopBar(title: _product.name, titleFontSize: 24.0),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _productInfo(),
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
