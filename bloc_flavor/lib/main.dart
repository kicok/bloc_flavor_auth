import 'package:flutter/material.dart';

import 'models/app_config.dart';
import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';

class MyApp extends StatelessWidget {
  final AppConfig appConfig;

  const MyApp({Key key, this.appConfig})
      : assert(appConfig != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc & Flavors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        DashboardPage.routeName: (context) => DashboardPage(),
      },
    );
  }
}
