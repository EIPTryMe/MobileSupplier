import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/tools/NumberFormatTool.dart';
import 'package:tryme/widgets/GoBackTopBar.dart';

import 'package:tryme/tools/AddressTool.dart';

class PaymentView extends StatefulWidget {
  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String _cardNumber = '';
  String _expiryDate = '';
  String _cardHolderName = '';
  String _cvvCode = '';

  bool _isCvvFocused = false;
  bool _checkAddress = false;

  PaymentMethod _paymentMethod;
  PaymentIntentResult _paymentIntent;
  String _clientSecret;
  int _orderId;

  String _street = "";
  String _postCode = "";
  String _city = "";
  String _country = "";

  ButtonState _buttonState = ButtonState.idle;

  @override
  void initState() {
    _street = user.address.street != null ? user.address.street : "";
    _postCode = user.address.postCode != null ? user.address.postCode : "";
    _city = user.address.city != null ? user.address.city : "";
    _country = user.address.country != null ? user.address.country : "";
    super.initState();
  }

  void addCreditCard() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51HvOCIHzD4uJULST7uBkll71K9x6hhY8IECnNisDxCp6i6jJi4ErzfpjJPOyxABNaamP04BAiDeB4WvQ9hqIfUOO00XAbiWlGd",
        merchantId: "Test",
        androidPayMode: 'test'));
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) {
      setState(() {
        _paymentMethod = paymentMethod;
        _cardNumber = "0000 0000 0000 ${paymentMethod.card.last4}";
        _expiryDate =
            "${paymentMethod.card.expMonth}/${paymentMethod.card.expYear}";
        _cardHolderName = "${user.firstName} ${user.lastName}";
        _cvvCode = "";
      });
    }).catchError(setError);
  }

  void setError(dynamic error) {
    print(error);
  }

  Future<bool> checkout() async {
    await Request.order(
            'eur',
            user.address.city,
            user.address.country,
            user.address.street,
            int.tryParse(user.address.postCode),
            _city,
            _country,
            _street,
            int.tryParse(_postCode))
        .then((result) {
      if (result.hasException ||
          result.data['orderPayment']['clientSecret'] == null ||
          result.data['orderPayment']['order_id'] == null) return (false);
      setState(() {
        _clientSecret = result.data['orderPayment']['clientSecret'];
        _orderId = result.data['orderPayment']['order_id'];
      });
    });
    await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: _clientSecret,
        paymentMethodId: _paymentMethod.id,
      ),
    ).then((paymentIntent) {
      setState(() {
        _paymentIntent = paymentIntent;
      });
    }).catchError(setError);
    await Request.payOrder(_orderId).then((hasException) {
      if (hasException) return (false);
    });
    return (true);
  }

  Widget _divider({height: 2.0}) {
    return Divider(
      height: height,
      color: Styles.colors.divider,
    );
  }

  Widget _orderNumber() {
    const double imageBoxSize = 90.0;
    return Column(children: [
      _divider(),
      Container(
        height: imageBoxSize,
        color: Styles.colors.lightBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: imageBoxSize,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Padding(
                  padding: const EdgeInsets.all(imageBoxSize * 0.3 / 2.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(shoppingCard
                            .shoppingCard.first.product.pictures.isEmpty
                        ? ""
                        : shoppingCard.shoppingCard.first.product.pictures[0]),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    "Récapitulatif de votre commande",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      _divider(),
    ]);
  }

  Widget _shippingAddress() {
    _checkAddress =
        (_street != "" && _postCode != "" && _city != "" && _country != "");
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Styles.mainHorizontalPadding),
      color: Styles.colors.lightBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9.0),
                child: Text(
                  "Adresse de livraison",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 22.0,
                    color: Styles.colors.text,
                  ),
                ),
              ),
              Text(
                _street,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0,
                  color: Styles.colors.text,
                ),
              ),
              Text(
                "$_postCode $_city",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0,
                  color: Styles.colors.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 11.0),
                child: Text(
                  _country,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.0,
                    color: Styles.colors.text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: GestureDetector(
                  onTap: () {
                    AddressTool.getAddress(
                            context,
                            user.address.fullAddress != null
                                ? user.address.fullAddress.addressLine
                                : "")
                        .then((address) {
                      setState(() {
                        _street =
                            '${address.subThoroughfare} ${address.thoroughfare}';
                        _postCode = address.postalCode;
                        _city = address.locality;
                        _country = address.countryName;
                      });
                    }).catchError((_) {});
                  },
                  child: Text(
                    "Change",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      color: Styles.colors.main,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Theme(
              data: Theme.of(context).copyWith(
                disabledColor:
                    _checkAddress ? Styles.colors.main : Styles.colors.text,
              ),
              child: Radio()),
        ],
      ),
    );
  }

  Widget _creditCard() {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Styles.mainHorizontalPadding),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Paiement",
                style: TextStyle(
                  color: Styles.colors.text,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                height: 200,
                width: 350,
                child: GestureDetector(
                  onTap: () => addCreditCard(),
                  child: CreditCardWidget(
                    cardNumber: _cardNumber,
                    expiryDate: _expiryDate,
                    cardHolderName: _cardHolderName,
                    cvvCode: _cvvCode,
                    showBackView: _isCvvFocused,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceInformation() {
    String price = NumberFormatTool.formatPrice(shoppingCard.total);
    String total = NumberFormatTool.formatPrice(shoppingCard.total);

    return Container(
      color: Styles.colors.lightBackground,
      padding: const EdgeInsets.symmetric(
          horizontal: Styles.mainHorizontalPadding, vertical: 15.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Commande",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Livraison",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Total",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "$price €",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Offert",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "$total €",
                    style: TextStyle(
                      color: Styles.colors.text,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkOutButton() {
    double width = MediaQuery.of(context).size.width;
    return ProgressButton.icon(
      maxWidth: width,
      radius: Styles.buttonRadius,
      iconedButtons: {
        ButtonState.idle: IconedButton(
            text: "Payer",
            icon: Icon(Icons.credit_card, color: Colors.white),
            color: Styles.colors.main),
        ButtonState.loading: IconedButton(color: Styles.colors.main),
        ButtonState.fail: IconedButton(
            text: "Erreur",
            icon: Icon(Icons.cancel, color: Colors.white),
            color: Colors.red.withOpacity(0.7)),
        ButtonState.success: IconedButton(
            text: "Paiement réussi",
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            color: Colors.green.shade400)
      },
      onPressed: _checkAddress && _paymentMethod != null
          ? () {
              setState(() {
                _buttonState = ButtonState.loading;
              });
              checkout().then((succeed) {
                _buttonState = succeed ? ButtonState.success : ButtonState.fail;
                Navigator.pushNamedAndRemoveUntil(
                    context, 'app', ModalRoute.withName('/'));
                Navigator.pushNamed(context, 'orderFinished');
              });
            }
          : null,
      state: _buttonState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Styles.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Styles.mainHorizontalPadding, vertical: 10.0),
              child: GoBackTopBar(
                  title: "Votre commande",
                  titleFontSize: 20,
                  titleHeightSize: 20),
            ),
            Expanded(
              child: ListView(
                children: [
                  _orderNumber(),
                  SizedBox(height: 15),
                  _shippingAddress(),
                  SizedBox(height: 10),
                  _creditCard(),
                  SizedBox(height: 15),
                  _priceInformation(),
                  SizedBox(height: 15),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Styles.mainHorizontalPadding, vertical: 10.0),
              child: _checkOutButton(),
            ),
          ],
        ),
      ),
    );
  }
}
