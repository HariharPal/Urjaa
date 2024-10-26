import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar/core/theme/app_pallete.dart';
import 'package:solar/features/home/view/pages/analyticsScreen/analytic_page.dart';
import 'package:solar/features/home/view/pages/homeScreen/home_page.dart';
import 'package:solar/features/home/view/pages/leaderboardScreen/leaderboard_page.dart';
import 'package:solar/features/home/view/pages/profileScreen/profile_page.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _selectedPage = 0;

  void _navigate(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const AnalyticPage(),
    const LeaderboardPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(_selectedPage == 0
                ? CupertinoIcons.house_fill
                : CupertinoIcons.house),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedPage == 1
                ? CupertinoIcons.chart_bar_fill
                : CupertinoIcons.chart_bar),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedPage == 2
                ? CupertinoIcons.star_fill
                : CupertinoIcons.star),
            label: "Leaderboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedPage == 3
                ? CupertinoIcons.person_fill
                : CupertinoIcons.person),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedPage,
        selectedItemColor: Palette.primaryColor,
        onTap: _navigate,
      ),
    );
  }
}
