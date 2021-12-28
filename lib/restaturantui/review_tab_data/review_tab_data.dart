import 'package:flutter/material.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/bean/nearstorebean.dart';
import 'package:user/restaturantui/review_tab_data/rate.dart';
import 'package:user/restaturantui/review_tab_data/review.dart';

class ReviewTabData extends StatefulWidget {
  final NearStores item;
  ReviewTabData(this.item);

  @override
  _ReviewTabDataState createState() => _ReviewTabDataState();
}

class _ReviewTabDataState extends State<ReviewTabData> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        heightSpace,
        // Rate Section Start
        RateSection(),
        // Rate Section End
//        Container(
//          height: 1.5,
//          width: width - 20.0,
//          margin: EdgeInsets.only(right: fixPadding, left: fixPadding),
//          color: Colors.grey[300],
//        ),
        heightSpace,
        ReviewSection()
      ],
    );
  }
}
