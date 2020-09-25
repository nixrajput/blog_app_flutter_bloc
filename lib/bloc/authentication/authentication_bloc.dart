import 'package:bloc/bloc.dart';
import 'package:blog_api_app/bloc/authentication/bloc.dart';
import 'package:blog_api_app/repository/user_repository.dart';
import 'package:flutter/material.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.autoLogin();

      if (isSignedIn) {
        final userId = _userRepository.userId;
        final token = _userRepository.token;
        final isFirstTime = await _userRepository.isFirstTime(userId);

        if (isFirstTime) {
          yield AuthenticatedButNotSet(userId: userId, token: token);
        } else {
          yield Authenticated(userId: userId, token: token);
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final userId = _userRepository.userId;
    final token = _userRepository.token;
    final isFirstTime = await _userRepository.isFirstTime(userId);

    if (isFirstTime) {
      yield AuthenticatedButNotSet(userId: userId, token: token);
    } else {
      yield Authenticated(userId: userId, token: token);
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.logout();
  }
}
