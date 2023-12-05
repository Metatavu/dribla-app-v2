import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:dribla_app_v2/permission_utils.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_svg/svg.dart";
import "package:permission_handler/permission_handler.dart";

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with WidgetsBindingObserver {
  Map<Permission, PermissionStatus>? _permissionStatuses;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final permissionStatuses = await askAndCheckPermissionStatuses();
    setState(() => _permissionStatuses = permissionStatuses);
  }

  Widget _renderContent(
    BuildContext context,
    AppLocalizations localized,
    ThemeData theme,
  ) {
    if (_permissionStatuses == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final allPermissionsGranted = _permissionStatuses!.values.every(
      (permission) => permission.isGranted,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(Assets.logoAsset),
              const SizedBox(height: 48),
              if (!allPermissionsGranted)
                Text(
                  localized.youNeedToEnableBluetoothPermissions,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                )
            ],
          ),
        ),
        if (allPermissionsGranted)
          StyledElevatedButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ChooseGameScreen()),
            ),
            style: theme.elevatedButtonTheme.style?.copyWith(
              fixedSize: const MaterialStatePropertyAll(Size.fromHeight(65)),
            ),
            child: Text(localized.start, style: theme.textTheme.headlineMedium),
          )
        else
          StyledElevatedButton(
            onPressed: openAppSettings,
            style: theme.elevatedButtonTheme.style?.copyWith(
              fixedSize: const MaterialStatePropertyAll(Size.fromHeight(65.0)),
            ),
            child: Text(
              localized.settings,
              style: theme.textTheme.headlineMedium,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage(Assets.chooseGameBackgroundImageAsset),
            fit: BoxFit.fill,
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: _renderContent(
          context,
          AppLocalizations.of(context)!,
          Theme.of(context),
        ),
      ),
    );
  }
}
