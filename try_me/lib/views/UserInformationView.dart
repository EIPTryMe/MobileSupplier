import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geocoder/geocoder.dart';

import 'package:tryme/Globals.dart';
import 'package:tryme/Request.dart';
import 'package:tryme/Styles.dart';
import 'package:tryme/tools/AddressTool.dart';
import 'package:tryme/tools/NumberFormatTool.dart';
import 'package:tryme/tools/Validator.dart';
import 'package:tryme/widgets/Loading.dart';

class UserInformationView extends StatefulWidget {
  @override
  _UserInformationViewState createState() => _UserInformationViewState();
}

class _UserInformationViewState extends State<UserInformationView> {
  TextEditingController _firstNameController;
  TextEditingController _nameController;
  TextEditingController _phoneController;
  TextEditingController _emailController;
  FocusNode _firstNameFocusNode;
  FocusNode _nameFocusNode;
  FocusNode _phoneFocusNode;
  FocusNode _emailFocusNode;
  DateTime _currentBirthday;
  String _currentAddress;
  double _inputHeight = 70.0;
  Color _iconColor1 = Color(0xFF1E2439);
  Color _iconColor2 = Color(0xFF39FEBF);
  Color _iconColor3 = Styles.colors.main;
  int _ordersNumber;
  bool _loading = false;

  @override
  void initState() {
    getData();
    _firstNameController = TextEditingController(text: user.firstName);
    _nameController = TextEditingController(text: user.lastName);
    _phoneController = TextEditingController(text: user.phone);
    _emailController = TextEditingController(text: user.email);

    _firstNameFocusNode = FocusNode();
    _firstNameFocusNode.addListener(() {
      if (!_firstNameFocusNode.hasFocus)
        saveFirstName(_firstNameController.text.trim());
    });
    _nameFocusNode = FocusNode();
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) saveName(_nameController.text.trim());
    });
    _phoneFocusNode = FocusNode();
    _phoneFocusNode.addListener(() {
      if (!_phoneFocusNode.hasFocus) savePhone(_phoneController.text.trim());
    });
    _emailFocusNode = FocusNode();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) saveEmail(_emailController.text.trim());
    });

    KeyboardVisibility.onChange.listen((bool visible) {
      if (!visible) {
        unFocusAll();
      }
    });

    if (user.birthday != null)
      _currentBirthday = DateTime.tryParse(user.birthday);
    if (user.address.fullAddress != null)
      _currentAddress = user.address.fullAddress.addressLine;
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();

    _firstNameFocusNode.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void unFocusAll() {
    _firstNameFocusNode.unfocus();
    _nameFocusNode.unfocus();
    _phoneFocusNode.unfocus();
    _emailFocusNode.unfocus();
  }

  void getData() async {
    Request.getOrdersNumber().then((ordersNumber) {
      setState(() {
        _ordersNumber = ordersNumber;
      });
    });
  }

  void showSnackBarMessage(String str) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          str,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void saveFirstName(String str) {
    if (str == user.firstName) return;
    if (Validator.nameValidator(str) != null) return;
    setState(() => _loading = true);
    Request.modifyUserFirstName(str).then((hasException) {
      setState(() {
        user.firstName = hasException ? user.firstName : str;
        _loading = false;
      });
      showSnackBarMessage(hasException ? 'Erreur' : 'Prénom sauvegardé');
    });
  }

  void saveName(String str) {
    if (str == user.lastName) return;
    if (Validator.nameValidator(str) != null) return;
    setState(() => _loading = true);
    Request.modifyUserName(str).then((hasException) {
      setState(() {
        user.lastName = hasException ? user.lastName : str;
        _loading = false;
      });
      showSnackBarMessage(hasException ? 'Erreur' : 'Nom sauvegardé');
    });
  }

  void savePhone(String str) {
    if (str == user.phone) return;
    if (Validator.phoneValidator(str) != null) return;
    setState(() => _loading = true);
    Request.modifyUserPhone(str).then((hasException) {
      setState(() {
        user.phone = hasException ? user.phone : str;
        _loading = false;
      });
      showSnackBarMessage(hasException ? 'Erreur' : 'Téléphone sauvegardé');
    });
  }

  void saveEmail(String str) {
    if (Validator.emailValidator(str) != null) return;
    if (str == user.email) return;
    setState(() => _loading = true);
    Request.modifyUserEmail(str).then((hasException) {
      setState(() {
        user.email = hasException ? user.email : str;
        _loading = false;
      });
      showSnackBarMessage(hasException ? 'Erreur' : 'Email sauvegardé');
    });
  }

  void saveBirthday(String str) {
    if (str == user.birthday) return;
    setState(() => _loading = true);
    Request.modifyUserBirthday(str).then((hasException) {
      setState(() {
        user.birthday = hasException ? user.birthday : str;
        _loading = false;
      });
      showSnackBarMessage(
          hasException ? 'Erreur' : 'Date de naissance sauvegardée');
    });
  }

  void saveAddress(Address address) async {
    if (user.address.fullAddress != null &&
        address.addressLine == user.address.fullAddress.addressLine) return;
    setState(() => _loading = true);
    Request.modifyUserAddress(
            '${address.subThoroughfare} ${address.thoroughfare}',
            address.postalCode,
            address.locality,
            address.countryName)
        .then((hasException) {
      setState(() {
        user.address.fullAddress =
            hasException ? user.address.fullAddress : address;
        _loading = false;
      });
      showSnackBarMessage(hasException ? 'Erreur' : 'Adresse sauvegardée');
    });
  }

  void showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Annuler"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () => disconnect(context),
    );
    AlertDialog alert = AlertDialog(
      title: Text("Déconnexion"),
      content: Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void disconnect(BuildContext context) {
    isLoggedIn = false;
    shoppingCard.shoppingCard.clear();
    auth0User = Auth0User();
    user = User();
    Navigator.pushNamedAndRemoveUntil(context, 'app', ModalRoute.withName('/'));
  }

  Widget _divider({height: 1.0}) {
    return Divider(
      height: height,
      color: Styles.colors.divider,
    );
  }

  Widget _topInfoCard() {
    const double imageBoxSize = 90.0;
    String firstName = user.firstName != null ? user.firstName : '';
    String lastName = user.lastName != null ? user.lastName : '';
    String phone = user.phone != null ? user.phone : '';
    String email = user.email != null ? user.email : '';

    return Column(
      children: [
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
                      backgroundImage: NetworkImage(
                          user.picture != null ? user.picture : ""),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstName + ' ' + lastName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Styles.colors.text,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        phone,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Styles.colors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          email,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Styles.colors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 130,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 15.0, top: 15.0, bottom: 15.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: Styles.colors.background,
                    onPressed: () => showAlertDialog(context),
                    child: Text(
                      'Déconnexion',
                      style: TextStyle(color: Styles.colors.text),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _divider(),
      ],
    );
  }

  Widget _input({IconData icon, Color iconBackground, Widget widget}) {
    return SizedBox(
      height: _inputHeight,
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          if (widget != null)
            Expanded(
              child: widget,
            ),
        ],
      ),
    );
  }

  Widget _myOrders() {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Styles.mainHorizontalPadding),
      color: Styles.colors.lightBackground,
      child: _input(
        icon: Icons.favorite,
        iconBackground: _iconColor3,
        widget: FlatButton(
          padding: const EdgeInsets.all(0.0),
          height: _inputHeight,
          onPressed: () => Navigator.pushNamed(context, 'orders'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mes commandes',
                style: TextStyle(
                  color: Styles.colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  if (_ordersNumber != null)
                    Container(
                      height: 17,
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Styles.colors.main,
                        borderRadius: BorderRadius.all(Radius.circular(32.5)),
                      ),
                      child: Center(
                        child: Text(
                          _ordersNumber.toString(),
                          style: TextStyle(
                            color: Styles.colors.text,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Color(0xFFBEC7C5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactInfo() {
    bool lock = false;

    return Container(
      color: Styles.colors.lightBackground,
      padding:
          const EdgeInsets.symmetric(horizontal: Styles.mainHorizontalPadding),
      child: Column(
        children: [
          _input(
            icon: Icons.person,
            iconBackground: _iconColor1,
            widget: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              focusNode: _firstNameFocusNode,
              style: TextStyle(
                color: Styles.colors.text,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Styles.colors.textPlaceholder,
              decoration: InputDecoration(
                hintText: 'Prénom',
                hintStyle: TextStyle(color: Styles.colors.textPlaceholder),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: _inputHeight / 2 - 10),
              ),
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                LengthLimitingTextInputFormatter(20),
              ],
              controller: _firstNameController,
              validator: (value) => Validator.nameValidator(value),
            ),
          ),
          _divider(height: 1.0),
          _input(
            icon: Icons.people_alt,
            iconBackground: _iconColor2,
            widget: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              focusNode: _nameFocusNode,
              style: TextStyle(
                color: Styles.colors.text,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Styles.colors.textPlaceholder,
              decoration: InputDecoration(
                hintText: 'Nom',
                hintStyle: TextStyle(color: Styles.colors.textPlaceholder),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: _inputHeight / 2 - 10),
              ),
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                LengthLimitingTextInputFormatter(20),
              ],
              controller: _nameController,
              validator: (value) => Validator.nameValidator(value),
            ),
          ),
          _divider(height: 1.0),
          _input(
            icon: Icons.phone,
            iconBackground: _iconColor3,
            widget: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              focusNode: _phoneFocusNode,
              style: TextStyle(
                color: Styles.colors.text,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Styles.colors.textPlaceholder,
              decoration: InputDecoration(
                hintText: 'Téléphone',
                hintStyle: TextStyle(color: Styles.colors.textPlaceholder),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: _inputHeight / 2 - 10),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              controller: _phoneController,
              validator: (value) => Validator.phoneValidator(value),
            ),
          ),
          _divider(height: 1.0),
          _input(
            icon: Icons.email,
            iconBackground: _iconColor1,
            widget: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              focusNode: _emailFocusNode,
              style: TextStyle(
                color: Styles.colors.text,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Styles.colors.textPlaceholder,
              decoration: InputDecoration(
                hintText: 'Mail',
                hintStyle: TextStyle(color: Styles.colors.textPlaceholder),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: _inputHeight / 2 - 10),
              ),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                LengthLimitingTextInputFormatter(40),
              ],
              controller: _emailController,
              validator: (value) => Validator.emailValidator(value),
            ),
          ),
          _divider(height: 1.0),
          _input(
            icon: Icons.cake,
            iconBackground: _iconColor2,
            widget: GestureDetector(
              onTap: () {
                unFocusAll();
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(DateTime.now().year - 100),
                  maxTime: DateTime.now(),
                  onConfirm: (date) {
                    setState(() => _currentBirthday = date);
                    saveBirthday(
                        '${date.year}-${NumberFormatTool.formatDate(month: date.month)}-${NumberFormatTool.formatDate(day: date.day)}');
                  },
                  currentTime: DateTime.tryParse(user.birthday),
                );
              },
              child: Container(
                color: Colors.transparent,
                height: _inputHeight,
                alignment: Alignment.centerLeft,
                child: _currentBirthday != null
                    ? Text(
                        '${NumberFormatTool.formatDate(day: _currentBirthday.day)}/${NumberFormatTool.formatDate(month: _currentBirthday.month)}/${_currentBirthday.year}',
                        style: TextStyle(
                          color: Styles.colors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        'Date de naissance',
                        style: TextStyle(
                          color: Styles.colors.textPlaceholder,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ),
            ),
          ),
          _divider(height: 1.0),
          _input(
            icon: Icons.location_on,
            iconBackground: _iconColor3,
            widget: GestureDetector(
              onTap: () {
                unFocusAll();
                if (!lock) {
                  lock = true;
                  setState(() => _loading = true);
                  AddressTool.getAddress(
                          context,
                          user.address.fullAddress != null
                              ? user.address.fullAddress.addressLine
                              : "")
                      .then((address) {
                    lock = false;
                    setState(() {
                      _currentAddress = address.addressLine;
                      _loading = false;
                    });
                    saveAddress(address);
                  }).catchError((_) {
                    lock = false;
                    setState(() => _loading = false);
                  });
                }
              },
              child: Container(
                color: Colors.transparent,
                height: _inputHeight,
                alignment: Alignment.centerLeft,
                child: _currentAddress != null
                    ? Text(
                        _currentAddress,
                        style: TextStyle(
                          color: Styles.colors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        'Adresse',
                        style: TextStyle(
                          color: Styles.colors.textPlaceholder,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ListView(
          children: [
            _topInfoCard(),
            SizedBox(height: 15),
            _myOrders(),
            SizedBox(height: 15),
            _contactInfo(),
          ],
        ),
        Loading(active: _loading),
      ],
    );
  }
}
