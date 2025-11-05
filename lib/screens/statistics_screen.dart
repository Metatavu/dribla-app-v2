import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_swiper_plus/flutter_swiper_plus.dart";
import "package:sizer/sizer.dart";
import "package:fl_chart/fl_chart.dart";

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends HookConsumerWidget {
  const StatisticsScreen({super.key});

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: DriblaColors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(BuildContext context, double value, TitleMeta meta) {
    final style = TextStyle(
      color: DriblaColors.greenbg,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    final loc = AppLocalizations.of(context)!;
    String text = switch (value.toInt()) {
      0 => loc.monday,
      1 => loc.tuesday,
      2 => loc.wednesday,
      3 => loc.thursday,
      4 => loc.friday,
      5 => loc.saturday,
      6 => loc.sunday,
      _ => '',
    };
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData titlesData(BuildContext context) => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) => getTitles(context, value, meta),
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          DriblaColors.newBtnColor,
          DriblaColors.white,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isAuthExpired = ref.watch(isAuthExpiredProvider);
    final auth = ref.watch(authNotifierProvider);

    final gamesPlayed = useState<int>(0);
    final latestGame = useState<String>("");
    final timeSpent = useState<String>("");
    final totalScore = useState<String>("");
    String? username = auth.value?.accessToken.preferred_username ?? "";

    // Track the currently displayed week (Monday)
    final currentWeekStart = useState<DateTime>(
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
    );

    final mondayDuration = useState<double>(0);
    final tuesdayDuration = useState<double>(0);
    final wednesdayDuration = useState<double>(0);
    final thursdayDuration = useState<double>(0);
    final fridayDuration = useState<double>(0);
    final saturdayDuration = useState<double>(0);
    final sundayDuration = useState<double>(0);

    // highscores for each day
    final mondayScore = useState<double>(0);
    final tuesdayScore = useState<double>(0);
    final wednesdayScore = useState<double>(0);
    final thursdayScore = useState<double>(0);
    final fridayScore = useState<double>(0);
    final saturdayScore = useState<double>(0);
    final sundayScore = useState<double>(0);

    final allTimeWormGameHighscore = useState<int>(0);

    useEffect(() {
      Future<void> fetchProfile() async {
        if (isAuthExpired) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
        }
        if (auth.hasValue && auth.value != null) {
          final userProfileId = auth.value?.accessToken.sub;
          if (!context.mounted) return;
          final gameSessions = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificWeekGameSessionsForUser(
                  userProfileId!, currentWeekStart.value);
          gamesPlayed.value = gameSessions.length;
          if (!context.mounted) return;
          final latestSession = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificWeekLatestGameSessionForUser(
                  userProfileId!, currentWeekStart.value);
          if (latestSession != null) {
            latestGame.value = latestSession.game ?? "";
          }
          if (!context.mounted) return;
          final weeklyGameSessionSummary = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificWeekGameSessionsSummaryForUser(
                  userProfileId, currentWeekStart.value);
          int time = weeklyGameSessionSummary?.totalDuration ?? 0;
          int hours = time ~/ 3600;
          int minutes = (time % 3600) ~/ 60;
          int seconds = time % 60;
          timeSpent.value =
              "${hours}${loc.hoursCounter} ${minutes}m ${seconds}s";
          int score = weeklyGameSessionSummary?.totalScore ?? 0;
          totalScore.value = score.toString();

          // Use currentWeekStart for week navigation
          DateTime monday = currentWeekStart.value;
          DateTime tuesday = monday.add(const Duration(days: 1));
          DateTime wednesday = monday.add(const Duration(days: 2));
          DateTime thursday = monday.add(const Duration(days: 3));
          DateTime friday = monday.add(const Duration(days: 4));
          DateTime saturday = monday.add(const Duration(days: 5));
          DateTime sunday = monday.add(const Duration(days: 6));

          // get game session summaries for each day
          if (!context.mounted) return;
          final mondayGameSessionSummary = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayGameSessionSummaryForUser(userProfileId, monday);
          if (!context.mounted) return;
          final tuesdayGameSessionSummary = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayGameSessionSummaryForUser(userProfileId, tuesday);
          if (!context.mounted) return;
          final wednesdayGameSessionSummary = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayGameSessionSummaryForUser(
                  userProfileId, wednesday);
          if (!context.mounted) return;
          final thursdayGameSessionSummary = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayGameSessionSummaryForUser(userProfileId, thursday);
          if (!context.mounted) return;
          final fridayGameSessionSummary = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayGameSessionSummaryForUser(userProfileId, friday);
          if (!context.mounted) return;
          final saturdayGameSessionSummary = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayGameSessionSummaryForUser(userProfileId, saturday);
          if (!context.mounted) return;
          final sundayGameSessionSummary = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayGameSessionSummaryForUser(userProfileId, sunday);
          // set durations for each day (in minutes)
          mondayDuration.value =
              (mondayGameSessionSummary?.totalDuration ?? 0).toDouble() / 60;
          tuesdayDuration.value =
              (tuesdayGameSessionSummary?.totalDuration ?? 0).toDouble() / 60;
          wednesdayDuration.value =
              (wednesdayGameSessionSummary?.totalDuration ?? 0).toDouble() / 60;
          thursdayDuration.value =
              (thursdayGameSessionSummary?.totalDuration ?? 0).toDouble() / 60;
          fridayDuration.value =
              (fridayGameSessionSummary?.totalDuration ?? 0).toDouble() / 60;
          saturdayDuration.value =
              (saturdayGameSessionSummary?.totalDuration ?? 0).toDouble() / 60;
          sundayDuration.value =
              (sundayGameSessionSummary?.totalDuration ?? 0).toDouble() / 60;
          // get Worm game sessions for each day
          if (!context.mounted) return;
          final mondayWormGameSession = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayWormGameSessionForUser(userProfileId, monday);
          if (!context.mounted) return;
          final tuesdayWormGameSession = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayWormGameSessionForUser(userProfileId, tuesday);
          if (!context.mounted) return;
          final wednesdayWormGameSession = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayWormGameSessionForUser(userProfileId, wednesday);
          if (!context.mounted) return;
          final thursdayWormGameSession = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayWormGameSessionForUser(userProfileId, thursday);
          if (!context.mounted) return;
          final fridayWormGameSession = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayWormGameSessionForUser(userProfileId, friday);
          if (!context.mounted) return;
          final saturdayWormGameSession = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayWormGameSessionForUser(userProfileId, saturday);
          if (!context.mounted) return;
          final sundayWormGameSession = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificDayWormGameSessionForUser(userProfileId, sunday);
          // set highscores for each day
          mondayScore.value = (mondayWormGameSession?.score ?? 0).toDouble();
          tuesdayScore.value = (tuesdayWormGameSession?.score ?? 0).toDouble();
          wednesdayScore.value =
              (wednesdayWormGameSession?.score ?? 0).toDouble();
          thursdayScore.value =
              (thursdayWormGameSession?.score ?? 0).toDouble();
          fridayScore.value = (fridayWormGameSession?.score ?? 0).toDouble();
          saturdayScore.value =
              (saturdayWormGameSession?.score ?? 0).toDouble();
          sundayScore.value = (sundayWormGameSession?.score ?? 0).toDouble();
          // get all-time Worm game highscore
          if (!context.mounted) return;
          final latestWormGameHighscoreSession = await ref
              .read(authNotifierProvider.notifier)
              .getAllTimeWormGameHighscoreForUser(userProfileId);
          if (latestWormGameHighscoreSession != null) {
            allTimeWormGameHighscore.value =
                latestWormGameHighscoreSession.score ?? 0;
          }
        }
      }

      fetchProfile();
      return null;
    }, [
      isAuthExpired,
      currentWeekStart.value,
      gamesPlayed.value,
      latestGame.value,
      timeSpent.value,
    ]);

    List<BarChartGroupData> barGroups() {
      return [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: mondayDuration.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: tuesdayDuration.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: wednesdayDuration.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: thursdayDuration.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: fridayDuration.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: saturdayDuration.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: sundayDuration.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        )
      ];
    }

    List<BarChartGroupData> barGroupsWormGame() {
      return [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: mondayScore.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: tuesdayScore.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: wednesdayScore.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: thursdayScore.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: fridayScore.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: saturdayScore.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: sundayScore.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        )
      ];
    }

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
                    Text(username, style: theme.textTheme.bodyMedium),
                    SizedBox(height: 2.h),
                    // Week navigation row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: DriblaColors.orange,
                          onPressed: () {
                            currentWeekStart.value = currentWeekStart.value
                                .subtract(const Duration(days: 7));
                          },
                        ),
                        Text(
                          "${DateFormat('dd.MM.yyyy').format(currentWeekStart.value)} - ${DateFormat('dd.MM.yyyy').format(currentWeekStart.value.add(const Duration(days: 6)))}",
                          style: theme.textTheme.bodyMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          color: DriblaColors.orange,
                          onPressed: () {
                            currentWeekStart.value = currentWeekStart.value
                                .add(const Duration(days: 7));
                          },
                        ),
                      ],
                    ),
                    Text(loc.weeklyActivity, style: theme.textTheme.bodyMedium),
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
                            gamesPlayed.value.toString(),
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            loc.recentGame,
                            style: theme.textTheme.bodySmall,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            latestGame.value,
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            loc.totalTimeSpent,
                            style: theme.textTheme.bodySmall,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            timeSpent.value,
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            loc.weeklyPlaytimeMinutes,
                            style: theme.textTheme.bodySmall,
                          ),
                          flex: 1,
                        )
                      ],
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                        width: 300,
                        height: 150,
                        child: BarChart(
                          BarChartData(
                            barTouchData: barTouchData,
                            titlesData: titlesData(context),
                            borderData: borderData,
                            barGroups: barGroups(),
                            gridData: const FlGridData(show: false),
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 20,
                          ),
                        )),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            loc.wormGameBestHighscore,
                            style: theme.textTheme.bodySmall,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            allTimeWormGameHighscore.value.toString(),
                            style: theme.textTheme.bodySmall,
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            loc.wormGameWeeklyHighscores,
                            style: theme.textTheme.bodySmall,
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                        width: 300,
                        height: 150,
                        child: BarChart(
                          BarChartData(
                            barTouchData: barTouchData,
                            titlesData: titlesData(context),
                            borderData: borderData,
                            barGroups: barGroupsWormGame(),
                            gridData: const FlGridData(show: false),
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 20,
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
