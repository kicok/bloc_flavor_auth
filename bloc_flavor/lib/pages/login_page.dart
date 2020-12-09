import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginPage'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
