import 'package:flutter/material.dart';
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/assets.dart";
import "package:sizer/sizer.dart";

class AppHeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;

  const AppHeaderAppBar({
    Key? key,
    this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: onMenuPressed ??
            () {
              Scaffold.of(context).openDrawer();
            },
      ),
      title: Image(
        image: const AssetImage(Assets.logoAsset),
        width: 30.w,
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
