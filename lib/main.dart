import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Auth/MobileNumber/UI/phone_number.dart';
import 'package:user/HomeOrderAccount/home_order_account.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/style.dart';
import 'package:user/language_cubit.dart';
import 'package:user/providerlist/offerlistprovider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  try {
    Firebase.initializeApp();
  } catch (e) {}
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = prefs.getBool('islogin');
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: kMainTextColor.withOpacity(0.5),
  ));
  runApp(
      Phoenix(child: (result != null && result) ? GoMarketHome() : GoMarket()));
}

class GoMarket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider<NotificationListCubit>(
          create: (context) => NotificationListCubit(),
        ),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (_, locale) {
          return MaterialApp(
            builder: (context, child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(textScaleFactor: 1.0),
                child: child,
              );
            },
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en'),
              const Locale('hi'),
              const Locale('es'),
            ],
            locale: locale,
            theme: appTheme,
            home: PhoneNumber_New(),
            initialRoute: PageRoutes.loginRoot,
            routes: PageRoutes().routes(),
          );
        },
      ),
    );

    //   BlocProvider<LanguageCubit>(
    //   create: (context) => LanguageCubit(),
    //   child:
    // );
  }
}

class GoMarketHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LanguageCubit>(
            create: (context) => LanguageCubit(),
          ),
          BlocProvider<NotificationListCubit>(
            create: (context) => NotificationListCubit(),
          ),
        ],
        child: BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit(),
          child: BlocBuilder<LanguageCubit, Locale>(
            builder: (_, locale) {
              return MaterialApp(
                builder: (context, child) {
                  final MediaQueryData data = MediaQuery.of(context);
                  return MediaQuery(
                    data: data.copyWith(textScaleFactor: 1.0),
                    child: child,
                  );
                },
                debugShowCheckedModeBanner: false,
                localizationsDelegates: [
                  const AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('en'),
                  const Locale('hi'),
                  const Locale('es'),
                ],
                locale: locale,
                theme: appTheme,
                home: HomeOrderAccount(),
                initialRoute: PageRoutes.homeOrderAccountPage,
                routes: PageRoutes().routes(),
              );
            },
          ),
        ));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return new MyHttpClient(super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port)=> true);
  }
}


class MyHttpClient implements HttpClient {
  HttpClient _realClient;

  MyHttpClient(this._realClient);

  @override
  bool get autoUncompress => _realClient.autoUncompress;

  @override
  set autoUncompress(bool value) => _realClient.autoUncompress = value;

  @override
  Duration get connectionTimeout => _realClient.connectionTimeout;

  @override
  set connectionTimeout(Duration value) =>
      _realClient.connectionTimeout = value;

  @override
  Duration get idleTimeout => _realClient.idleTimeout;

  @override
  set idleTimeout(Duration value) => _realClient.idleTimeout = value;

  @override
  int get maxConnectionsPerHost => _realClient.maxConnectionsPerHost;

  @override
  set maxConnectionsPerHost(int value) =>
      _realClient.maxConnectionsPerHost = value;

  @override
  String get userAgent => _realClient.userAgent;

  @override
  set userAgent(String value) => _realClient.userAgent = value;

  @override
  void addCredentials(
      Uri url, String realm, HttpClientCredentials credentials) =>
      _realClient.addCredentials(url, realm, credentials);

  @override
  void addProxyCredentials(String host, int port, String realm,
      HttpClientCredentials credentials) =>
      _realClient.addProxyCredentials(host, port, realm, credentials);

  @override
  void set authenticate(
      Future<bool> Function(Uri url, String scheme, String realm) f) =>
      _realClient.authenticate = f;

  @override
  void set authenticateProxy(
      Future<bool> Function(
          String host, int port, String scheme, String realm)
      f) =>
      _realClient.authenticateProxy = f;

  @override
  void set badCertificateCallback(
      bool Function(X509Certificate cert, String host, int port)
      callback) =>
      _realClient.badCertificateCallback = callback;

  @override
  void close({bool force = false}) => _realClient.close(force: force);

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      _realClient.delete(host, port, path);

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => _realClient.deleteUrl(url);

  @override
  void set findProxy(String Function(Uri url) f) => _realClient.findProxy = f;

  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      _updateHeaders(_realClient.get(host, port, path));

  Future<HttpClientRequest> _updateHeaders(
      Future<HttpClientRequest> httpClientRequest) async {
    return (await httpClientRequest)
      ..headers.add("Access-Control-Allow-Origin","*")
      ..headers.add("Access-Control-Allow-Headers","Origin, X-Requested-With, Content-Type, Accept, Authorization")
      ..headers.add("Access-Control-Allow-Methods","PUT, POST, DELETE, GET, PATCH");
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) =>
      _updateHeaders(_realClient.getUrl(url.replace(path: url.path)));

  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      _realClient.head(host, port, path);

  @override
  Future<HttpClientRequest> headUrl(Uri url) => _realClient.headUrl(url);

  @override
  Future<HttpClientRequest> open(
      String method, String host, int port, String path) =>
      _realClient.open(method, host, port, path);

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) =>
      _realClient.openUrl(method, url);

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      _realClient.patch(host, port, path);

  @override
  Future<HttpClientRequest> patchUrl(Uri url) => _realClient.patchUrl(url);

  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      _realClient.post(host, port, path);

  @override
  Future<HttpClientRequest> postUrl(Uri url) => _realClient.postUrl(url);

  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      _realClient.put(host, port, path);

  @override
  Future<HttpClientRequest> putUrl(Uri url) => _realClient.putUrl(url);
}
