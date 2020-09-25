import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = 'splash-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "BlogAPI",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w900,
                fontSize: 40.0,
                fontFamily: "Kaushan Script",
              ),
            ),
            Text(
              "A Blogging World",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: "Kaushan Script",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
