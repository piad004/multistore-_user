import 'package:flutter/material.dart';
import 'package:user/Components/bottom_bar.dart';
import 'package:user/HomeOrderAccount/home_order_account.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/databasehelper/dbhelper.dart';

class OrderPlaced extends StatelessWidget {
  final dynamic payment_method;
  final dynamic payment_status;
  final dynamic order_id;
  final dynamic rem_price;
  final dynamic currency;
  final dynamic uiType;

  OrderPlaced(this.payment_method, this.payment_status, this.order_id,
      this.rem_price, this.currency, this.uiType) {
    deleteProducts(uiType);
  }

  void deleteProducts(uiType) async {
    DatabaseHelper db = DatabaseHelper.instance;
    if (uiType == "1") {
      db.deleteAll();
    } else if (uiType == "2") {
      db.deleteAllRestProdcut();
      db.deleteAllAddOns();
    } else if (uiType == "3") {
      clearCart(db);
    }
  }

  void clearCart(db) async {
    db.deleteAllPharma().then((value) {
      db.deleteAllAddonPharma();
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context).pushNamedAndRemoveUntil(PageRoutes.homeOrderAccountPage, (Route<dynamic> route) => false);
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(60.0),
                  child: Image.asset(
                    'images/order_placed.png',
                    height: 265.7,
                    width: 260.7,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${locale.orderPlacedText11} - $order_id ${locale.orderPlacedText12} \n ${locale.orderPlacedText13} $currency ${double.parse('$rem_price').toStringAsFixed(2)}!!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 23.3, color: kMainTextColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                locale.orderPlacedText2,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: kDisabledColor),
              ),
            ),
            BottomBar(
              text: locale.goToHomeText,
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(PageRoutes.homeOrderAccountPage, (Route<dynamic> route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
