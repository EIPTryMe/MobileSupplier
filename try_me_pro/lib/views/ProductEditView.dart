import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Queries.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/widgets/GoBackTopBar.dart';
import 'package:tryme/widgets/Loading.dart';

class ProductEditView extends StatefulWidget {
  ProductEditView({this.id});

  final String id;

  @override
  _ProductEditViewState createState() => _ProductEditViewState();
}

class _ProductEditViewState extends State<ProductEditView> {
  bool _gotData = false;
  Product _product = Product();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _monthPriceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  ButtonState _buttonState = ButtonState.idle;
  bool _loading = true;

  Future<bool> saveInfo() async {
    _product.name = _titleController.text;
    _product.brand = _brandController.text;
    _product.pricePerMonth = _monthPriceController.text != null
        ? double.parse(_monthPriceController.text)
        : 0.0;
    _product.stock =
        _stockController.text != null ? int.parse(_stockController.text) : 0.0;
    _product.description = _descriptionController.text;
    return (await Request.modifyProduct(_product));
  }

  Future getData() async {
    QueryResult result;
    QueryOptions queryOption = QueryOptions(
      documentNode: gql(Queries.product(int.parse(widget.id))),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    result = await client.value.query(queryOption);
    if (this.mounted) {
      setState(() {
        _product = QueryParse.getProduct(result.data['product'][0]);
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    getData().whenComplete(() {
      _titleController.text = _product.name;
      _brandController.text = _product.brand;
      _monthPriceController.text = _product.pricePerMonth.toString();
      _stockController.text = _product.stock.toString();
      _descriptionController.text = _product.description;
      _gotData = true;
    });
    super.initState();
  }

  Widget _saveButton() {
    double width = MediaQuery.of(context).size.width;

    return ProgressButton.icon(
      maxWidth: width,
      radius: Styles.buttonRadius,
      iconedButtons: {
        ButtonState.idle: IconedButton(
            text: "Sauvegarder",
            icon: Icon(Icons.save, color: Colors.white),
            color: Styles.colors.main),
        ButtonState.loading: IconedButton(color: Styles.colors.main),
        ButtonState.fail: IconedButton(
            text: "Erreur",
            icon: Icon(Icons.cancel, color: Colors.white),
            color: Colors.red.withOpacity(0.7)),
        ButtonState.success: IconedButton(
            text: "Produit modifié",
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            color: Colors.green.shade400)
      },
      onPressed: () {
        setState(() {
          _buttonState = ButtonState.loading;
        });
        saveInfo().then((hasException) {
          setState(() {
            _buttonState =
                hasException ? ButtonState.fail : ButtonState.success;
            Navigator.pushNamedAndRemoveUntil(
                context, 'app', ModalRoute.withName('/'));
          });
        });
      },
      state: _buttonState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GoBackTopBar(title: "Édition produit"),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ListView(
                      children: [
                        TextField(
                          style: TextStyle(color: Styles.colors.text),
                          decoration: InputDecoration(
                              labelText: 'Titre',
                              labelStyle: TextStyle(color: Styles.colors.text)),
                          controller: _titleController,
                        ),
                        TextField(
                          style: TextStyle(color: Styles.colors.text),
                          decoration: InputDecoration(
                              labelText: 'Marque',
                              labelStyle: TextStyle(color: Styles.colors.text)),
                          controller: _brandController,
                        ),
                        TextField(
                          style: TextStyle(color: Styles.colors.text),
                          decoration: InputDecoration(
                              labelText: 'Prix/Mois',
                              labelStyle: TextStyle(color: Styles.colors.text)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                          ],
                          controller: _monthPriceController,
                        ),
                        TextField(
                          style: TextStyle(color: Styles.colors.text),
                          decoration: InputDecoration(
                              labelText: 'Stock',
                              labelStyle: TextStyle(color: Styles.colors.text)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                          ],
                          controller: _stockController,
                        ),
                        TextField(
                          style: TextStyle(color: Styles.colors.text),
                          decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(color: Styles.colors.text)),
                          maxLines: null,
                          controller: _descriptionController,
                        ),
                      ],
                    ),
                    Loading(active: _loading),
                  ],
                ),
              ),
            ),
            if (_gotData)
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 12.0,
                    right: Styles.mainHorizontalPadding,
                    left: Styles.mainHorizontalPadding),
              ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 12.0,
                  right: Styles.mainHorizontalPadding,
                  left: Styles.mainHorizontalPadding),
              child: _saveButton(),
            ),
          ],
        ),
      ),
    );
  }
}
