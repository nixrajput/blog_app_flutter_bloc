import 'dart:io';

import 'package:blog_api_app/repository/user_repository.dart';
import 'package:blog_api_app/widgets/app_bar/custom_page_app_bar.dart';
import 'package:blog_api_app/widgets/image_helper/image_picker.dart';
import 'package:blog_api_app/widgets/loaders/custom_loading_screen.dart';
import 'package:flutter/material.dart';

class CreateBlogPost extends StatefulWidget {
  final UserRepository _userRepository;

  CreateBlogPost({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _CreateBlogPostState createState() => _CreateBlogPostState();
}

class _CreateBlogPostState extends State<CreateBlogPost> {
  File _userImageFile;
  var _postTitle;
  var _postBody;
  var _isLoading = false;
  AutovalidateMode _autoValidateMode;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  void _pickImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null) {
      final _snackBar = SnackBar(
        content: Text('Please add an image first.'),
        duration: Duration(seconds: 5),
      );
      _scaffoldKey.currentState.showSnackBar(_snackBar);
      return;
    }

    if (isValid) {
      // _formKey.currentState.save();
      //
      // setState(() {
      //   _isLoading = true;
      // });
      //
      // try {
      //   await Provider.of<BlogProvider>(context, listen: false)
      //       .createPost(
      //     _userImageFile,
      //     _postTitle,
      //     _postBody,
      //     DateTime.now().toString(),
      //   )
      //       .then((_) {
      //     final _snackBar = SnackBar(
      //       content: Text('Post added successfully.'),
      //     );
      //     _scaffoldKey.currentState.showSnackBar(_snackBar);
      //     Timer(Duration(seconds: 1), () {
      //       Navigator.pop(context);
      //     });
      //   });
      // } catch (error) {
      //   print(error.toString());
      // }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: _isLoading
            ? CustomLoadingScreen()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomPageAppBar(
                      mainIcon: Icons.arrow_back_ios,
                      onPressed: () => Navigator.pop(context),
                      title: "Add Post",
                      actions: GestureDetector(
                        onTap: _trySubmit,
                        child: Icon(
                          Icons.save,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    CustomImagePicker(
                      _pickImage,
                    ),
                    SizedBox(height: 10.0),
                    Form(
                      key: _formKey,
                      autovalidateMode: _autoValidateMode,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: TextFormField(
                            key: ValueKey('title'),
                            decoration: InputDecoration(
                              labelText: "Title",
                              errorMaxLines: 2,
                            ),
                            onSaved: (value) {
                              _postTitle = value.trim();
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: TextFormField(
                            maxLength: 1000,
                            key: ValueKey('body'),
                            decoration: InputDecoration(
                              labelText: "Write something",
                              errorMaxLines: 2,
                            ),
                            onSaved: (value) {
                              _postBody = value.trim();
                            },
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
