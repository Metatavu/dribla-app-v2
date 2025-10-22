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
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: const Border(top: BorderSide(color: Colors.white24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // TODO replace routes with actual ones
          // TODO orange highlight for selected or active button
          children: [
            _FooterButton(
              icon: Icons.person_pin,
              label: loc.players,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/main');
              },
            ),
            SizedBox(width: 4.w),
            _FooterButton(
              icon: Icons.sports_soccer,
              label: loc.games,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/games');
              },
            ),
            SizedBox(width: 4.w),
            _FooterButton(
              icon: Icons.person,
              label: loc.teams,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _FooterButton({
    required this.icon,
    required this.label,
    required this.onPressed,
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
      ],
    );
  }
}
