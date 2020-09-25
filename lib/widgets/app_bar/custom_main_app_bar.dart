import 'package:flutter/material.dart';

class CustomMainAppBar extends StatelessWidget {
  final String title;
  final Widget actions;

  CustomMainAppBar({
    @required this.title,
    @required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).bottomAppBarColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Kaushan Script",
                      color: Theme.of(context).accentColor),
                ),
                actions
              ],
            ),
          ),
        ],
      ),
    );
  }
}
