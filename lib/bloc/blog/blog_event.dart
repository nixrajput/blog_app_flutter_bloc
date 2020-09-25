import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

class BlogLoadListEvent extends BlogEvent {
  @override
  List<Object> get props => [];
}

class BlogLikeToggleEvent extends BlogEvent {
  final String slug;

  BlogLikeToggleEvent({@required this.slug});

  @override
  List<Object> get props => [slug];
}

class BlogDeleteEvent extends BlogEvent {
  final String slug;
  final GlobalKey<ScaffoldState> scaffoldKey;

  BlogDeleteEvent({@required this.slug, @required this.scaffoldKey});

  @override
  List<Object> get props => [slug];
}
