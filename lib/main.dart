import 'package:blog_api_app/bloc/authentication/bloc.dart';
import 'package:blog_api_app/bloc/bloc_delegate.dart';
import 'package:blog_api_app/bloc/blog/bloc.dart';
import 'package:blog_api_app/bloc/register/bloc.dart';
import 'package:blog_api_app/constants.dart';
import 'package:blog_api_app/repository/blog_repository.dart';
import 'package:blog_api_app/repository/user_repository.dart';
import 'package:blog_api_app/screens/complete_profile.dart';
import 'package:blog_api_app/screens/home.dart';
import 'package:blog_api_app/screens/login.dart';
import 'package:blog_api_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/login/login_bloc.dart';
import 'bloc/profile/profile_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository _userRepository = UserRepository();
  final BlogRepository _blogRepository =
      BlogRepository(userRepository: _userRepository);

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: _userRepository)
        ..add(AppStarted()),
      child: MyApp(
        userRepository: _userRepository,
        blogRepository: _blogRepository,
      )));
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;
  final BlogRepository _blogRepository;

  MyApp(
      {@required UserRepository userRepository,
      @required BlogRepository blogRepository})
      : assert(userRepository != null && blogRepository != null),
        _userRepository = userRepository,
        _blogRepository = blogRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => BlogBloc(blogRepository: _blogRepository),
        ),
        BlocProvider<LoginBloc>(
          create: (ctx) => LoginBloc(userRepository: _userRepository),
        ),
        BlocProvider<RegisterBloc>(
          create: (ctx) => RegisterBloc(userRepository: _userRepository),
        ),
        BlocProvider<ProfileBloc>(
          create: (ctx) => ProfileBloc(userRepository: _userRepository),
        )
      ],
      child: MaterialApp(
        title: 'BlogAPI',
        debugShowCheckedModeBanner: false,
        theme: lightTheme.copyWith(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
                displayColor: Colors.black,
              ),
        ),
        darkTheme: darkTheme.copyWith(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: lightColor,
                displayColor: lightColor,
              ),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (ctx, state) {
            if (state is Uninitialized) {
              return SplashScreen();
            }
            if (state is Authenticated) {
              return Home(userRepository: _userRepository);
            }
            if (state is AuthenticatedButNotSet) {
              return CompleteProfile();
            }
            if (state is Unauthenticated) {
              return Login(userRepository: _userRepository);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
