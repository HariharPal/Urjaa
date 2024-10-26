import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar/core/theme/app_pallete.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Palette.smokeWhite,
          ),
        ),
        backgroundColor: Palette.secondaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(''),
          ),
        ),
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(''),
                    child: Icon(
                      CupertinoIcons.profile_circled,
                      size: 100,
                    ), // Replace with your image URL
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Rohan Singh',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'rohanSingh123@gmail.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.edit),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(10)),
                          onPressed: () {
                            // Add your action here
                          },
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance),
                        TextButton(
                          style: TextButton.styleFrom(),
                          onPressed: () {},
                          child: const Text(
                            'Transactions',
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.settings),
                        TextButton(
                          style: TextButton.styleFrom(),
                          onPressed: () {},
                          child: const Text(
                            'Settings',
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
