import 'package:blog_api_app/helpers/custom_route.dart';
import 'package:flutter/material.dart';

const apiAccountUrl = 'https://nixlab-blog-api.herokuapp.com/account';
const apiBlogUrl = 'https://nixlab-blog-api.herokuapp.com';

final lightTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xFFFAFAFA),
  primarySwatch: Colors.deepPurple,
  accentColor: Colors.deepPurple,
  cardColor: Color(0xFFF0F0F0),
  bottomAppBarColor: Color(0xFFF0F0F0),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Color(0xFFF0F0F0),
    modalBackgroundColor: Color(0xFFF0F0F0),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CustomPageTransitionBuilder(),
      TargetPlatform.iOS: CustomPageTransitionBuilder(),
    },
  ),
  brightness: Brightness.light,
);

final darkTheme = ThemeData(
  scaffoldBackgroundColor: darkColor,
  primarySwatch: lightColor,
  accentColor: lightColor,
  cardColor: Color(0xFF212121),
  bottomAppBarColor: Color(0xFF212121),
  iconTheme: IconThemeData(color: Colors.white),
  buttonTheme: ButtonThemeData(
      buttonColor: Colors.white,
      focusColor: Colors.white,
      disabledColor: Colors.grey),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Color(0xFF212121),
    modalBackgroundColor: Color(0xFF212121),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CustomPageTransitionBuilder(),
      TargetPlatform.iOS: CustomPageTransitionBuilder(),
    },
  ),
  brightness: Brightness.dark,
);

Map<int, Color> dark = {
  50: Color.fromRGBO(18, 18, 18, .1),
  100: Color.fromRGBO(18, 18, 18, .2),
  200: Color.fromRGBO(18, 18, 18, .3),
  300: Color.fromRGBO(18, 18, 18, .4),
  400: Color.fromRGBO(18, 18, 18, .5),
  500: Color.fromRGBO(18, 18, 18, .6),
  600: Color.fromRGBO(18, 18, 18, .7),
  700: Color.fromRGBO(18, 18, 18, .8),
  800: Color.fromRGBO(18, 18, 18, .9),
  900: Color.fromRGBO(18, 18, 18, 1),
};

MaterialColor darkColor = MaterialColor(0xFF121212, dark);

Map<int, Color> light = {
  50: Color.fromRGBO(255, 255, 255, .1),
  100: Color.fromRGBO(255, 255, 255, .2),
  200: Color.fromRGBO(255, 255, 255, .3),
  300: Color.fromRGBO(255, 255, 255, .4),
  400: Color.fromRGBO(255, 255, 255, .5),
  500: Color.fromRGBO(255, 255, 255, .6),
  600: Color.fromRGBO(255, 255, 255, .7),
  700: Color.fromRGBO(255, 255, 255, .8),
  800: Color.fromRGBO(255, 255, 255, .9),
  900: Color.fromRGBO(255, 255, 255, 1),
};

MaterialColor lightColor = MaterialColor(0xFFFFFFFF, light);
