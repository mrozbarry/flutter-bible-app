import 'package:flutter/material.dart';

Widget heading(String text) {
  return Padding(
    padding: EdgeInsets.only(
      top: 16.0,
      bottom: 4.0,
      left: 10.0,
    ),
    child: Column(
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            color: Colors.black38,
          ),
        ),
        Divider(),
      ],
    ),
  );
}
