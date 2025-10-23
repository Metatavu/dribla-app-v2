import "package:dio/dio.dart";
import "package:dribla_api/dribla_api.dart";
import "package:dribla_app_v2/app/env.gen.dart";

late final DriblaApi driblaApi;

void initDriblaApi() {
  driblaApi = DriblaApi(basePathOverride: Env.apiBaseUrl);
  driblaApi.dio.options.connectTimeout = const Duration(seconds: 60);
  driblaApi.dio.options.receiveTimeout = const Duration(seconds: 3600);
}
