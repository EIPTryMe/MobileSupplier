import 'package:flutter/material.dart';

import 'package:tryme/Styles.dart';

class GoBackTopBar extends StatelessWidget {
  GoBackTopBar({this.title = "", this.titleFontSize = 36, this.titleHeightSize = 70,});

  final String title;
  final double titleFontSize;
  final double titleHeightSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: titleHeightSize,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Styles.colors.text,
            ),
            padding: const EdgeInsets.all(0.0),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              this.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Styles.colors.text,
                fontSize: titleFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
