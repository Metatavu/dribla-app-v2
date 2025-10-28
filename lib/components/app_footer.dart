import "package:flutter/material.dart";
import "package:sizer/sizer.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:dribla_app_v2/theme/theme.dart";

class AppFooter extends StatefulWidget {
  const AppFooter({super.key});

  @override
  State<AppFooter> createState() => _AppFooter();
}

class _AppFooter extends State<AppFooter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: const Border(top: BorderSide(color: Colors.white24)),
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _FooterButton(
              icon: Icons.person_pin,
              label: loc.players,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/main');
              },
              isActive: currentRoute == '/main',
            ),
            SizedBox(width: 4.w),
            _FooterButton(
              icon: Icons.sports_soccer,
              label: loc.games,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/games');
              },
              isActive: currentRoute == '/games',
            ),
            SizedBox(width: 4.w),
            _FooterButton(
              icon: Icons.bar_chart,
              label: loc.statistics,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/statistics');
              },
              isActive: currentRoute == '/statistics',
            ),
          ],
        ),
        SizedBox(height: 5.h),
      ]),
    );
  }
}

class _FooterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;

  const _FooterButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isActive = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white, size: 28),
          onPressed: onPressed,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.white),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 15.w,
            color: DriblaColors.newBtnColor,
          ),
      ],
    );
  }
}
