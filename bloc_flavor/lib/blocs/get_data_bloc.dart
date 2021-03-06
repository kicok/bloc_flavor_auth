import 'dart:async';

import 'app_config_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/auth_repository.dart';
import '../repositories/get_data_repository.dart';

//events
abstract class GetDataEvent extends Equatable {}

class GetDataRequested extends GetDataEvent {
  @override
  List<Object> get props => [];
}

//states
abstract class GetDataState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetDataInitial extends GetDataState {}

class GetDataInProgress extends GetDataState {}

class GetDataRequestedSuccess extends GetDataState {
  final String message;

  GetDataRequestedSuccess({@required this.message}) : assert(message != null);

  @override
  List<Object> get props => [message];
}

class GetDataRequestedFailure extends GetDataState {
  final String errMessage;

  GetDataRequestedFailure({@required this.errMessage})
      : assert(errMessage != null);

  @override
  List<Object> get props => [errMessage];
}

// bloc
class GetDataBloc extends Bloc<GetDataEvent, GetDataState> {
  final GetDataRepository getDataRepository;
  final AuthRepository authRepository;
  final AppConfigBloc appConfigBloc;

  StreamSubscription appConfigSubscription;
  String baseUrl, dataUrl, buildFlavor;

  GetDataBloc({
    @required this.getDataRepository,
    @required this.authRepository,
    @required this.appConfigBloc,
  })  : assert(getDataRepository != null),
        assert(authRepository != null),
        assert(appConfigBloc != null),
        super(GetDataInitial()) {
    appConfigSubscription = appConfigBloc.listen((appconfigState) {
      if (appconfigState is AppConfigState) {
        baseUrl = appconfigState.appConfig.baseUrl;
        dataUrl = appconfigState.appConfig.dataUrl;
        buildFlavor = appconfigState.appConfig.buildFlavor;

        print('in GetDataBloc baseUrl : $baseUrl');
        print('in GetDataBloc dataUrl : $dataUrl');
        print('in GetDataBloc buildFlavor : $buildFlavor');
      }
    });
  }

  @override
  Future<void> close() {
    appConfigSubscription.cancel();
    return super.close();
  }

  @override
  Stream<GetDataState> mapEventToState(GetDataEvent event) async* {
    if (event is GetDataRequested) {
      yield GetDataInProgress();
      Future.delayed(Duration(seconds: 1));

      try {
        final String token = await authRepository.getToken();
        final String message = await getDataRepository.getData(dataUrl, token);

        if (buildFlavor == 'dev') {
          print('token value in GetDataBloc: $token');
          print('message in GetDataBloc: $message');
        }

        yield GetDataRequestedSuccess(message: message);
      } catch (e) {
        yield GetDataRequestedFailure(errMessage: e.toString());
      }
    }
  }
}
