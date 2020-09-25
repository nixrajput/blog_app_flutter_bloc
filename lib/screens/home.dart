import 'package:blog_api_app/bloc/authentication/bloc.dart';
import 'package:blog_api_app/bloc/blog/bloc.dart';
import 'package:blog_api_app/bloc/profile/bloc.dart';
import 'package:blog_api_app/repository/user_repository.dart';
import 'package:blog_api_app/screens/add_post.dart';
import 'package:blog_api_app/screens/profile.dart';
import 'package:blog_api_app/screens/settings.dart';
import 'package:blog_api_app/screens/views/chat_view.dart';
import 'package:blog_api_app/screens/views/home_view.dart';
import 'package:blog_api_app/screens/views/notification_view.dart';
import 'package:blog_api_app/screens/views/search_view.dart';
import 'package:blog_api_app/widgets/app_bar/custom_main_app_bar.dart';
import 'package:blog_api_app/widgets/buttons/bottom_sheet_button.dart';
import 'package:blog_api_app/widgets/common/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class Home extends StatefulWidget {
  final UserRepository _userRepository;

  Home({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  UserRepository get _userRepository => widget._userRepository;

  PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage((index),
          duration: Duration(milliseconds: 100), curve: Curves.easeInCirc);
    });
  }

  BlogBloc _blogBloc;
  ProfileBloc _profileBloc;

  @override
  void initState() {
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _profileBloc.add(ProfileLoadDataEvent());
    _blogBloc = BlocProvider.of<BlogBloc>(context);
    _blogBloc.add(BlogLoadListEvent());
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showSettingBottomSheet(BuildContext context) {
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
          BlocBuilder<ProfileBloc, ProfileState>(builder: (ctx, state) {
            return Container(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 10.0,
                left: 20.0,
                right: 20.0,
              ),
              child: state is ProfileLoadedDataState
                  ? Text(
                      state.userData.username,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Alata",
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    )
                  : Text(
                      "Loading...",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Alata",
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
            );
          }),
          SizedBox(height: 10.0),
          CustomDivider(),
          BottomSheetButton(
            icon: AntDesign.profile,
            title: "Profile",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Profile(
                  userRepository: _userRepository,
                );
              }));
            },
          ),
          BottomSheetButton(
            icon: AntDesign.setting,
            title: "Settings",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Settings(
                  userRepository: _userRepository,
                );
              }));
            },
          ),
          BottomSheetButton(
            icon: AntDesign.close,
            title: "Logout",
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Column(
            children: [
              CustomMainAppBar(
                title: "BlogAPI",
                actions: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return CreateBlogPost(
                            userRepository: _userRepository,
                          );
                        }));
                      },
                      child: Icon(
                        Icons.add,
                        size: 30.0,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    SizedBox(width: 20.0),
                    GestureDetector(
                      onTap: () => _showSettingBottomSheet(context),
                      child: Icon(
                        Icons.more_vert_rounded,
                        size: 30.0,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    pageChanged(index);
                  },
                  children: <Widget>[
                    HomeView(
                      userRepository: _userRepository,
                      scaffoldKey: _scaffoldKey,
                    ),
                    SearchView(),
                    ChatView(),
                    NotificationView(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 8.0,
          child: bottomAppBar(),
        ));
  }

  Column bottomAppBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 16.0,
          ),
          height: 56.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  AntDesign.home,
                  size: 24.0,
                  color: _currentIndex == 0
                      ? Theme.of(context).accentColor
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                  bottomTapped(0);
                },
              ),
              IconButton(
                icon: Icon(
                  Feather.search,
                  size: 24.0,
                  color: _currentIndex == 1
                      ? Theme.of(context).accentColor
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                  bottomTapped(1);
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.message1,
                  size: 24.0,
                  color: _currentIndex == 2
                      ? Theme.of(context).accentColor
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                  bottomTapped(2);
                },
              ),
              IconButton(
                icon: Icon(
                  Ionicons.ios_notifications_outline,
                  size: 24.0,
                  color: _currentIndex == 3
                      ? Theme.of(context).accentColor
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                  bottomTapped(3);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
