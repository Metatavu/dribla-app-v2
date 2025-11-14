import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/services/api.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:sizer/sizer.dart";
import "package:url_launcher/url_launcher_string.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final authAsync = ref.watch(authNotifierProvider);

    // navigate back to app on successful login
    useEffect(() {
      if (authAsync.hasValue && authAsync.value != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/new_user');
        });
      }
      return null;
    }, [authAsync.value]);

    return Scaffold(
        appBar: const ConnectionStatusAppBar(shouldShowMenu: false),
        extendBodyBehindAppBar: false,
        body: SafeArea(
            child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/dribla_new_background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5.h),
                    Center(
                        child: Text(loc.login,
                            style: theme.textTheme.headlineMedium)),
                    SizedBox(height: 2.h),
                    Center(
                        child: Text(loc.loginInfo,
                            style: theme.textTheme.bodySmall)),
                    SizedBox(height: 2.h),
                    SizedBox(
                      height: 3.h,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authAsync.isLoading
                            ? null
                            : () async {
                                await ref
                                    .read(authNotifierProvider.notifier)
                                    .login();
                              },
                        child: authAsync.isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                loc.login,
                                style: theme.textTheme.bodyMedium,
                              ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    if (authAsync.hasError)
                      Text(loc.loginError, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 50.h),
                  ],
                ))),
          ),
        ])));
  }
}
