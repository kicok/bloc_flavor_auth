import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc.dart';
import '../pages/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _skey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    tryAutoLogin();
  }

  void tryAutoLogin() {
    BlocProvider.of<AuthBloc>(context).add(AppStarted());
  }

  void _login() {
    BlocProvider.of<AuthBloc>(context).add(LoginRequested());
  }

  void _showAuthError() {
    _skey.currentState.showSnackBar(
      SnackBar(
        content: Text('Login Failure'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _skey,
      appBar: AppBar(
        title: Text('LoginPage3'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            _showAuthError();
          }
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, DashboardPage.routeName);
          }
        },
        builder: (context, state) {
          if (state is AppStartedInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          //Authenticated 상태지만 아주 잠시 동안 순간적으로 로그인 화면이 보이므로 Splash Screen화면으로 대처한다.
          if (state is Authenticated) {
            return Center(
              child: Text('Splah Screen'),
            );
          }
          return Center(
            child: state is AuthInprogress
                ? SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(),
                  )
                : RaisedButton(
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: _login,
                  ),
          );
        },
      ),
    );
  }
}
