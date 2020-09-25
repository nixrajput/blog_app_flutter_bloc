import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:blog_api_app/bloc/profile/bloc.dart';
import 'package:blog_api_app/repository/user_repository.dart';
import 'package:meta/meta.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository _userRepository;

  ProfileBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ProfileState get initialState => ProfileLoadingState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileCompleteEvent) {
      yield* _mapSubmittedToState(
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
        dob: event.dob,
        gender: event.gender,
      );
    } else if (event is ProfileLoadDataEvent) {
      yield* _mapToLoadUserDataToState();
    } else if (event is ProfilePictureUploadEvent) {
      yield* _mapToUploadProfilePicToState(
        imageFile: event.imageFile,
        timestamp: event.timestamp,
      );
    } else if (event is ProfileLoadOtherUserDataEvent) {
      yield* _mapToLoadOtherUserDataToState(userId: event.userId);
    } else if (event is ProfileUserFollowToggleEvent) {
      yield* _mapToUserFollowToggleToState(userId: event.userId);
    }
  }

  Stream<ProfileState> _mapToLoadUserDataToState() async* {
    try {
      yield ProfileLoadingState();
      final userData = await _userRepository.fetchCurrentUserData();
      yield ProfileLoadedDataState(userData: userData);
      if (userData.error != null) {
        yield ProfileErrorState(userData.error);
      }
    } on NetworkError {
      yield ProfileErrorState("Network Error");
    }
  }

  Stream<ProfileState> _mapToLoadOtherUserDataToState({String userId}) async* {
    try {
      yield ProfileLoadingState();
      final userData = await _userRepository.fetchUserData(userId);
      yield ProfileLoadedDataState(userData: userData);
      if (userData.error != null) {
        yield ProfileErrorState(userData.error);
      }
    } on NetworkError {
      yield ProfileErrorState("Network Error");
    }
  }

  Stream<ProfileState> _mapToUserFollowToggleToState({String userId}) async* {
    try {
      await _userRepository.userFollowToggle(userId);
      final userData = await _userRepository.fetchUserData(userId);
      yield ProfileLoadedDataState(userData: userData);
      if (userData.error != null) {
        yield ProfileErrorState(userData.error);
      }
    } on NetworkError {
      yield ProfileErrorState("Network Error");
    }
  }

  Stream<ProfileState> _mapToUploadProfilePicToState({
    File imageFile,
    String timestamp,
  }) async* {
    yield ProfileLoadingState();
    try {
      await _userRepository.uploadProfilePicture(imageFile, timestamp);
      final userData = await _userRepository.fetchCurrentUserData();
      yield ProfileLoadedDataState(userData: userData);
    } catch (_) {
      yield ProfileErrorState("Error Occurred");
    }
  }

  Stream<ProfileState> _mapSubmittedToState({
    String firstName,
    String lastName,
    String phone,
    String dob,
    String gender,
  }) async* {
    yield ProfileLoadingState();
    try {
      await _userRepository.profileSetup(
        firstName,
        lastName,
        phone,
        dob,
        gender,
      );
      yield ProfileSuccessState();
    } catch (_) {
      yield ProfileErrorState("Error Occurred");
    }
  }
}
