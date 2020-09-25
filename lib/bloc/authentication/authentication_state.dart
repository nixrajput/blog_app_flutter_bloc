import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String userId;
  final String token;

  Authenticated({this.userId, this.token});

  @override
  List<Object> get props => [userId, token];

  @override
  String toString() => "Authenticated $userId";
}

class AuthenticatedButNotSet extends AuthenticationState {
  final String userId;
  final String token;

  AuthenticatedButNotSet({this.userId, this.token});

  @override
  List<Object> get props => [userId, token];
}

class Unauthenticated extends AuthenticationState {}
