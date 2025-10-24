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
            child: Row(children: [
              Image.asset('assets/dribla_logo.png', width: 40.w),
            ]),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(loc.mainPage),
            trailing: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/main');
                }),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/main');
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.person),
          //   title: Text(loc.profile),
          //   trailing: IconButton(
          //       icon: Icon(Icons.arrow_forward),
          //       onPressed: () {
          //         Navigator.of(context).pushReplacementNamed('/profile');
          //       }),
          //   onTap: () {
          //     Navigator.of(context).pushReplacementNamed('/profile');
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.person_2_outlined),
            title: Text(loc.editAvatar),
            trailing: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/character');
                }),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/character');
            },
          ),
          ListTile(
            leading: Icon(Icons.subscriptions),
            title: Text(loc.subscription),
            trailing: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/payments');
                }),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/payments');
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text(loc.statistics),
            trailing: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/statistics');
                }),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/statistics');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(loc.profile),
            trailing: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/profile');
                }),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/profile');
            },
          ),
        ],
      ),
    );
  }
}
