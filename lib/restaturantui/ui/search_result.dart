import 'package:flutter/material.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/Themes/style.dart';
import 'package:user/restaturantui/ui/get_search_result.dart';

class SearchResult extends StatefulWidget {
  final searchQuery;

  SearchResult({Key key, @required this.searchQuery}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  var searchController = TextEditingController();

  String searchInput = '';

  @override
  void initState() {
    super.initState();
    searchController.text =
        (widget.searchQuery == '') ? 'Juice' : widget.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // here the desired height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              elevation: 0.0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
//                  Container(
//                    width: width - 95.0,
//                    decoration: BoxDecoration(
//                      color: darkPrimaryColor,
//                      borderRadius: BorderRadius.circular(10.0),
//                    ),
//                    child: TextField(
//                      style: searchTextStyle,
//                      controller: searchController,
//                      decoration: InputDecoration(
//                        contentPadding: EdgeInsets.all(15.0),
//                        hintText: 'Search',
//                        hintStyle: searchTextStyle,
//                        border: InputBorder.none,
//                        prefixIcon: Icon(
//                          Icons.search,
//                          color: kWhiteColor,
//                        ),
//                      ),
//                    ),
//                  ),
                  Container(
                    width: width - 95.0,
                    margin: EdgeInsets.only(left: 10.0),
                    padding: EdgeInsets.only(left: 15.0),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: kCardBackgroundColor),
                      ],
                      borderRadius: BorderRadius.circular(30.0),
                      color: kCardBackgroundColor,
                    ),
                    child: TextField(
                      textCapitalization:
                      TextCapitalization.sentences,
                      cursorColor: kMainColor,
                      textAlign: TextAlign.start,
                      controller: searchController,
                      style: searchTextStyle_new,
                      decoration: InputDecoration(
                        icon: ImageIcon(
                          AssetImage('images/icons/ic_search.png'),
                          color: Colors.black,
                          size: 16,
                        ),
                        hintText: "Search",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: kHintColor),
                        border: InputBorder.none,
                      ),
                      onChanged: (v) {
                        setState(() {
                          searchInput = searchController.text;
                        });
                      },
                      onSubmitted: (v) {
//                        Navigator.push(
//                            context,
//                            PageTransition(
//                                type: PageTransitionType.rightToLeft,
//                                child: SearchResult(
//                                    searchQuery:
//                                    searchController.text)));
                      },
                    ),
                  ),
                  widthSpace,
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(fixPadding),
                      child: Text(
                        'Exit',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.0,
                          color: kWhiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: height - 20.0,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
          color: kTransparentColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            heightSpace,
            Padding(
              padding: EdgeInsets.all(fixPadding),
              child: Text(locale.approximately123Result, style: moreStyle),
            ),
            Container(height: height - 164.0, child: GetSearchResults()),
          ],
        ),
      ),
    );
  }
}
