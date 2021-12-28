import 'package:flutter/material.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/Themes/style.dart';
import 'package:user/restaturantui/widigit/column_builder.dart';

class ReviewSection extends StatefulWidget {
  @override
  _ReviewSectionState createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  final reviewList = [
    {
      'image': 'assets/user_profile/user_1.jpg',
      'name': 'Robert Junior',
      'rating': '5',
      'review': 'Very good.',
      'time': 'Yesterday 10:33 PM'
    },
    {
      'image': 'assets/user_profile/user_2.jpg',
      'name': 'Mark Lynn',
      'rating': '4',
      'review': 'Awesome Quality.',
      'time': 'Yesterday 9:12 PM'
    },
    {
      'image': 'assets/user_profile/user_3.jpg',
      'name': 'Ellison Perry',
      'rating': '3',
      'review': 'Super.',
      'time': 'Yesterday 7:35 PM'
    },
    {
      'image': 'assets/user_profile/user_4.jpg',
      'name': 'Emma Watson',
      'rating': '5',
      'review': 'Good.',
      'time': 'Yesterday 6:58 PM'
    },
    {
      'image': 'assets/user_profile/user_5.jpg',
      'name': 'Shira Maxwell',
      'rating': '2',
      'review': 'Mind Blowing.',
      'time': 'Yesterday 4:35 PM'
    },
    {
      'image': 'assets/user_profile/user_6.jpg',
      'name': 'David Smith',
      'rating': '4',
      'review': 'Fabulous.',
      'time': 'Yesterday 2:51 PM'
    },
    {
      'image': 'assets/user_profile/user_7.jpg',
      'name': 'Bill Hussey',
      'rating': '1',
      'review': 'It\'s Good.',
      'time': 'Yesterday 10:33 AM'
    },
    {
      'image': 'assets/user_profile/user_8.jpg',
      'name': 'Peter James',
      'rating': '5',
      'review': 'Very nice.',
      'time': 'Yesterday 9:33 AM'
    }
  ];

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    return ColumnBuilder(
      itemCount: reviewList.length,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      itemBuilder: (context, index) {
        final item = reviewList[index];
        return Container(
          width: width,
          height: 100.0,
          margin: EdgeInsets.all(fixPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 75.0,
                    height: 75.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: AssetImage(item['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  widthSpace,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item[locale.name],
                        style: headingStyle,
                      ),
                      heightSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.orange, size: 18.0),
                          Icon(Icons.star,
                              color: (item['rating'] == '1')
                                  ? Colors.grey[300]
                                  : Colors.orange,
                              size: 18.0),
                          Icon(Icons.star,
                              color: (item['rating'] == '1' ||
                                      item['rating'] == '2')
                                  ? Colors.grey[300]
                                  : Colors.orange,
                              size: 18.0),
                          Icon(Icons.star,
                              color: (item['rating'] == '1' ||
                                      item['rating'] == '2' ||
                                      item['rating'] == '3')
                                  ? Colors.grey[300]
                                  : Colors.orange,
                              size: 18.0),
                          Icon(Icons.star,
                              color: (item['rating'] == '1' ||
                                      item['rating'] == '2' ||
                                      item['rating'] == '3' ||
                                      item['rating'] == '4')
                                  ? Colors.grey[300]
                                  : Colors.orange,
                              size: 18.0),
                        ],
                      ),
                      heightSpace,
                      Text(
                        item[locale.review],
                        style: listItemTitleStyle,
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                item[locale.time],
                style: listItemSubTitleStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}
