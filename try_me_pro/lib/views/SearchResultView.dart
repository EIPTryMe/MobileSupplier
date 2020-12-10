import 'package:flutter/material.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/widgets/Filter.dart';
import 'package:tryme/widgets/GoBackTopBar.dart';
import 'package:tryme/widgets/Loading.dart';
import 'package:tryme/widgets/ProductList.dart';
import 'package:tryme/widgets/SearchBar.dart';
import 'package:tryme/widgets/Sort.dart';

class SearchResultView extends StatefulWidget {
  SearchResultView({this.category, this.keywords});

  final String category;
  final String keywords;

  @override
  _SearchResultViewState createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView> {
  ProductListData _productListData = ProductListData();
  bool _loading = true;
  double _topBarHeight = 50.0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FilterOptions _filterOptions = FilterOptions();
  String _keywords = '';
  String _sort = '';

  @override
  void initState() {
    super.initState();
    _keywords = widget.keywords;
    getData(widget.keywords);
  }

  void getData(String keywords) async {
    setState(() {
      _productListData = ProductListData();
      _loading = true;
    });
    if (widget.category.isNotEmpty)
      _filterOptions.selectedCategory = widget.category;
    Request.getProductsSearch(keywords, _filterOptions, _sort)
        .then((productListData) {
      setState(() {
        _productListData = productListData;
        _filterOptions.categories = _productListData.categories;
        _filterOptions.brands = List();
        _productListData.products.forEach((product) {
          if (product.brand.isNotEmpty &&
              !_filterOptions.brands.contains(product.brand))
            _filterOptions.brands.add(product.brand);
        });
        _filterOptions.priceRange = _productListData.priceRange;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey key = GlobalKey();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Styles.colors.background,
      endDrawer: SafeArea(
        child: Drawer(
          child: Filter(
            lockCategory: widget.category,
            filterOptions: _filterOptions,
            onSubmit: (filterOptions) {
              setState(() {
                _filterOptions = filterOptions;
                getData(_keywords);
              });
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: Styles.mainHorizontalPadding,
                  right: Styles.mainHorizontalPadding,
                  bottom: 8.0),
              child: Column(
                children: [
                  if (widget.category.isNotEmpty)
                    GoBackTopBar(title: widget.category),
                  Row(
                    children: [
                      if (widget.category.isEmpty)
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(0.0),
                          onPressed: () => Navigator.pop(context),
                        ),
                      Expanded(
                        child: SearchBar(
                          showFilter: true,
                          scaffoldKey: _scaffoldKey,
                          height: _topBarHeight,
                          text: widget.keywords,
                          onSubmitted: (keywords) {
                            _filterOptions = FilterOptions();
                            getData(keywords);
                            setState(() {
                              _keywords = keywords;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: Styles.mainHorizontalPadding,
                  right: Styles.mainHorizontalPadding,
                  bottom: 8.0),
              child: Sort(
                onSelected: (sort) {
                  _sort = sort;
                  getData(_keywords);
                },
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  KeyedSubtree(
                      key: key,
                      child: ProductList(products: _productListData.products)),
                  if (_productListData.products.isEmpty && !_loading)
                    Text(
                      'Aucun résultat',
                      style: TextStyle(color: Styles.colors.text),
                    ),
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
