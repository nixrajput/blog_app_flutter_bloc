import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).accentColor,
      height: 0.0,
      thickness: 0.2,
    );
  }
}
