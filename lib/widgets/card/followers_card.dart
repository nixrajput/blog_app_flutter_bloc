import 'package:flutter/material.dart';

class FollowersCard extends StatelessWidget {
  final String followers;
  final String following;

  const FollowersCard({
    @required this.followers,
    @required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        bottom: 10.0,
        left: 10.0,
        right: 10.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Text(
                followers,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                "Followers",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                  fontFamily: "Alata",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                following,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                "Following",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                  fontFamily: "Alata",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
