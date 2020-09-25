import 'package:blog_api_app/bloc/profile/bloc.dart';
import 'package:blog_api_app/widgets/app_bar/custom_page_app_bar.dart';
import 'package:blog_api_app/widgets/card/followers_card.dart';
import 'package:blog_api_app/widgets/common/custom_body_text.dart';
import 'package:blog_api_app/widgets/image_helper/rounded_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class UserProfile extends StatefulWidget {
  final String userId;

  const UserProfile(this.userId);

  @override
  _UserProfileState createState() => _UserProfileState(userId);
}

class _UserProfileState extends State<UserProfile> {
  _UserProfileState(this._userId);

  ProfileBloc _profileBloc;
  String _userId;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _profileBloc.add(ProfileLoadOtherUserDataEvent(userId: _userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (ctx, state) {
            if (state is ProfileLoadingState) {
              return CircularProgressIndicator();
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (ctx, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is ProfileLoadingState) SizedBox(height: 10.0),
                  if (state is ProfileLoadingState)
                    Center(child: CircularProgressIndicator()),
                  if (state is ProfileLoadedDataState)
                    CustomPageAppBar(
                      mainIcon: Icons.arrow_back_ios,
                      onPressed: () => Navigator.pop(context),
                      title: state.userData.username,
                      actions: Center(),
                    ),
                  if (state is ProfileLoadedDataState)
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 10.0),
                          if (state.userData.profilePicture != null)
                            RoundedNetworkImage(
                              imageSize: 200.0,
                              imageUrl: state.userData.profilePicture.image,
                              strokeWidth: 0.0,
                              strokeColor: Theme.of(context).accentColor,
                            ),
                          SizedBox(height: 10.0),
                          Text(
                            "${state.userData.firstName} ${state.userData.lastName}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              fontFamily: "Raleway",
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              state.userData.about == null ||
                                      state.userData.about == ''
                                  ? "Write something about you..."
                                  : "${state.userData.about}",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          RaisedButton(
                            onPressed: () {
                              _profileBloc.add(ProfileUserFollowToggleEvent(
                                  userId: _userId));
                            },
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.15,
                            ),
                            color: state.userData.isFollowing
                                ? Theme.of(context).accentColor
                                : Theme.of(context).scaffoldBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              side: state.userData.isFollowing
                                  ? BorderSide(color: Colors.transparent)
                                  : BorderSide(
                                      color: Theme.of(context).accentColor),
                            ),
                            child: Text(
                              state.userData.isFollowing
                                  ? "Following"
                                  : "Follow",
                              style: TextStyle(
                                color: state.userData.isFollowing
                                    ? Theme.of(context).scaffoldBackgroundColor
                                    : Theme.of(context).accentColor,
                              ),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          SizedBox(height: 10.0),
                          CustomBodyText(
                            icon: AntDesign.mail,
                            value: "${state.userData.email}",
                          ),
                          // CustomBodyText(
                          //   icon: AntDesign.phone,
                          //   value: "${state.userData.phone}",
                          // ),
                          // CustomBodyText(
                          //     icon: AntDesign.calendar,
                          //     value: DateFormat('dd-MMM-y').format(
                          //       DateTime.parse("${state.userData.dob}"),
                          //     )),
                          FollowersCard(
                            followers:
                                "${state.userData.followers.length.toString()}",
                            following:
                                "${state.userData.following.length.toString()}",
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
