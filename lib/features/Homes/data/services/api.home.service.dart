import 'package:dio/dio.dart';
import 'package:muonroi/core/services/api_route.dart';
import 'package:muonroi/features/homes/data/models/model.home.banner.dart';
import 'package:muonroi/features/homes/data/models/model.setting.dart';
import 'package:sprintf/sprintf.dart';

class HomeService {
  Future<ModelBannerResponse> getBannerList(int type) async {
    try {
      Dio dio = Dio(BaseOptions(
          baseUrl: ApiNetwork.baseApi, responseType: ResponseType.plain));
      final response = await dio.get(sprintf(ApiNetwork.banners, [type]));
      if (response.statusCode == 200) {
        return modelBannerResponseFromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw Exception("Failed to load banner list");
      }
    }
    throw Exception("Failed to load banner list");
  }

  Future<ModelSettingResponse> getSetting(int type) async {
    try {
      Dio dio = Dio(BaseOptions(
          baseUrl: ApiNetwork.baseApi, responseType: ResponseType.plain));
      final response = await dio.get(sprintf(ApiNetwork.settingByType, [type]));
      if (response.statusCode == 200) {
        return getSettingResponseFromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw Exception("Failed to load setting list");
      }
    }
    throw Exception("Failed to load setting list");
  }
}
