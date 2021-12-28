import 'package:flutter/material.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/Themes/style.dart';

class RateSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
      padding: EdgeInsets.all(fixPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(locale.rate, style: headingStyle),
          // 5 Star Rating Start
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(locale.code, style: greyHeadingStyle,),
              heightSpace,
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
            ],
          ),
          // 5 Star Rating End
          // 4 Star Rating Start
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(locale.fiveSix, style: greyHeadingStyle,),
              heightSpace,
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.grey[300], size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
            ],
          ),
          // 4 Star Rating End
          // 3 Star Rating Start
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(locale.fourFive, style: greyHeadingStyle,),
              heightSpace,
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.grey[300], size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.grey[300], size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
            ],
          ),
          // 3 Star Rating End
          // 2 Star Rating Start
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(locale.oneTwo, style: greyHeadingStyle,),
              heightSpace,
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.grey[300], size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.grey[300], size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.grey[300], size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
            ],
          ),
          // 1 Star Rating End
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(locale.five, style: greyHeadingStyle,),
              heightSpace,
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.grey[300], size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.grey[300], size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.grey[300], size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.grey[300], size: 18.0,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fixPadding/2),
                child: Icon(Icons.star, color: Colors.orange, size: 18.0,),
              ),
            ],
          ),
          // 1 Star Rating End
        ],
      ),
    );
  }
}