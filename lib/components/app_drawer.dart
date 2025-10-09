import "package:dribla_app_v2/assets.dart";
import 'package:flutter/material.dart';
import "package:sizer/sizer.dart";
import "package:dribla_app_v2/theme/theme.dart";

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Image(
              image: const AssetImage(Assets.logoAsset),
              width: 10.w,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Main Page'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/main');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Sign in'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_2_outlined),
            title: Text('Character'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/character');
            },
          ),
          ListTile(
            leading: Icon(Icons.subscriptions),
            title: Text('Payments'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/payments');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Manage players'),
            onTap: () {
              // Most functionality still work in progress; replace as needed
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
