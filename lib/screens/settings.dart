import 'package:blog_api_app/repository/user_repository.dart';
import 'package:blog_api_app/widgets/app_bar/custom_page_app_bar.dart';
import 'package:blog_api_app/widgets/buttons/setting_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class Settings extends StatefulWidget {
  final UserRepository _userRepository;

  Settings({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            CustomPageAppBar(
              mainIcon: Icons.arrow_back_ios,
              onPressed: () => Navigator.pop(context),
              title: "Settings",
              actions: Center(),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SettingButton(
                    title: "Account",
                    icon: AntDesign.user,
                    onTap: () {},
                  ),
                  SettingButton(
                    title: "Security",
                    icon: AntDesign.lock1,
                    onTap: () {},
                  ),
                  SettingButton(
                    title: "Media",
                    icon: AntDesign.folderopen,
                    onTap: () {},
                  ),
                  SettingButton(
                    title: "Privacy Policy",
                    icon: AntDesign.Safety,
                    onTap: () {},
                  ),
                  SettingButton(
                    title: "About",
                    icon: AntDesign.infocirlceo,
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
