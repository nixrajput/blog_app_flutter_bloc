import 'package:flutter/material.dart';

class CustomDateChooser extends StatelessWidget {
  const CustomDateChooser({
    @required this.labelText,
    @required this.valueText,
    @required this.onPressed,
  });

  final String labelText;
  final String valueText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Expanded(
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                valueText,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.calendar_today_outlined,
              size: 28.0,
              color: Theme.of(context).accentColor,
            ),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
