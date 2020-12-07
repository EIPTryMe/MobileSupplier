import 'package:flutter/material.dart';

class OrderFinishedView extends StatefulWidget {
  @override
  _OrderFinishedViewState createState() => _OrderFinishedViewState();
}

class _OrderFinishedViewState extends State<OrderFinishedView> {
  void setError(dynamic error) {
    print(error.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation de la commande'),
        centerTitle: true,
        backgroundColor: Color(0xff1F2C47),
      ),
      body: Center(child: Text('Votre commande à bien été prise en compte.')),
    );
  }
}
