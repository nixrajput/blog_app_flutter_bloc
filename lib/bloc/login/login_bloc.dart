import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_api_app/bloc/login/bloc.dart';
import 'package:blog_api_app/repository/user_repository.dart';
import 'package:meta/meta.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          username: event.username, password: event.password);
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String username,
    String password,
  }) async* {
    yield LoginState.loading();

    try {
      await _userRepository.logInUser(username, password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
