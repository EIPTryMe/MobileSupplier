import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tryme/Styles.dart';

class FilterOptions {
  List<String> brands = List();
  List<String> selectedBrands = List();
  List<String> categories = List();
  String selectedCategory = '';
  RangeValues priceRange = RangeValues(0.0, 0.0);
  RangeValues priceCurrent = RangeValues(0.0, 0.0);
}

class Filter extends StatefulWidget {
  Filter({this.lockCategory = '', this.filterOptions, this.onSubmit});

  final String lockCategory;
  final FilterOptions filterOptions;
  final Function onSubmit;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  FilterOptions _filterOptions = FilterOptions();
  int _categorySelectedIndex;
  TextEditingController _priceMinController = TextEditingController();
  TextEditingController _priceMaxController = TextEditingController();

  @override
  void initState() {
    _filterOptions = widget.filterOptions;
    if (widget.lockCategory.isNotEmpty) {
      _filterOptions.categories = ['${widget.lockCategory}'];
      _filterOptions.selectedCategory = widget.lockCategory;
    }
    _categorySelectedIndex =
        _filterOptions.categories.indexOf(_filterOptions.selectedCategory);
    if (_filterOptions.priceCurrent != RangeValues(0.0, 0.0)) {
      if (_filterOptions.priceCurrent.start != null)
        _priceMinController.text =
            _filterOptions.priceCurrent.start.round().toString();
      if (_filterOptions.priceCurrent.end != null)
        _priceMaxController.text =
            _filterOptions.priceCurrent.end.round().toString();
    }
    super.initState();
  }

  void validatePrice() {
    double min = double.tryParse(_priceMinController.text);
    double max = double.tryParse(_priceMaxController.text);

    if (min != null && max != null && min > max) {
      double tmp = min;
      min = max;
      max = tmp;
      _priceMinController.text = min.toInt().toString();
      _priceMaxController.text = max.toInt().toString();
    }
    _filterOptions.priceCurrent = RangeValues(min, max);
  }

  Widget _categories() {
    return Container(
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Catégories',
            style: TextStyle(color: Styles.colors.text),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filterOptions.categories.length,
                itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ChoiceChip(
                        label: Text(
                          _filterOptions.categories[index],
                          style: TextStyle(color: Styles.colors.text),
                        ),
                        selectedColor: Styles.colors.main,
                        backgroundColor: Styles.colors.lightBackground,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        selected: _categorySelectedIndex == index,
                        onSelected: (selected) {
                          setState(() {
                            if (widget.lockCategory.isNotEmpty) return;
                            if (selected) {
                              _categorySelectedIndex = index;
                              _filterOptions.selectedCategory =
                                  _filterOptions.categories[index];
                            } else {
                              _categorySelectedIndex = null;
                              _filterOptions.selectedCategory = '';
                            }
                          });
                        },
                      ),
                    )),
          ),
        ],
      ),
    );
  }

  Widget _brand() {
    return Container(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Marques',
            style: TextStyle(color: Styles.colors.text),
          ),
          Expanded(
            child: GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 2,
              childAspectRatio: 0.35,
              children: _filterOptions.brands
                  .map((brand) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FilterChip(
                          label: Container(
                            width: 100,
                            child: Text(
                              brand,
                              style: TextStyle(color: Styles.colors.text),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          selectedColor: Styles.colors.main,
                          backgroundColor: Styles.colors.lightBackground,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          selected:
                              _filterOptions.selectedBrands.contains(brand),
                          onSelected: (selected) {
                            setState(() {
                              if (_filterOptions.selectedBrands.contains(brand))
                                _filterOptions.selectedBrands.remove(brand);
                              else
                                _filterOptions.selectedBrands.add(brand);
                            });
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _price() {
    return Container(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Prix',
            style: TextStyle(color: Styles.colors.text),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceMinController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(10.0),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Styles.colors.lightBackground)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Styles.colors.lightBackground)),
                      hintText:
                          'Min: ${_filterOptions.priceRange.start.round()}',
                      hintStyle: TextStyle(
                          color: Styles.colors.unSelected, fontSize: 13),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Styles.colors.text),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      LengthLimitingTextInputFormatter(5),
                    ],
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('-',
                      style: TextStyle(
                          color: Styles.colors.lightBackground, fontSize: 16)),
                ),
                Expanded(
                  child: TextField(
                    controller: _priceMaxController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(10.0),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Styles.colors.lightBackground)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Styles.colors.lightBackground)),
                      hintText: 'Max: ${_filterOptions.priceRange.end.round()}',
                      hintStyle: TextStyle(
                          color: Styles.colors.unSelected, fontSize: 13),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Styles.colors.text),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      LengthLimitingTextInputFormatter(5),
                    ],
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _submit() {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        color: Styles.colors.main,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        onPressed: () {
          validatePrice();
          widget.onSubmit(_filterOptions);
          Navigator.pop(context);
        },
        child: Text(
          'Appliquer',
          style: TextStyle(color: Styles.colors.text),
        ),
      ),
    );
  }

  Widget _reset() {
    return Center(
      child: TextButton(
        onPressed: () {
          widget.onSubmit(FilterOptions());
          Navigator.pop(context);
        },
        child: Text(
          'Réinitialiser',
          style: TextStyle(color: Styles.colors.text),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.colors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                if (_filterOptions.categories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: _categories(),
                  ),
                if (_filterOptions.brands.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: _brand(),
                  ),
                _price(),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _submit(),
              ),
              Expanded(
                child: _reset(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
