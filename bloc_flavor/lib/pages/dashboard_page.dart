import 'package:bloc_flavor/blocs/app_config_bloc.dart';
import 'package:bloc_flavor/blocs/get_data_bloc.dart';
import 'package:bloc_flavor/blocs/auth_bloc.dart';
import 'package:bloc_flavor/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  GlobalKey<ScaffoldState> _sKey = GlobalKey<ScaffoldState>();
  String _message = '';

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _showGetDataError(String errMessage) {
    _sKey.currentState.showSnackBar(
      SnackBar(
        content: Text(errMessage),
      ),
    );
  }

  void _getData() {
    BlocProvider.of<GetDataBloc>(context).add(GetDataRequested());
  }

  String _title(mode) {
    return mode.appConfig.buildFlavor == 'dev'
        ? 'Dev Dashboard'
        : 'Prod DashBoard';
  }

  @override
  Widget build(BuildContext context) {
    final mode = BlocProvider.of<AppConfigBloc>(context);
    return Scaffold(
      key: _sKey,
      appBar: AppBar(
        title: Text(_title(mode)),
        actions: [
          FlatButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginPage.routeName, (route) => false);
            },
            child: Icon(
              Icons.exit_to_app,
              size: 30,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: BlocConsumer<GetDataBloc, GetDataState>(
        listener: (context, state) {
          if (state is GetDataRequestedFailure) {
            _showGetDataError(state.errMessage);
          }
        },
        builder: (context, state) {
          if (state is GetDataInProgress) {
            if (mode.appConfig.buildFlavor == 'dev') {
              print('Getting Data in Progress');
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetDataRequestedSuccess) {
            if (mode.appConfig.buildFlavor == 'dev') {
              print('Successfully Getting Data');
            }
            _message = state.message;
          }

          return Center(
            child: Text(
              _message,
              style: TextStyle(fontSize: 18),
            ),
          );
        },
      ),
    );
  }
}
