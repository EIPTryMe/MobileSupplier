import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:loading_indicator/loading_indicator.dart';

class Loading extends StatefulWidget {
  Loading({this.size = 50.0, this.active = true});

  final double size;
  final bool active;

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return widget.active
        ? Container(
            height: widget.size,
            width: widget.size,
            child: LoadingIndicator(
              indicatorType: Indicator.circleStrokeSpin,
              color: Colors.white,
            ),
          )
        : Container();
  }
}
