import 'package:blog_api_app/bloc/register/bloc.dart';
import 'package:blog_api_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is SignUpWithCredentialsPressed) {
      yield* _mapSignUpWithCredentialsPressedToState(
        email: event.email,
        username: event.username,
        password: event.password,
        password2: event.password2,
        timestamp: event.timestamp,
      );
    }
  }

  Stream<RegisterState> _mapSignUpWithCredentialsPressedToState({
    String email,
    String username,
    String password,
    String password2,
    String timestamp,
  }) async* {
    yield RegisterState.loading();

    try {
      await _userRepository.registerUser(
        email,
        username,
        password,
        password2,
        timestamp,
      );

      yield RegisterState.success();
    } catch (_) {
      RegisterState.failure();
    }
  }
}
