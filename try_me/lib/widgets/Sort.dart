import 'package:flutter/material.dart';
import 'package:tryme/Styles.dart';

class Sort extends StatefulWidget {
  Sort({this.onSelected});

  final Function(String) onSelected;

  @override
  _SortState createState() => _SortState();
}

class _SortState extends State<Sort> {
  List<String> _items = [
    'Pertinence',
    'Note moyenne',
    'Nouveauté',
    'Prix (Croissant)',
    'Prix (Décroissant)'
  ];
  String _selectedItem = '';

  @override
  void initState() {
    _selectedItem = _items.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
              color: Styles.colors.lightBackground,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor: Styles.colors.background,
                value: _selectedItem,
                items: _items
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
                    _selectedItem = value;
                    widget.onSelected(value);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
