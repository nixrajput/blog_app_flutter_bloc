import 'package:blog_api_app/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {}

class ProfileLoadedDataState extends ProfileState {
  final User userData;

  ProfileLoadedDataState({@required this.userData});

  @override
  List<Object> get props => [userData];
}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);

  @override
  List<Object> get props => [message];
}
