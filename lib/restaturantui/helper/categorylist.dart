import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/resturantbean/categoryresturantlist.dart';

class CategoryList extends StatefulWidget {
  final VoidCallback onVerificationDone;
  List<CategoryResturant> categoryList;

  CategoryList(this.categoryList, this.onVerificationDone);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<CategoryResturant> categoryList = [];
  bool isFetch = false;

  @override
  void initState() {
    categoryList = widget.categoryList;
    super.initState();
  }

  void hitBannerUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isFetch = true;
    });
    var url = homecategoryss;
    http.post(url, body: {
      'vendor_id': '${preferences.getString('vendor_cat_id')}'
    }).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print('Response Body: - ${response.body}');
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<CategoryResturant> tagObjs = tagObjsJson
              .map((tagJson) => CategoryResturant.fromJson(tagJson))
              .toList();
          if (tagObjs != null && tagObjs.length > 0) {
            setState(() {
              isFetch = false;
              categoryList.clear();
              categoryList = tagObjs;
            });
          } else {
            setState(() {
              isFetch = false;
            });
          }
        } else {
          setState(() {
            isFetch = false;
          });
        }
      } else {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        isFetch = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Visibility(
      visible: (!isFetch && categoryList.length == 0) ? false : true,
      child: Container(
        width: width,
        height: 110.0,
        child: (categoryList != null && categoryList.length > 0)
            ? ListView.builder(
                itemCount: categoryList.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = categoryList[index];
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      width: 70.0,
                      margin: (index != (categoryList.length - 1))
                          ? EdgeInsets.only(left: fixPadding)
                          : EdgeInsets.only(
                              left: fixPadding, right: fixPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 60.0,
                            width: 60.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Image.network(
                                imageBaseUrl + item.product_image,
                                height: 40.0,
                                width: 40.0),
                          ),
                          heightSpace,
                          Text(
                            item.cat_name,
                            textAlign: TextAlign.center,
                            style: listItemTitleStyle,
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            : ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      width: 70.0,
                      margin:
                          EdgeInsets.only(left: fixPadding, right: fixPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              height: 60.0,
                              width: 60.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Shimmer(
                                  duration: Duration(seconds: 3),
                                  color: Colors.white,
                                  enabled: true,
                                  direction: ShimmerDirection.fromLTRB(),
                                  child: Container(
                                    color: kTransparentColor,
                                  ),
                                ),
                              )),
                          heightSpace,
                          SizedBox(
                            width: 100,
                            height: 15,
                            child: Shimmer(
                              duration: Duration(seconds: 3),
                              color: Colors.white,
                              enabled: true,
                              direction: ShimmerDirection.fromLTRB(),
                              child: Container(
                                color: kTransparentColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
