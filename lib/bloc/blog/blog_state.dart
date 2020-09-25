import 'package:blog_api_app/models/blog_post.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object> get props => [];
}

class LoadingState extends BlogState {}

class LoadPostState extends BlogState {
  final BlogPost blogPost;

  LoadPostState({@required this.blogPost});

  @override
  List<Object> get props => [blogPost];
}

class BlogPostError extends BlogState {
  final String message;

  BlogPostError(this.message);

  @override
  List<Object> get props => [message];
}
