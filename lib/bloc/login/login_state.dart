import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  LoginState(
      {@required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure});

  //initial state
  factory LoginState.empty() {
    return LoginState(
      isSubmitting: false,
      isFailure: false,
      isSuccess: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isSubmitting: true,
      isFailure: false,
      isSuccess: false,
    );
  }

  factory LoginState.failure() {
    return LoginState(
      isSubmitting: false,
      isFailure: true,
      isSuccess: false,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isSubmitting: false,
      isFailure: false,
      isSuccess: true,
    );
  }

  LoginState update() {
    return copyWith(
      isSubmitting: false,
      isFailure: false,
      isSuccess: false,
    );
  }

  LoginState copyWith({
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return LoginState(
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }
}
