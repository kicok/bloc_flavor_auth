import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_config_bloc.dart';
import '../repositories/auth_repository.dart';

// events
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {} //hot restarted 이벤트

class LoginRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

// states
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthUninitialized extends AuthState {} // 초기상태

class AppStartedInProgress extends AuthState {} // AppStarted 이벤트

class AuthInprogress extends AuthState {} // LoginRequested 진행

class Authenticated extends AuthState {
  final String token; //Login Success 상태이므로 언제나 token에 접근 가능
  Authenticated({@required this.token}) : assert(token != null);
}

class UnAuthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String errMessage; // 로그인 실패 메세지
  AuthFailure({@required this.errMessage}) : assert(errMessage != null);
}

// bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final AppConfigBloc appConfigBloc;

  StreamSubscription appConfigSubscription;
  String baseUrl, dataUrl, buildFlavor;

  AuthBloc({
    @required this.authRepository,
    @required this.appConfigBloc,
  })  : assert(authRepository != null),
        assert(appConfigBloc != null),
        super(AuthUninitialized()) {
    appConfigSubscription = appConfigBloc.listen((appconfigState) {
      if (appconfigState is AppConfigState) {
        baseUrl = appconfigState.appConfig.baseUrl;
        dataUrl = appconfigState.appConfig.dataUrl;
        buildFlavor = appconfigState.appConfig.buildFlavor;

        print('in AuthBloc baseUrl : $baseUrl');
        print('in AuthBloc dataUrl : $dataUrl');
        print('in AuthBloc buildFlavor : $buildFlavor');
      }
    });
  }

  @override
  Future<void> close() {
    appConfigSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    // 로그인 요청
    if (event is LoginRequested) {
      yield AuthInprogress();
      await Future.delayed(Duration(seconds: 1));

      try {
        final String token = await authRepository.login(baseUrl);

        if (buildFlavor == 'dev') {
          print('token in AuthBloc: $token');
        }

        // 로그인 유지를 위해 SharedPreferences 에  jwtToken기록
        await authRepository.persistToken(token);

        yield Authenticated(token: token); // 실제 현재 프로젝트에서는 활용되고 있지는 않음.

      } catch (e) {
        yield AuthFailure(errMessage: e.toString());
      }
    }

    if (event is AppStarted) {
      yield AppStartedInProgress();
      await Future.delayed(Duration(seconds: 1));

      if (await authRepository.hasToken()) {
        final String token = await authRepository.getToken();
        yield Authenticated(token: token); // 실제 현재 프로젝트에서는 활용되고 있지는 않음.
      } else {
        yield UnAuthenticated();
      }
    }

    if (event is LogoutRequested) {
      await authRepository.deleteToken();
      yield UnAuthenticated();
    }
  }
}
