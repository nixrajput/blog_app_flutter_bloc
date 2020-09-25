import 'package:blog_api_app/bloc/blog/bloc.dart';
import 'package:blog_api_app/screens/user_profile.dart';
import 'package:blog_api_app/widgets/buttons/bottom_sheet_button.dart';
import 'package:blog_api_app/widgets/image_helper/rounded_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class BlogPostItem extends StatelessWidget {
  final String title;
  final String body;
  final String imageUrl;
  final String slug;
  final String timestamp;
  final String author;
  final String authorId;
  final String profilePicUrl;
  final String currentUserId;
  final String likeCount;
  final bool isLiked;
  final String commentCount;
  final String repeatCount;
  final GlobalKey<ScaffoldState> scaffoldKey;

  BlogPostItem({
    @required this.title,
    @required this.body,
    @required this.imageUrl,
    @required this.slug,
    @required this.timestamp,
    @required this.author,
    @required this.authorId,
    @required this.profilePicUrl,
    @required this.currentUserId,
    this.likeCount = "0",
    this.isLiked = false,
    this.commentCount = "0",
    this.repeatCount = "0",
    this.scaffoldKey,
  });

  void _showPostBottomSheet(
      BuildContext context, String slug, String authorId, String author) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        context: context,
        builder: (ctx) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (authorId != currentUserId)
                  BottomSheetButton(
                    icon: AntDesign.adduser,
                    title: "View @$author",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UserProfile(authorId)));
                    },
                  ),
                if (authorId == currentUserId)
                  BottomSheetButton(
                    title: "Edit",
                    icon: AntDesign.edit,
                    onTap: () {},
                  ),
                if (authorId == currentUserId)
                  BottomSheetButton(
                    title: "Delete",
                    icon: AntDesign.delete,
                    onTap: () {
                      _showDeleteDialog(context, slug);
                    },
                  ),
                BottomSheetButton(
                  title: "Share",
                  icon: AntDesign.sharealt,
                  onTap: () {},
                ),
                BottomSheetButton(
                  title: "Report",
                  icon: AntDesign.flag,
                  onTap: () {},
                ),
              ],
            ));
  }

  void _showDeleteDialog(BuildContext context, String slug) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete"),
        content: Text("Are you sure to delete this post."),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text("NO"),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(ctx);

              BlocProvider.of<BlogBloc>(context)
                  .add(BlogDeleteEvent(slug: slug, scaffoldKey: scaffoldKey));
            },
            child: Text("YES"),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      color: Theme.of(context).bottomAppBarColor,
      child: Column(
        children: [
          postHead(context),
          postBody(context, screenSize),
          postBottom(context),
        ],
      ),
    );
  }

  Widget postHead(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => UserProfile(authorId)));
        },
        child: RoundedNetworkImage(
          imageSize: 48.0,
          imageUrl: profilePicUrl,
          strokeWidth: 0.0,
          strokeColor: Theme.of(context).accentColor,
        ),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => UserProfile(authorId)));
        },
        child: Text(
          author,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Text(
        timestamp,
        style: TextStyle(
          color: Theme.of(context).accentColor.withOpacity(0.8),
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          _showPostBottomSheet(
            context,
            slug,
            authorId,
            author,
          );
        },
        icon: Icon(
          Icons.expand_more,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Widget postBody(BuildContext context, screenSize) {
    return Column(
      children: [
        GestureDetector(
          onDoubleTap: () {
            BlocProvider.of<BlogBloc>(context)
                .add(BlogLikeToggleEvent(slug: slug));
          },
          onLongPress: () {
            _showPostBottomSheet(context, slug, authorId, author);
          },
          child: CachedNetworkImage(
            progressIndicatorBuilder: (ctx, url, downloadProgress) => Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
              ),
            ),
            imageUrl: imageUrl,
            width: screenSize.width,
            fit: BoxFit.cover,
          ),
        ),
        if (title != '' && title != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        if (body != '' && body != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Text(
              body,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          )
      ],
    );
  }

  Widget postBottom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton.icon(
            onPressed: () {
              BlocProvider.of<BlogBloc>(context)
                  .add(BlogLikeToggleEvent(slug: slug));
            },
            icon: Icon(
              isLiked ? AntDesign.heart : AntDesign.hearto,
              color: isLiked ? Colors.deepPurple : Colors.grey,
              size: 20.0,
            ),
            label: Text(
              likeCount,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 16.0,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          FlatButton.icon(
            onPressed: () {},
            icon: Icon(
              Feather.message_circle,
              color: Colors.grey,
              size: 20.0,
            ),
            label: Text(
              commentCount,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 16.0,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          FlatButton.icon(
            onPressed: () {},
            icon: Icon(
              AntDesign.swap,
              color: Colors.grey,
              size: 20.0,
            ),
            label: Text(
              repeatCount,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 16.0,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
