import 'package:flutter/material.dart';

class CustomLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "BlogAPI",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w900,
              fontSize: 32.0,
              fontFamily: "Kaushan Script",
            ),
          ),
          Text(
            "A Blogging World",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontFamily: "Kaushan Script",
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
