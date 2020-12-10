import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import './blocs/app_config_bloc.dart';
import './blocs/get_data_bloc.dart';
import './repositories/get_data_repository.dart';
import 'models/app_config.dart';
import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';
import './repositories/auth_repository.dart';
import './blocs/auth_bloc.dart';

class MyApp extends StatelessWidget {
  final AppConfig appConfig;

  final AuthRepository authRepository = AuthRepository(
    httpClient: http.Client(),
  );

  final GetDataRepository getDataRepository = GetDataRepository(
    httpClient: http.Client(),
  );

  MyApp({Key key, this.appConfig})
      : assert(appConfig != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppConfigBloc(appConfig: appConfig),
        ),
        BlocProvider<AuthBloc>(
          lazy: false,
          create: (context) {
            // AppConfigBloc 에 super(add(AppConfigEvent()));  이 코드를 추가하였으므로 아래의 코드는 주석처리해도 값을 가져올수 있다.
            //BlocProvider.of<AppConfigBloc>(context).add(AppConfigEvent());
            return AuthBloc(
              authRepository: authRepository,
              appConfigBloc: BlocProvider.of<AppConfigBloc>(context),
            );
          },
        ),
        BlocProvider(
          lazy: false,
          create: (context) {
            // AppConfigBloc 에 super(add(AppConfigEvent()));  이 코드를 추가하였으므로 아래의 코드는 주석처리해도 값을 가져올수 있다.
            // BlocProvider.of<AppConfigBloc>(context).add(AppConfigEvent());
            return GetDataBloc(
              getDataRepository: getDataRepository,
              authRepository: authRepository,
              appConfigBloc: BlocProvider.of<AppConfigBloc>(context),
            );
          },
        ),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
