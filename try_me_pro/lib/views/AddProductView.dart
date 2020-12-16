import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/widgets/GoBackTopBar.dart';
import 'package:tryme/widgets/Loading.dart';

class AddProductView extends StatefulWidget {
  @override
  _AddProductViewState createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  Product _product = Product();
  List<String> _categories = List();
  String _selectedCategory = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _monthPriceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _pictureUrlController = TextEditingController();
  ButtonState _buttonState = ButtonState.idle;
  bool _loading = false;

  Future<bool> saveInfo() async {
    int categoryId = 0;

    _product.name = _titleController.text;
    _product.brand = _brandController.text;
    _product.pricePerMonth = _monthPriceController.text != null
        ? double.parse(_monthPriceController.text)
        : 0.0;
    _product.stock =
        _stockController.text != null ? int.parse(_stockController.text) : 0.0;
    _product.description = _descriptionController.text;
    _product.pictures.add(_pictureUrlController.text);
    categories.forEach((category) {
      if (category.name == _selectedCategory) categoryId = category.id;
    });
    return (await Request.addProduct(_product, categoryId));
  }

  @override
  void initState() {
    _product.stock = 10;
    _stockController.text = _product.stock.toString();
    categories.forEach((category) {
      _categories.add(category.name);
    });
    if (_categories.isNotEmpty) _selectedCategory = _categories.first;
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
            text: "Produit sauvegardé",
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
        if (_formKey.currentState.validate())
          saveInfo().then((hasException) {
            setState(() {
              _buttonState =
                  hasException ? ButtonState.fail : ButtonState.success;
              Navigator.pushNamedAndRemoveUntil(
                  context, 'app', ModalRoute.withName('/'));
            });
          });
        else
          setState(() {
            _buttonState = ButtonState.idle;
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
            GoBackTopBar(title: "Nouveau produit"),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          TextFormField(
                            style: TextStyle(color: Styles.colors.text),
                            decoration: InputDecoration(
                                labelText: 'Titre',
                                labelStyle:
                                    TextStyle(color: Styles.colors.text)),
                            controller: _titleController,
                            validator: (value) {
                              if (value.isEmpty) return ("Champ vide");
                              return (null);
                            },
                          ),
                          TextFormField(
                            style: TextStyle(color: Styles.colors.text),
                            decoration: InputDecoration(
                                labelText: 'Marque',
                                labelStyle:
                                    TextStyle(color: Styles.colors.text)),
                            controller: _brandController,
                            validator: (value) {
                              if (value.isEmpty) return ("Champ vide");
                              return (null);
                            },
                          ),
                          TextFormField(
                            style: TextStyle(color: Styles.colors.text),
                            decoration: InputDecoration(
                                labelText: 'Prix/Mois',
                                labelStyle:
                                    TextStyle(color: Styles.colors.text)),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                              LengthLimitingTextInputFormatter(5),
                            ],
                            controller: _monthPriceController,
                            validator: (value) {
                              if (value.isEmpty) return ("Champ vide");
                              return (null);
                            },
                          ),
                          TextFormField(
                            style: TextStyle(color: Styles.colors.text),
                            decoration: InputDecoration(
                                labelText: 'Stock',
                                labelStyle:
                                    TextStyle(color: Styles.colors.text)),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: false),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                              LengthLimitingTextInputFormatter(5),
                            ],
                            controller: _stockController,
                            validator: (value) {
                              if (value.isEmpty) return ("Champ vide");
                              return (null);
                            },
                          ),
                          TextFormField(
                            style: TextStyle(color: Styles.colors.text),
                            decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle:
                                    TextStyle(color: Styles.colors.text)),
                            maxLines: null,
                            controller: _descriptionController,
                            validator: (value) {
                              if (value.isEmpty) return ("Champ vide");
                              return (null);
                            },
                          ),
                          TextFormField(
                            style: TextStyle(color: Styles.colors.text),
                            decoration: InputDecoration(
                                labelText: "Url de l'image",
                                labelStyle:
                                    TextStyle(color: Styles.colors.text)),
                            controller: _pictureUrlController,
                            validator: (value) {
                              if (value.isEmpty) return ("Champ vide");
                              return (null);
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  'Catégorie',
                                  style: TextStyle(color: Styles.colors.text, fontSize: 12),
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: Styles.colors.background,
                                  value: _selectedCategory,
                                  items: _categories
                                      .map((item) => DropdownMenuItem(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                color: Styles.colors.text,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Loading(active: _loading),
                  ],
                ),
              ),
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
