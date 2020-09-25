import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  const SettingButton({this.title, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey,
            ),
            SizedBox(width: 20.0),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Alata",
                  color: Theme.of(context).accentColor),
            ),
          ],
        ),
      ),
    );
  }
}
