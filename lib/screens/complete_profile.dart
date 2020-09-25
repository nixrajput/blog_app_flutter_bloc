import 'package:blog_api_app/bloc/authentication/bloc.dart';
import 'package:blog_api_app/bloc/profile/bloc.dart';
import 'package:blog_api_app/widgets/app_bar/custom_page_app_bar.dart';
import 'package:blog_api_app/widgets/choosers/custom_date_chooser.dart';
import 'package:blog_api_app/widgets/loaders/custom_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CompleteProfile extends StatefulWidget {
  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _dobController;
  var _genderController;

  List<String> _genderList = ["male", "female", "other"];

  ProfileBloc _profileBloc;

  Future<void> _selectDate() async {
    DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      setState(() {
        _dobController = DateFormat("y-MM-dd").format(pickedDate);
      });
    }
  }

  _onSubmitted() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid && _dobController != null && _genderController != null) {
      print(_firstNameController.text);
      print(_lastNameController.text);
      print(_phoneController.text);
      print(_dobController);
      print(_genderController);

      _profileBloc.add(
        ProfileCompleteEvent(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phone: _phoneController.text.trim(),
          dob: _dobController,
          gender: _genderController,
        ),
      );
    } else {
      _scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('All fields are required.'),
                Icon(Icons.info_outline_rounded)
              ],
            ),
          ),
        );
    }
  }

  @override
  void initState() {
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomPageAppBar(
              mainIcon: null,
              onPressed: () {},
              title: "Setup Profile",
              actions: Center(),
            ),
            Expanded(
              child: BlocListener<ProfileBloc, ProfileState>(
                listener: (ctx, state) {
                  if (state is ProfileErrorState) {
                    print("Failed");
                    _scaffoldKey.currentState
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Profile Creation Unsuccessful'),
                              Icon(Icons.error)
                            ],
                          ),
                        ),
                      );
                  }

                  if (state is ProfileSuccessState) {
                    print("Success!");
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(LoggedIn());
                  }
                },
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (ctx, state) {
                    return state is ProfileLoadingState
                        ? CustomLoadingScreen()
                        : SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: TextFormField(
                                      controller: _firstNameController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "First Name can't be empty!";
                                        } else if (value.length < 3) {
                                          return "First Name must be at least 3 characters long!";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "First Name",
                                        errorMaxLines: 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: TextFormField(
                                      controller: _lastNameController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Last Name can't be empty!";
                                        } else if (value.length < 3) {
                                          return "Last Name must be at least 3 characters long!";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Last Name",
                                        errorMaxLines: 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: TextFormField(
                                      controller: _phoneController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Phone Number can't be empty!";
                                        } else if (value.length < 10) {
                                          return "Phone Number is invalid!";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Phone",
                                        errorMaxLines: 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: CustomDateChooser(
                                      labelText: "Birth Date",
                                      valueText: _dobController == null
                                          ? "Choose Date"
                                          : DateFormat('dd-MMM-y').format(
                                              DateTime.parse(_dobController)),
                                      onPressed: _selectDate,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: DropdownButtonFormField(
                                      value: _genderController,
                                      isExpanded: true,
                                      hint: Text(
                                        "Gender",
                                      ),
                                      items: _genderList
                                          .map((gender) => DropdownMenuItem(
                                                child: Text(
                                                  gender
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                value: gender,
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _genderController = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40.0,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: RaisedButton(
                                      onPressed: _onSubmitted,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                      ),
                                      child: Text(
                                        "SAVE".toUpperCase(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
