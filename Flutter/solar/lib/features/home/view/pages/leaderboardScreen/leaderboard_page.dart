import 'package:flutter/material.dart';
import 'package:solar/core/theme/app_pallete.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leaderboard",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 22,
                color: Palette.smokeWhite,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: Palette.secondaryColor,
      ),
    );
  }
}
