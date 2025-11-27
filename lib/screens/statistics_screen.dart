import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
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
              '${rod.toY.round()}m',
              const TextStyle(
                color: Color.fromARGB(255, 255, 164, 118),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            );
          },
        ),
      );

  Widget getTitles(BuildContext context, double value, TitleMeta meta) {
    final style = TextStyle(
      color: DriblaColors.orange,
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
    final locale = Localizations.localeOf(context).toLanguageTag();
    final isAuthExpired = ref.watch(isAuthExpiredProvider);
    final auth = ref.watch(authNotifierProvider);

    final gamesPlayed = useState<int>(0);
    final latestGame = useState<String>("");
    final timeSpent = useState<String>("");
    String? username = auth.value?.accessToken.preferred_username ?? "";

    final DateFormat localDateFormat = DateFormat(
      locale == 'fi' ? 'dd.MM.yyyy' : 'MM/dd/yyyy',
    );

    // Track the currently displayed week (Monday)
    final currentWeekStart = useState<DateTime>(
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
    );

    // Calculate week number for currentWeekStart
    int getWeekNumber(DateTime date) {
      // ISO 8601 week number calculation
      final firstThursday = date.subtract(Duration(days: date.weekday - 4));
      final firstDayOfYear = DateTime(date.year, 1, 1);
      final daysOffset = (firstThursday.difference(firstDayOfYear).inDays);
      return ((daysOffset) / 7).floor() + 1;
    }

    final mondayDuration = useState<double>(0);
    final tuesdayDuration = useState<double>(0);
    final wednesdayDuration = useState<double>(0);
    final thursdayDuration = useState<double>(0);
    final fridayDuration = useState<double>(0);
    final saturdayDuration = useState<double>(0);
    final sundayDuration = useState<double>(0);

    final allTimeWormGameHighscore = useState<int>(0);

    // snake game highscores
    final firstScore = useState<int>(0);
    final firstScoreWeekday = useState<String>("");
    final firstScoreDisplay = useState<String>("");
    final secondScore = useState<int>(0);
    final secondScoreWeekday = useState<String>("");
    final secondScoreDisplay = useState<String>("");
    final thirdScore = useState<int>(0);
    final thirdScoreWeekday = useState<String>("");
    final thirdScoreDisplay = useState<String>("");
    final fourthScore = useState<int>(0);
    final fourthScoreWeekday = useState<String>("");
    final fourthScoreDisplay = useState<String>("");
    final fifthScore = useState<int>(0);
    final fifthScoreWeekday = useState<String>("");
    final fifthScoreDisplay = useState<String>("");
    final sixthScore = useState<int>(0);
    final sixthScoreWeekday = useState<String>("");
    final sixthScoreDisplay = useState<String>("");
    final seventhScore = useState<int>(0);
    final seventhScoreWeekday = useState<String>("");
    final seventhScoreDisplay = useState<String>("");
    final eighthScore = useState<int>(0);
    final eighthScoreWeekday = useState<String>("");
    final eighthScoreDisplay = useState<String>("");
    final ninthScore = useState<int>(0);
    final ninthScoreWeekday = useState<String>("");
    final ninthScoreDisplay = useState<String>("");
    final tenthScore = useState<int>(0);
    final tenthScoreWeekday = useState<String>("");
    final tenthScoreDisplay = useState<String>("");

    final snakeHighscoreDate = useState<String>("");

    void resetScores() {
      firstScore.value = 0;
      firstScoreWeekday.value = "";
      firstScoreDisplay.value = loc.noScoresThisWeek;
      secondScore.value = 0;
      secondScoreWeekday.value = "";
      secondScoreDisplay.value = "";
      thirdScore.value = 0;
      thirdScoreWeekday.value = "";
      thirdScoreDisplay.value = "";
      fourthScore.value = 0;
      fourthScoreWeekday.value = "";
      fourthScoreDisplay.value = "";
      fifthScore.value = 0;
      fifthScoreWeekday.value = "";
      fifthScoreDisplay.value = "";
      sixthScore.value = 0;
      sixthScoreWeekday.value = "";
      sixthScoreDisplay.value = "";
      seventhScore.value = 0;
      seventhScoreWeekday.value = "";
      seventhScoreDisplay.value = "";
      eighthScore.value = 0;
      eighthScoreWeekday.value = "";
      eighthScoreDisplay.value = "";
      ninthScore.value = 0;
      ninthScoreWeekday.value = "";
      ninthScoreDisplay.value = "";
      tenthScore.value = 0;
      tenthScoreWeekday.value = "";
      tenthScoreDisplay.value = "";
    }

    useEffect(() {
      Future<void> fetchProfile() async {
        if (isAuthExpired) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
        }
        // Could be optimized to fetch things in one call
        if (auth.hasValue && auth.value != null) {
          final userProfileId = auth.value?.accessToken.sub;
          if (!context.mounted) return;
          final gameSessions = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificWeekGameSessionsForUser(
                  userProfileId!, currentWeekStart.value);
          if (!context.mounted) return;
          final latestSession = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificWeekLatestGameSessionForUser(
                  userProfileId!, currentWeekStart.value);
          if (!context.mounted) return;
          final weeklyGameSessionSummary = await ref
              .read(authNotifierProvider.notifier)
              .getSpecificWeekGameSessionsSummaryForUser(
                  userProfileId, currentWeekStart.value);

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
          // get all-time Worm game highscore
          if (!context.mounted) return;
          final latestWormGameHighscoreSession = await ref
              .read(authNotifierProvider.notifier)
              .getAllTimeWormGameHighscoreForUser(userProfileId);
          if (!context.mounted) return;
          resetScores();
          if (!context.mounted) return;
          final weeklySnakeGameSessions = await ref
              .read(authNotifierProvider.notifier)
              .getWeeklySnakeGameSessionsForUser(
                  userProfileId, currentWeekStart.value);

          if (!context.mounted) return;
          for (int i = 0; i < weeklySnakeGameSessions.length; i++) {
            switch (i) {
              case 0:
                firstScore.value = weeklySnakeGameSessions[i].score ?? 0;
                firstScoreWeekday.value = localDateFormat
                    .format(weeklySnakeGameSessions[i].createdAt!);
                firstScoreDisplay.value =
                    '${firstScore.value} ${loc.pointsStat}';
                break;
              case 1:
                secondScore.value = weeklySnakeGameSessions[i].score ?? 0;
                secondScoreWeekday.value = localDateFormat
                    .format(weeklySnakeGameSessions[i].createdAt!);
                secondScoreDisplay.value =
                    '${secondScore.value} ${loc.pointsStat}';
                break;
              case 2:
                thirdScore.value = weeklySnakeGameSessions[i].score ?? 0;
                thirdScoreWeekday.value = localDateFormat
                    .format(weeklySnakeGameSessions[i].createdAt!);
                thirdScoreDisplay.value =
                    '${thirdScore.value} ${loc.pointsStat}';
                break;
              case 3:
                fourthScore.value = weeklySnakeGameSessions[i].score ?? 0;
                fourthScoreWeekday.value = localDateFormat
                    .format(weeklySnakeGameSessions[i].createdAt!);
                fourthScoreDisplay.value =
                    '${fourthScore.value} ${loc.pointsStat}';
                break;
              case 4:
                fifthScore.value = weeklySnakeGameSessions[i].score ?? 0;
                fifthScoreWeekday.value = localDateFormat
                    .format(weeklySnakeGameSessions[i].createdAt!);
                fifthScoreDisplay.value =
                    '${fifthScore.value} ${loc.pointsStat}';
                break;
              case 5:
                sixthScore.value = weeklySnakeGameSessions[i].score ?? 0;
                sixthScoreWeekday.value = localDateFormat
                    .format(weeklySnakeGameSessions[i].createdAt!);
                sixthScoreDisplay.value =
                    '${sixthScore.value} ${loc.pointsStat}';
                break;
              case 6:
                seventhScore.value = weeklySnakeGameSessions[i].score ?? 0;
                seventhScoreWeekday.value = localDateFormat
                    .format(weeklySnakeGameSessions[i].createdAt!);
                seventhScoreDisplay.value =
                    '${seventhScore.value} ${loc.pointsStat}';
                break;
              case 7:
                eighthScore.value = weeklySnakeGameSessions[i].score ?? 0;
                eighthScoreWeekday.value = localDateFormat
                    .format(weeklySnakeGameSessions[i].createdAt!);
                eighthScoreDisplay.value =
                    '${eighthScore.value} ${loc.pointsStat}';
                break;
              case 8:
                ninthScore.value = weeklySnakeGameSessions[i].score ?? 0;
                ninthScoreWeekday.value = localDateFormat
                    .format(weeklySnakeGameSessions[i].createdAt!);
                ninthScoreDisplay.value =
                    '${ninthScore.value} ${loc.pointsStat}';
                break;
              case 9:
                tenthScore.value = weeklySnakeGameSessions[i].score ?? 0;
                tenthScoreWeekday.value = localDateFormat
                    .format(weeklySnakeGameSessions[i].createdAt!);
                tenthScoreDisplay.value =
                    '${tenthScore.value} ${loc.pointsStat}';
                break;
              default:
            }
          }
          if (!context.mounted) return;

          // Set values after fetch is complete
          // Total games played in week
          gamesPlayed.value = gameSessions.length;
          // Last game played
          if (latestSession != null) {
            switch (latestSession.game) {
              case 'game_snake':
                latestGame.value = loc.snake;
                break;
              case 'game_tengame':
                latestGame.value = loc.tengame;
                break;
              case 'game_tengame_multiplayer':
                latestGame.value = loc.tengameMultiplayer;
                break;
              case 'game_tenturns':
                latestGame.value = loc.tenturns;
                break;
              case 'game_pick_berries':
                latestGame.value = loc.pickBerries;
                break;
              case 'game_envelope':
                latestGame.value = loc.envelope;
                break;
              case 'game_zigzag':
                latestGame.value = loc.zigzag;
                break;
              case 'game_star_game':
                latestGame.value = loc.starGameText;
                break;
              case 'game_memory_game':
                latestGame.value = loc.memoryGame;
                break;
              case 'game_bluefrog':
                latestGame.value = loc.bluefrogGameText;
                break;
              case 'game_follow_the_rabbit':
                latestGame.value = loc.followTheRabbitGameText;
                break;
              default:
                latestGame.value = latestSession.game ?? "";
            }
          }
          // set weekly time spent
          int time = weeklyGameSessionSummary?.totalDuration ?? 0;
          int hours = time ~/ 3600;
          int minutes = (time % 3600) ~/ 60;
          int seconds = time % 60;
          timeSpent.value =
              "${hours}${loc.hoursCounter} ${minutes}m ${seconds}s";
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
          // all time worm game highscore
          if (latestWormGameHighscoreSession != null) {
            allTimeWormGameHighscore.value =
                latestWormGameHighscoreSession.score ?? 0;
            snakeHighscoreDate.value = localDateFormat
                .format(latestWormGameHighscoreSession.createdAt!);
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
              padding: EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.statistics,
                          style: theme.textTheme.headlineMedium),
                      Text(username, style: theme.textTheme.bodyMedium),
                      SizedBox(height: 2.h),
                      // Week navigation row
                      Container(
                          height: 10.h,
                          width: double.infinity,
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 9.w,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back_ios),
                                      color: DriblaColors.orange,
                                      onPressed: () {
                                        currentWeekStart.value =
                                            currentWeekStart.value.subtract(
                                                const Duration(days: 7));
                                      },
                                    )),
                                SizedBox(width: 5.w),
                                SizedBox(
                                    width: 54.w,
                                    child: Column(children: [
                                      Text(
                                        '${loc.week} ${getWeekNumber(currentWeekStart.value)}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.sp),
                                      ),
                                      Text(
                                        "${localDateFormat.format(currentWeekStart.value)} - ${localDateFormat.format(currentWeekStart.value.add(const Duration(days: 6)))}",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.sp),
                                      )
                                    ])),
                                SizedBox(width: 5.w),
                                SizedBox(
                                    width: 9.w,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      color: DriblaColors.orange,
                                      onPressed: () {
                                        currentWeekStart.value =
                                            currentWeekStart.value
                                                .add(const Duration(days: 7));
                                      },
                                    )),
                              ],
                            )
                          ])),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(16.00),
                              child: Column(children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(loc.weeklyActivity,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.sp))),
                                SizedBox(height: 2.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        loc.gamesPlayed,
                                        style: TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.none,
                                          fontFamily: "Urbanist",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0.sp,
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Text(
                                        gamesPlayed.value.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.none,
                                          fontFamily: "Urbanist",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0.sp,
                                        ),
                                        textAlign: TextAlign.right,
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
                                        style: TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.none,
                                          fontFamily: "Urbanist",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0.sp,
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Text(
                                        latestGame.value,
                                        style: TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.none,
                                          fontFamily: "Urbanist",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0.sp,
                                        ),
                                        textAlign: TextAlign.right,
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
                                        style: TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.none,
                                          fontFamily: "Urbanist",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0.sp,
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Text(
                                        timeSpent.value,
                                        style: TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.none,
                                          fontFamily: "Urbanist",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0.sp,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ]))),
                      SizedBox(height: 2.h),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(16.00),
                              child: Column(children: [
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
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            allTimeWormGameHighscore.value
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              decoration: TextDecoration.none,
                                              fontFamily: "Urbanist",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.0.sp,
                                            ),
                                            textAlign: TextAlign.right,
                                          )),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        loc.highscoreDate,
                                        style: TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.none,
                                          fontFamily: "Urbanist",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0.sp,
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            snakeHighscoreDate.value,
                                            style: TextStyle(
                                              color: Colors.white,
                                              decoration: TextDecoration.none,
                                              fontFamily: "Urbanist",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.0.sp,
                                            ),
                                            textAlign: TextAlign.right,
                                          )),
                                      flex: 1,
                                    ),
                                  ],
                                )
                              ]))),
                      SizedBox(height: 3.h),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(children: [
                            Padding(
                                padding: EdgeInsets.all(16.00),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        loc.weeklyPlaytimeMinutes,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                      flex: 1,
                                    )
                                  ],
                                )),
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
                          ])),
                      SizedBox(height: 2.h),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(16.00),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                    SizedBox(height: 2.h),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              firstScore.value != 0
                                                  ? firstScoreDisplay.value
                                                  : loc.noScoresThisWeek,
                                              style: theme.textTheme.bodySmall,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              firstScoreWeekday.value,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
                                                fontFamily: "Urbanist",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0.sp,
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              secondScore.value != 0
                                                  ? secondScoreDisplay.value
                                                  : '',
                                              style: theme.textTheme.bodySmall,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              secondScoreWeekday.value,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
                                                fontFamily: "Urbanist",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0.sp,
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              thirdScore.value != 0
                                                  ? thirdScoreDisplay.value
                                                  : '',
                                              style: theme.textTheme.bodySmall,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              thirdScoreWeekday.value,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
                                                fontFamily: "Urbanist",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0.sp,
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              fourthScore.value != 0
                                                  ? fourthScoreDisplay.value
                                                  : '',
                                              style: theme.textTheme.bodySmall,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              fourthScoreWeekday.value,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
                                                fontFamily: "Urbanist",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0.sp,
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              fifthScore.value != 0
                                                  ? fifthScoreDisplay.value
                                                  : '',
                                              style: theme.textTheme.bodySmall,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              fifthScoreWeekday.value,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
                                                fontFamily: "Urbanist",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0.sp,
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              sixthScore.value != 0
                                                  ? sixthScoreDisplay.value
                                                  : '',
                                              style: theme.textTheme.bodySmall,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              sixthScoreWeekday.value,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
                                                fontFamily: "Urbanist",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0.sp,
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              seventhScore.value != 0
                                                  ? seventhScoreDisplay.value
                                                  : '',
                                              style: theme.textTheme.bodySmall,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              seventhScoreWeekday.value,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
                                                fontFamily: "Urbanist",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0.sp,
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              eighthScore.value != 0
                                                  ? eighthScoreDisplay.value
                                                  : '',
                                              style: theme.textTheme.bodySmall,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              eighthScoreWeekday.value,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
                                                fontFamily: "Urbanist",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0.sp,
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              ninthScore.value != 0
                                                  ? ninthScoreDisplay.value
                                                  : '',
                                              style: theme.textTheme.bodySmall,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              ninthScoreWeekday.value,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
                                                fontFamily: "Urbanist",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0.sp,
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              tenthScore.value != 0
                                                  ? tenthScoreDisplay.value
                                                  : '',
                                              style: theme.textTheme.bodySmall,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              tenthScoreWeekday.value,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
                                                fontFamily: "Urbanist",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0.sp,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ]))),
                      SizedBox(height: 50.h),
                    ]),
              ),
            ),
          ),
          const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
        ],
      ),
    );
  }
}
