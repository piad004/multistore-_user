import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/paymentstatus.dart';
import 'package:user/bean/rewardvalue.dart';
import 'package:user/walletrewardreffer/wallet/ui/history/wallethistory.dart';
import 'package:user/walletrewardreffer/wallet/ui/rechargeui/rechargewallet.dart';
import 'package:user/walletrewardreffer/wallet/ui/walletbean/walletbbean.dart';

class Wallet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WalletState();
  }
}

class WalletState extends State<Wallet> {
  bool three_expandtrue = false;
  int style_selectedValue = 0;
  bool visible = false;
  int rs_selected = -1;
  String email = '';
  dynamic walletAmount = 0.0;
  dynamic currency = '';
  List<WalletHistory> history = [];
  bool isFetchStore = false;
  bool isFetchingList = false;
  List<NormalPlanWallet> rechargeList = [];
  List<OfferPlanWallet> offerPlan = [];

  int idd1 = -1;

  @override
  void initState() {
    super.initState();
    getWalletAmount();
  }

  void getWalletAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userId = prefs.getInt('user_id');
    setState(() {
      isFetchStore = true;
      currency = prefs.getString('curency');
    });
    var client = http.Client();
    var url = showWalletAmount;
    client.post(url, body: {
      'user_id': '${userId}',
    }).then((value) {
      if (value.statusCode == 200 && jsonDecode(value.body)['status'] == "1") {
        var jsonData = jsonDecode(value.body);
        var dataList = jsonData['data'] as List;
        setState(() {
          walletAmount = dataList[0]['wallet_credits'];
        });
      }
      getWalletPlan();
    }).catchError((e) {
      getWalletPlan();
      print(e);
    });
  }

  void getWalletPlan() async{
    var url = wallet_plans;
    var client = http.Client();
    client.get(url).then((value){
      print('${value.body}');
      WalletRechargeDetail detail = WalletRechargeDetail.fromJson(jsonDecode(value.body));
      print('${detail.toString()}');
      if(detail!=null && detail.status == '1'){
        rechargeList = List.from(detail.nornal_plan);
        rechargeList.add(NormalPlanWallet('3', 'Other'));
        offerPlan = List.from(detail.offer_plan);
      }
      setState(() {
        isFetchStore = false;
      });
    }).catchError((e){
      setState(() {
        isFetchStore = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 7;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: kWhiteColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                locale.myWallet,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: kMainTextColor),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right:10.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return WalletHistoryPage();
                  }));
                },
                  behavior: HitTestBehavior.opaque,
                  child: Icon(Icons.history,size: 25,)),
            )
          ],
        ),
      ),
      body: (!isFetchStore)
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    color: kWhiteColor,
                    elevation: 10,
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 20,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(locale.walletBalane,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: kDisabledColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                        letterSpacing: 0.67)),
                            Text('$currency ${walletAmount}/-'),
                            Text(
                                'Minimum wallet balance $currency ${walletAmount}/-',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: kDisabledColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        letterSpacing: 0.67)),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                        itemCount: offerPlan.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index){
                      return InkWell(
                        onTap: () {
                          getVendorPayment('${offerPlan[index].offer_amount}','offer');
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: Material(
                            elevation: 2,
                            borderRadius:
                            BorderRadius.circular(20.0),
                            clipBehavior: Clip.hardEdge,
                            child: Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.75,
//                                            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                              decoration: BoxDecoration(
                                color: white_color,
                                borderRadius:
                                BorderRadius.circular(20.0),
                              ),
                              child: Image.network(
                                imageBaseUrl + offerPlan[index].offer_image,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(20),
                    child: Text(
                      'Recharge Plans',
                      style: TextStyle(
                          color: kMainColor,
                          fontSize: 18),
                    ),
                  ),
                  Visibility(
                    visible: (rechargeList!=null && rechargeList.length > 0)?true:false,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(right: 5, left: 5),
                        child: GridView.builder(
                          itemCount: rechargeList.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                            childAspectRatio:
                            (itemWidth / itemHeight),
                          ),
                          controller: ScrollController(
                              keepScrollOffset: false),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  idd1 = index;
                                  print('${rechargeList[idd1].plans}');
                                });
                                getVendorPayment('${rechargeList[idd1].plans}','non_offer');
                              },
                              child: SizedBox(
                                height: 100,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: 5,
                                      left: 5,
                                      top: 5,
                                      bottom: 5),
                                  height: 30,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: (idd1 == index)
                                          ? kMainColor
                                          : kWhiteColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                      BorderRadius.circular(20),
                                      border: Border.all(
                                          color: (idd1 == index)
                                              ? kMainColor
                                              : kMainColor)),
                                  child: Text(
                                    '${rechargeList[index].plans}',
                                    style: TextStyle(
                                        color: (idd1 == index)
                                            ? kWhiteColor
                                            : kMainTextColor,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ),
                ],
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    locale.fetchingWalletAmount,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kMainTextColor),
                  )
                ],
              ),
            ),
    );
  }

  void getVendorPayment(String rechargeValue,type) async {
    var url = paymentvia;
    var client = http.Client();
    client.get(url).then((value) {
      print('${value.statusCode} - ${value.body}');
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(value.body);
          PaymentVia tagObjs = PaymentVia.fromJson(tagObjsJson);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return RechargeWallet(
                (rechargeValue=='Other')?0.0:double.parse('${rechargeValue}'),
                tagObjs,
                type);
          })).then((value){
            getWalletAmount();
          });
        }
      }
    }).catchError((e) {
      print(e);
    });
  }

}
