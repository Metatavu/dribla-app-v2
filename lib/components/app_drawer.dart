import "package:dribla_app_v2/assets.dart";
import 'package:flutter/material.dart';
import "package:sizer/sizer.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
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
            title: Text(loc.mainPage),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/main');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(loc.profile),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(loc.login),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_2_outlined),
            title: Text(loc.editAvatar),
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
          ListTile(
            leading: Icon(Icons.perm_device_info),
            title: Text('Temp Sign In'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/signin');
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
