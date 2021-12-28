import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Components/list_tile.dart';
import 'package:user/HomeOrderAccount/Account/UI/ListItems/saved_addresses_page.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.myAccount, style: Theme.of(context).textTheme.bodyText1),
        centerTitle: true,
      ),
      body: Account(),
    );
  }
}

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String number;
  var userName = '';
  var phoneNumber = '';
  var emailId = '';

  @override
  void initState() {
    super.initState();
    getName();
  }

  Future<void> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('user_name');
    var phone = prefs.getString('user_phone');
    var email = prefs.getString('user_email');

    setState(() {
      if (name != null && name != '') {
        userName = name;
      } else {
        userName = '';
      }

      if (phone != null && phone != '') {
        phoneNumber = phone;
      } else {
        phoneNumber = '';
      }

      if (email != null && email != '') {
        emailId = email;
      } else {
        emailId = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return ListView(
      children: <Widget>[
        UserDetails(userName, phoneNumber, emailId),
        Divider(
          color: kCardBackgroundColor,
          thickness: 8.0,
        ),
        AddressTile(),
        BuildListTile(
            image: 'images/account/ic_menu_wallet.png',
            text: locale.walletText,
            onTap: () => Navigator.pushNamed(context, PageRoutes.wallet)),
        BuildListTile(
            image: 'images/account/reward.png',
            text: locale.rewardsText,
            onTap: () => Navigator.pushNamed(context, PageRoutes.reward)),
        BuildListTile(
            image: 'images/account/reffernearn.png',
            text: locale.referEarnText,
            onTap: () => Navigator.pushNamed(context, PageRoutes.reffernearn)),
        BuildListTile(
            image: 'images/account/ic_menu_tncact.png',
            text: locale.tnc,
            onTap: () => Navigator.pushNamed(context, PageRoutes.tncPage)),
        BuildListTile(
            image: 'images/account/ic_menu_supportact.png',
            text: locale.support,
            onTap: () => Navigator.pushNamed(context, PageRoutes.supportPage,
                arguments: number)),
        BuildListTile(
          image: 'images/account/ic_menu_aboutact.png',
          text: locale.aboutUs,
          onTap: () => Navigator.pushNamed(context, PageRoutes.aboutUsPage),
        ),
        BuildListTile(
          image: 'images/account/ic_menu_aboutact.png',
          text: locale.settingheding,
          onTap: () => Navigator.pushNamed(context, PageRoutes.settings),
        ),
        LogoutTile(),
      ],
    );
  }
}

class AddressTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return BuildListTile(
        image: 'images/account/ic_menu_addressact.png',
        text: locale.savedAddresses,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return SavedAddressesPage("");
          }));
        });
  }
}

class LogoutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return BuildListTile(
      image: 'images/account/ic_menu_logoutact.png',
      text: locale.logout,
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(locale.loggingOutText),
                content: Text(locale.areYouSureText),
                actions: <Widget>[
                  FlatButton(
                    child: Text(locale.noText),
                    textColor: kMainColor,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: kTransparentColor)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                      child: Text(locale.yesText),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: kTransparentColor)),
                      textColor: kMainColor,
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();
                        // Navigator.pushAndRemoveUntil(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return LoginNavigator();
                        // }), (Route<dynamic> route) => false);
                        Navigator.pushNamedAndRemoveUntil(context,PageRoutes.loginRoot, (Route<dynamic> route) => false);
                      })
                ],
              );
            });
      },
    );
  }
}

class UserDetailsState extends State<UserDetails> {
  var userName = '';
  var phoneNumber = '';
  var emailId = '';

  UserDetailsState(this.userName, this.phoneNumber, this.emailId);

  Future<void> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('user_name');
    var phone = prefs.getString('user_phone');
    var email = prefs.getString('user_email');
    setState(() {
      if (name != null && name != '') {
        userName = name;
      } else {
        userName = '';
      }
      if (phone != null && phone != '') {
        phoneNumber = phone;
      } else {
        phoneNumber = '';
      }
      if (email != null && email != '') {
        emailId = email;
      } else {
        emailId = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('\n' + userName, style: Theme.of(context).textTheme.bodyText1),
          Text('\n' + phoneNumber,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Color(0xff9a9a9a))),
          SizedBox(
            height: 5.0,
          ),
          Text(emailId,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Color(0xff9a9a9a))),
        ],
      ),
    );
  }
}

class UserDetails extends StatefulWidget {
  var userName = '';
  var phoneNumber = '';
  var emailId = '';

  UserDetails(this.userName, this.phoneNumber, this.emailId);

  @override
  State<StatefulWidget> createState() {
    return UserDetailsState(userName, phoneNumber, emailId);
  }
}
