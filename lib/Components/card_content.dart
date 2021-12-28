import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/Themes/colors.dart';

class CardContent extends StatelessWidget {
  final String text;
  final String image;

  CardContent({this.text, this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: Image.network(
            image,
            height: 100,
            width: 100,
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
                color: black_color, fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
