import 'package:blog_api_app/bloc/blog/bloc.dart';
import 'package:blog_api_app/repository/user_repository.dart';
import 'package:blog_api_app/widgets/post/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_time_ago/get_time_ago.dart';

class HomeView extends StatelessWidget {
  final UserRepository _userRepository;
  final GlobalKey<ScaffoldState> scaffoldKey;

  HomeView(
      {@required UserRepository userRepository, @required this.scaffoldKey})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogBloc, BlogState>(
      listener: (ctx, state) {
        if (state is LoadingState) {
          CircularProgressIndicator();
        }
      },
      child: BlocBuilder<BlogBloc, BlogState>(
        builder: (ctx, state) {
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<BlogBloc>(context).add(BlogLoadListEvent());
            },
            child: Column(
              children: [
                SizedBox(height: 10.0),
                if (state is LoadingState)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if (state is LoadPostState)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.blogPost.results.length,
                      itemBuilder: (ctx, i) {
                        return BlogPostItem(
                          title: state.blogPost.results[i].title,
                          body: state.blogPost.results[i].body,
                          imageUrl: state.blogPost.results[i].image,
                          timestamp: TimeAgo.getTimeAgo(DateTime.parse(
                              state.blogPost.results[i].timestamp)),
                          author: state.blogPost.results[i].author,
                          authorId: state.blogPost.results[i].authorId,
                          profilePicUrl:
                              state.blogPost.results[i].profilePicUrl.image,
                          currentUserId: _userRepository.userId,
                          slug: state.blogPost.results[i].slug,
                          isLiked: state.blogPost.results[i].isLiked,
                          likeCount:
                              state.blogPost.results[i].likes.length.toString(),
                          scaffoldKey: scaffoldKey,
                        );
                      },
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
