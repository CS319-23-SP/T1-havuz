import 'package:first_trial/final_variables.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: 500,
          height: 250,
          decoration: BoxDecoration(color: PoolColors.cardWhite),
        ),
        Positioned(top: -60, left: 25, child: buildProfileImage()),
      ],
    );
  }

  Widget buildProfileImage() => CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage(AssetLocations.userPhoto),
      );
}
