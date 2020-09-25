import 'package:blog_api_app/bloc/blog/blog_event.dart';
import 'package:blog_api_app/bloc/blog/blog_state.dart';
import 'package:blog_api_app/repository/blog_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogRepository _blogRepository;

  BlogBloc({@required BlogRepository blogRepository})
      : assert(blogRepository != null),
        _blogRepository = blogRepository;

  @override
  BlogState get initialState => LoadingState();

  @override
  Stream<BlogState> mapEventToState(BlogEvent event) async* {
    if (event is BlogLoadListEvent) {
      yield* _mapLoadListToState();
    } else if (event is BlogLikeToggleEvent) {
      yield* _mapToBlogLikeToggleToState(slug: event.slug);
    } else if (event is BlogDeleteEvent) {
      yield* _mapToBlogDeleteToState(
          slug: event.slug, scaffoldKey: event.scaffoldKey);
    }
  }

  Stream<BlogState> _mapLoadListToState() async* {
    try {
      yield LoadingState();
      final blogList = await _blogRepository.fetchBlogPost();
      yield LoadPostState(blogPost: blogList);
      if (blogList.error != null) {
        yield BlogPostError(blogList.error);
      }
    } on NetworkError {
      yield BlogPostError("Network Error");
    }
  }

  Stream<BlogState> _mapToBlogLikeToggleToState({String slug}) async* {
    try {
      await _blogRepository.postLikeToggle(slug);
      final blogList = await _blogRepository.fetchBlogPost();
      yield LoadPostState(blogPost: blogList);
      if (blogList.error != null) {
        yield BlogPostError(blogList.error);
      }
    } on NetworkError {
      yield BlogPostError("Network Error");
    }
  }

  Stream<BlogState> _mapToBlogDeleteToState(
      {String slug, GlobalKey<ScaffoldState> scaffoldKey}) async* {
    try {
      await _blogRepository.deletePost(slug);
      final blogList = await _blogRepository.fetchBlogPost();
      yield LoadPostState(blogPost: blogList);
      scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Post Deleted"),
                Icon(Icons.delete_forever_outlined),
              ],
            ),
          ),
        );
      if (blogList.error != null) {
        yield BlogPostError(blogList.error);
      }
    } on NetworkError {
      yield BlogPostError("Network Error");
    }
  }
}
