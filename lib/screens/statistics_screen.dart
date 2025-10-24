import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/app_header_appbar.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/components/game_icon.dart";
import "package:dribla_app_v2/components/game_settings_dialog.dart";
import "package:dribla_app_v2/components/styled_dialog.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/character_creation_screen.dart";
import "package:dribla_app_v2/screens/outfit_selection_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_swiper_plus/flutter_swiper_plus.dart";
import "package:sizer/sizer.dart";
import "package:fl_chart/fl_chart.dart";

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

class StatisticsScreen extends HookConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isAuthExpired = ref.watch(isAuthExpiredProvider);

    useEffect(() {
      if (isAuthExpired) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
      return null;
    }, [isAuthExpired]);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: const ConnectionStatusAppBar(),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
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
                    Text(loc.statistics, style: theme.textTheme.headlineMedium),
                    Text('Username2', style: theme.textTheme.bodyMedium),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            loc.gamesPlayed,
                            style: theme.textTheme.bodySmall,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            '9001',
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 300, // or use a responsive value like 30.w
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                                value: 40, title: 'Work', color: Colors.green),
                            PieChartSectionData(
                                value: 30, title: 'Play', color: Colors.blue),
                            PieChartSectionData(
                                value: 30, title: 'Rest', color: Colors.purple),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                        width: 325, // or use a responsive value like 30.w
                        height: 325,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  FlSpot(0, 3),
                                  FlSpot(1, 1),
                                  FlSpot(2, 4),
                                  FlSpot(3, 1.5),
                                ],
                                isCurved: true,
                                color: Colors.amber,
                                barWidth: 4,
                                belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.amber.withOpacity(0.3)),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
        ],
      ),
    );
  }
}
