import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:muonroi/core/Authorization/enums/key.dart';
import 'package:muonroi/core/services/api_route.dart';
import 'package:muonroi/features/accounts/data/models/model.account.token.dart';
import 'package:muonroi/shared/settings/setting.main.dart';

Future<Dio> endPoint() async {
  String token = dotenv.env['ENV_TOKEN']!;
  String? refreshTokenStr;
  Dio dio = Dio();
  dio.options.baseUrl = ApiNetwork.baseApi;
  dio.options.responseType = ResponseType.plain;
  //dio.interceptors.add(LogInterceptor());
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (request, handler) {
        request.headers['Authorization'] = 'Bearer $token';
        return handler.next(request);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          token = userBox.get(KeyToken.accessToken.name) ??
              dotenv.env['ENV_TOKEN']!;
          refreshTokenStr = userBox.get(KeyToken.refreshToken.name);
          try {
            await dio
                .post(ApiNetwork.renewToken,
                    data: jsonEncode({"refreshToken": refreshTokenStr}))
                .then((value) async {
              if (value.statusCode == 200) {
                var newToken = tokenModelFromJson(value.data.toString());
                userBox.put(KeyToken.accessToken.name, newToken.result);
                userBox.put(KeyToken.refreshToken.name, refreshTokenStr!);
                token = newToken.result;
                e.requestOptions.headers["Authorization"] =
                    "Bearer ${newToken.result}";
                final opts = Options(
                    method: e.requestOptions.method,
                    headers: e.requestOptions.headers);
                final cloneReq = await dio.request(e.requestOptions.path,
                    options: opts, data: e.requestOptions.data);
                return handler.resolve(cloneReq);
              }
            });
          } catch (e) {
            return;
          }
        }
      },
    ),
  );
  return dio;
}
