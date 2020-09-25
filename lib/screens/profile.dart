import 'dart:io';

import 'package:blog_api_app/bloc/profile/bloc.dart';
import 'package:blog_api_app/repository/user_repository.dart';
import 'package:blog_api_app/widgets/app_bar/custom_page_app_bar.dart';
import 'package:blog_api_app/widgets/buttons/bottom_sheet_button.dart';
import 'package:blog_api_app/widgets/card/followers_card.dart';
import 'package:blog_api_app/widgets/common/custom_body_text.dart';
import 'package:blog_api_app/widgets/image_helper/rounded_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  final UserRepository _userRepository;

  Profile({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileBloc _profileBloc;
  File _userImageFile;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _profileBloc.add(ProfileLoadDataEvent());
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
                      actions: _userImageFile == null
                          ? Center()
                          : GestureDetector(
                              onTap: _uploadProfilePicture,
                              child: Icon(
                                AntDesign.save,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                    ),
                  if (state is ProfileLoadedDataState)
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 10.0),
                          _imageArea(
                              context, state.userData.profilePicture.image),
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
                            onPressed: () {},
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.15,
                            ),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              side: BorderSide(
                                  color: Theme.of(context).accentColor),
                            ),
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
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
                          CustomBodyText(
                            icon: AntDesign.phone,
                            value: "${state.userData.phone}",
                          ),
                          CustomBodyText(
                              icon: AntDesign.calendar,
                              value: DateFormat('dd-MMM-y').format(
                                DateTime.parse("${state.userData.dob}"),
                              )),
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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final _pickedImage = await picker.getImage(
      source: source,
      imageQuality: 50,
    );

    if (_pickedImage != null) {
      File _croppedFile = await ImageCropper.cropImage(
        sourcePath: _pickedImage.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Theme.of(context).scaffoldBackgroundColor,
          toolbarTitle: "Crop Image",
          toolbarWidgetColor: Theme.of(context).accentColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        iosUiSettings: IOSUiSettings(
          title: "Crop Image",
          minimumAspectRatio: 1.0,
        ),
      );

      setState(() {
        _userImageFile = _croppedFile;
      });
    }
  }

  void _showImageBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        context: context,
        builder: (ctx) => Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BottomSheetButton(
                    title: "Camera",
                    icon: Icons.camera,
                    onTap: () async {
                      await _pickImage(ImageSource.camera);
                    },
                  ),
                  BottomSheetButton(
                    title: "Gallery",
                    icon: Icons.photo,
                    onTap: () async {
                      await _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ));
  }

  void _uploadProfilePicture() async {
    if (_userImageFile != null) {
      _profileBloc.add(ProfilePictureUploadEvent(
        imageFile: _userImageFile,
        timestamp: DateTime.now().toString(),
      ));
      setState(() {
        _userImageFile = null;
      });
    } else {
      _scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Choose an image first.'),
                Icon(Icons.info_outline_rounded)
              ],
            ),
          ),
        );
    }
  }

  Widget _imageArea(BuildContext context, String imageUrl) {
    return imageUrl == null
        ? _userImageFile != null
            ? GestureDetector(
                onTap: () {
                  _showImageBottomSheet(context);
                },
                child: Column(
                  children: [
                    Container(
                      width: 200.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: FileImage(_userImageFile),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : GestureDetector(
                onTap: () {
                  _showImageBottomSheet(context);
                },
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "Add Image",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
              )
        : _userImageFile != null
            ? GestureDetector(
                onTap: () {
                  _showImageBottomSheet(context);
                },
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: FileImage(_userImageFile),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  _showImageBottomSheet(context);
                },
                child: RoundedNetworkImage(
                  imageSize: 200.0,
                  imageUrl: imageUrl,
                  strokeWidth: 0.0,
                  strokeColor: Theme.of(context).accentColor,
                ),
              );
  }
}
