import 'package:flutter/material.dart';

class LogOut {
  Future<bool> confirm(BuildContext context) async {
    return showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Déconnexion',
              style: TextStyle(color: Colors.red),
            ),
            content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Annuler'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      'Oui',
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
