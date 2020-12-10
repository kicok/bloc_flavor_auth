import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/app_config.dart';

// event

//이벤트가 단 하나밖에 없으므로 abstract class가 필요 없음.
class AppConfigEvent {}

// state
class AppConfigState {
  final AppConfig appConfig;

  AppConfigState({@required this.appConfig}) : assert(appConfig != null);
}

// bloc
class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final AppConfig appConfig;
  AppConfigBloc({this.appConfig})
      : assert(appConfig != null),
        super(AppConfigState(appConfig: appConfig)) {
    add(AppConfigEvent());
  }

  @override
  Stream<AppConfigState> mapEventToState(AppConfigEvent event) async* {
    yield AppConfigState(appConfig: appConfig);
  }
}
