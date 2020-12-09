import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  static const routeName = '/dashboard';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DashboardPage'),
        actions: [
          FlatButton(
            onPressed: () {},
            child: Icon(
              Icons.exit_to_app,
              size: 30,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Center(
        child: Text('DashboardPage'),
      ),
    );
  }
}
