import 'package:blog_api_app/bloc/register/bloc.dart';
import 'package:blog_api_app/repository/user_repository.dart';
import 'package:blog_api_app/screens/login.dart';
import 'package:blog_api_app/validators.dart';
import 'package:blog_api_app/widgets/card/custom_body_card.dart';
import 'package:blog_api_app/widgets/loaders/custom_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Register extends StatefulWidget {
  final UserRepository _userRepository;

  Register({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  bool _obscureText = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  RegisterBloc _registerBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);

    super.initState();
  }

  void _onFormSubmitted() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _registerBloc.add(
        SignUpWithCredentialsPressed(
          email: _emailController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          password2: _password2Controller.text,
          timestamp: DateTime.now().toString(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (ctx, state) {
          if (state.isFailure) {
            print("Error");
            _scaffoldKey.currentState
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Registration Failed"),
                      Icon(Icons.error),
                    ],
                  ),
                ),
              );
          }

          if (state.isSuccess) {
            print("Success");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              return Login(
                userRepository: _userRepository,
              );
            }));
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (ctx, state) {
            return state.isSubmitting
                ? CustomLoadingScreen()
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CustomBodyCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 40.0,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "BlogAPI",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 36.0,
                                    fontFamily: "Kaushan Script",
                                  ),
                                ),
                                Text(
                                  "A Blogging World",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Kaushan Script",
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  "Sign Up".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                    fontFamily: "Alata",
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _emailController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Email can't be empty!";
                                          } else if (!Validators.isValidEmail(
                                              value)) {
                                            return "Invalid Email!";
                                          }
                                          return null;
                                        },
                                        textCapitalization:
                                            TextCapitalization.none,
                                        decoration: InputDecoration(
                                          labelText: "Email",
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _usernameController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Username can't be empty!";
                                          } else if (value.length < 3) {
                                            return "Username must be at least 3 characters long!";
                                          }
                                          return null;
                                        },
                                        autocorrect: false,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        decoration: InputDecoration(
                                          labelText: "Username",
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextFormField(
                                        controller: _passwordController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Password can't be empty!";
                                          } else if (value.length < 7) {
                                            return "Password must be at least 8 characters long!";
                                          }
                                          return null;
                                        },
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                          labelText: "Password",
                                          suffix: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                            child: Text(
                                              _obscureText ? "Show" : "Hide",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _password2Controller,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Password can't be empty!";
                                          } else if (value.length < 7) {
                                            return "Password must be at least 8 characters long!";
                                          } else if (value.trim() !=
                                              _passwordController.text.trim()) {
                                            return "Password doesn't match!";
                                          }
                                          return null;
                                        },
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                          labelText: "Confirm Password",
                                          suffix: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                            child: Text(
                                              _obscureText ? "Show" : "Hide",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                RaisedButton(
                                  onPressed: _onFormSubmitted,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                  child: Text(
                                    "Signup".toUpperCase(),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  color: Theme.of(context).accentColor,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                FlatButton(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (_) {
                                      return Login(
                                        userRepository: _userRepository,
                                      );
                                    }));
                                  },
                                  child: Text(
                                    "Login to account".toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
