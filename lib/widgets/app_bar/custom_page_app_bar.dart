import 'package:flutter/material.dart';

class CustomPageAppBar extends StatelessWidget {
  final String title;
  final Widget actions;
  final IconData mainIcon;
  final Function onPressed;

  const CustomPageAppBar({
    this.mainIcon,
    this.onPressed,
    @required this.title,
    this.actions,
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
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (mainIcon != null)
                      GestureDetector(
                        onTap: onPressed,
                        child: Icon(
                          mainIcon,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    if (mainIcon != null) SizedBox(width: 8.0),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Raleway",
                          color: Theme.of(context).accentColor),
                    )
                  ],
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
