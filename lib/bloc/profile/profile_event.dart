import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileCompleteEvent extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String dob;
  final String gender;

  ProfileCompleteEvent({
    @required this.firstName,
    @required this.lastName,
    @required this.phone,
    @required this.dob,
    @required this.gender,
  });

  @override
  List<Object> get props => [firstName, lastName, phone, dob, gender];
}

class ProfileLoadDataEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class ProfileLoadOtherUserDataEvent extends ProfileEvent {
  final String userId;

  ProfileLoadOtherUserDataEvent({@required this.userId});

  @override
  List<Object> get props => [userId];
}

class ProfilePictureUploadEvent extends ProfileEvent {
  final File imageFile;
  final String timestamp;

  ProfilePictureUploadEvent({
    @required this.imageFile,
    @required this.timestamp,
  });

  @override
  List<Object> get props => [imageFile, timestamp];
}

class ProfileUserFollowToggleEvent extends ProfileEvent {
  final String userId;

  ProfileUserFollowToggleEvent({@required this.userId});

  @override
  List<Object> get props => [userId];
}
