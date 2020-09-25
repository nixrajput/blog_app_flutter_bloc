import 'package:flutter/material.dart';

class CustomBodyCard extends StatelessWidget {
  final Widget child;

  const CustomBodyCard({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 2.0),
            blurRadius: 10.0,
            color: Colors.black.withOpacity(0.25),
          )
        ],
      ),
      child: child,
    );
  }
}
