import 'package:blog_api_app/bloc/authentication/bloc.dart';
import 'package:blog_api_app/bloc/login/bloc.dart';
import 'package:blog_api_app/repository/user_repository.dart';
import 'package:blog_api_app/screens/register.dart';
import 'package:blog_api_app/widgets/card/custom_body_card.dart';
import 'package:blog_api_app/widgets/loaders/custom_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  final UserRepository _userRepository;

  Login({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    super.initState();
  }

  void _onFormSubmitted() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _loginBloc.add(
        LoginWithCredentialsPressed(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocListener<LoginBloc, LoginState>(
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
                      Text("Login Failed"),
                      Icon(Icons.error),
                    ],
                  ),
                ),
              );
          }

          if (state.isSuccess) {
            print("Success");
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
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
                                  "Sign In".toUpperCase(),
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
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  "Forgot Password?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                RaisedButton(
                                  onPressed: _onFormSubmitted,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                  child: Text(
                                    "Login".toUpperCase(),
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
                                      return Register(
                                        userRepository: _userRepository,
                                      );
                                    }));
                                  },
                                  child: Text(
                                    "Create an Account".toUpperCase(),
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
