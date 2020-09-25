import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends RegisterEvent {
  final String email;
  final String username;
  final String password;
  final String password2;
  final String timestamp;

  Submitted({
    this.email,
    this.username,
    this.password,
    this.password2,
    this.timestamp,
  });

  @override
  List<Object> get props => [email, username, password, password2, timestamp];
}

class SignUpWithCredentialsPressed extends RegisterEvent {
  final String email;
  final String username;
  final String password;
  final String password2;
  final String timestamp;

  SignUpWithCredentialsPressed({
    @required this.email,
    @required this.username,
    @required this.password,
    @required this.password2,
    @required this.timestamp,
  });

  @override
  List<Object> get props => [email, username, password, password2, timestamp];
}
