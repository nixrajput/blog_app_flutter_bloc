import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends LoginEvent {
  final String username;
  final String password;

  Submitted({this.username, this.password});

  @override
  List<Object> get props => [username, password];
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String username;
  final String password;

  LoginWithCredentialsPressed(
      {@required this.username, @required this.password});

  @override
  List<Object> get props => [username, password];
}
