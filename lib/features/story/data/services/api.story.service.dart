import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:muonroi/core/Authorization/setting.api.dart';
import 'package:muonroi/core/services/api_route.dart';
import 'package:muonroi/shared/settings/enums/enum.search.story.dart';
import 'package:muonroi/features/story/data/models/model.single.story.dart';
import 'package:muonroi/features/story/data/models/model.stories.story.dart';
import 'package:muonroi/features/story/settings/settings.dart';
import 'package:muonroi/shared/settings/setting.main.dart';
import 'package:sprintf/sprintf.dart';

class StoryService {
  Future<StoriesModel> getStoriesDataList(
      [int pageIndex = 1, int pageSize = 15]) async {
    try {
      pageIndex = pageIndex == 0 ? 1 : pageIndex;
      var baseEndpoint = await endPoint();
      final response = await baseEndpoint.get(
          sprintf(ApiNetwork.getStoriesPaging, ["$pageIndex", "$pageSize"]));
      if (response.statusCode == 200) {
        return storiesFromJson(response.data.toString());
      } else {
        throw Exception("Failed to load story");
      }
    } catch (e) {
      throw Exception("Failed to load story - $e");
    }
  }

  Future<StoriesModel> getStoriesRecommendList(int storyId,
      [int pageIndex = 1, int pageSize = 15]) async {
    try {
      pageIndex = pageIndex == 0 ? 1 : pageIndex;
      var baseEndpoint = await endPoint();
      final response = await baseEndpoint.get(sprintf(
          ApiNetwork.getRecommendStoriesPaging,
          ["$storyId", "$pageIndex", "$pageSize"]));
      if (response.statusCode == 200) {
        return storiesFromJson(response.data.toString());
      } else {
        return StoriesModel(
          errorMessages: [],
          result: Result(
              items: [],
              pagingInfo: PagingInfo(pageSize: 0, page: 0, totalItems: 0)),
          isOk: false,
          statusCode: 400,
        );
      }
    } catch (e) {
      return StoriesModel(
        errorMessages: [],
        result: Result(
            items: [],
            pagingInfo: PagingInfo(pageSize: 0, page: 0, totalItems: 0)),
        isOk: false,
        statusCode: 400,
      );
    }
  }

  Future<SingleStoryModel> getDetailStoryList(int storyId) async {
    try {
      var storyDetail = chapterBox.get("storyDetail-$storyId");
      if (storyDetail == null) {
        var baseEndpoint = await endPoint();
        final response = await baseEndpoint
            .get(sprintf(ApiNetwork.getDetailStory, ["$storyId"]));
        if (response.statusCode == 200) {
          chapterBox.put("storyDetail-$storyId", response.data.toString());
          return singleStoryModelFromJson(response.data.toString());
        }
      }
      return singleStoryModelFromJson(storyDetail!);
    } catch (e) {
      return SingleStoryModel(
        errorMessages: [e],
        result: storySingleDefaultData(),
        isOk: false,
        statusCode: 400,
      );
    }
  }

  Future<bool> voteStory(int storyId, double voteNumber) async {
    try {
      Map<String, dynamic> data = {
        'storyId': '$storyId',
        'voteValue': '$voteNumber'
      };
      var baseEndpoint = await endPoint();
      final response =
          await baseEndpoint.patch(ApiNetwork.voteStory, data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<StoriesModel> searchStory(List<String> keySearch,
      List<SearchType> type, int pageIndex, int pageSize) async {
    try {
      pageIndex = pageIndex == 0 ? 1 : pageIndex;
      var baseEndpoint = await endPoint();
      String url = "";
      String paging = "PageIndex=$pageIndex&PageSize=$pageSize";
      for (int i = 0; i < type.length; i++) {
        switch (type[i]) {
          case SearchType.title:
            url += "SearchByTitle=${keySearch[i]}&";
            break;
          case SearchType.category:
            url += "SearchByCategory=${keySearch[i]}&";
            break;
          case SearchType.tag:
            url += "SearchByTagName=${keySearch[i]}&";
            break;
          case SearchType.chapter:
            url += "SearchByNumberChapter=${keySearch[i]}&";
            break;
        }
      }
      url += paging;
      final response =
          await baseEndpoint.get("${ApiNetwork.baseSearchStory}$url");
      if (response.statusCode == 200) {
        return storiesFromJson(response.data.toString());
      } else {
        return StoriesModel(
          errorMessages: [],
          result: Result(
              items: [],
              pagingInfo: PagingInfo(pageSize: 0, page: 0, totalItems: 0)),
          isOk: false,
          statusCode: 400,
        );
      }
    } catch (e) {
      return StoriesModel(
        errorMessages: [],
        result: Result(
            items: [],
            pagingInfo: PagingInfo(pageSize: 0, page: 0, totalItems: 0)),
        isOk: false,
        statusCode: 400,
      );
    }
  }

  Future<bool> createBookmarkStory(int storyId) async {
    try {
      Map<String, dynamic> data = {'storyId': storyId};
      var baseEndpoint = await endPoint();
      final response =
          await baseEndpoint.post(ApiNetwork.bookmarkStory, data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Failed to bookmark story - $e");
    }
  }

  Future<bool> deleteBookmarkStory(int bookmarkId) async {
    try {
      Map<String, dynamic> data = {'bookmarkId': bookmarkId};
      var baseEndpoint = await endPoint();
      final response =
          await baseEndpoint.delete(ApiNetwork.bookmarkStory, data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Failed to bookmark story - $e");
    }
  }

  Future<bool> createStoryForUser(
      int storyId,
      int type,
      int index,
      int pageIndex,
      int numberChapter,
      double locationChapter,
      int chapterLatestId) async {
    try {
      pageIndex = pageIndex == 0 ? 1 : pageIndex;
      Map<String, dynamic> data = {
        'storyId': storyId,
        'storyType': type,
        "chapterIndex": index,
        "chapterPageIndex": pageIndex,
        "chapterNumber": numberChapter,
        "chapterLatestLocation": locationChapter,
        "chapterId": chapterLatestId
      };
      var baseEndpoint = await endPoint();
      final response =
          await baseEndpoint.post(ApiNetwork.createStoryForUser, data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Failed to create story for user - $e");
    }
  }

  Future<bool> deleteStoryForUser(int storyId) async {
    try {
      Map<String, dynamic> data = {'id': storyId};
      var baseEndpoint = await endPoint();
      final response =
          await baseEndpoint.delete(ApiNetwork.deleteStoryForUser, data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Failed to delete story for user - $e");
    }
  }

  Future<StoriesModel> getStoriesForUser(
      int pageIndex, int pageSize, int type) async {
    try {
      pageIndex = pageIndex == 0 ? 1 : pageIndex;
      bool interAvailable = await InternetConnection().hasInternetAccess;
      var data = chapterBox.get('getStoriesForUser-$type');
      if (interAvailable) {
        var baseEndpoint = await endPoint();
        final response = await baseEndpoint.get(
            sprintf(ApiNetwork.getStoriesForUser, [type, pageIndex, pageSize]));
        if (response.statusCode == 200) {
          chapterBox.put('getStoriesForUser-$type', response.data.toString());
          return storiesFromJson(response.data.toString());
        }
      }
      if (!interAvailable && data != null) {
        return storiesFromJson(data);
      }
      return StoriesModel(
        errorMessages: [],
        result: Result(
            items: [],
            pagingInfo: PagingInfo(pageSize: 0, page: 0, totalItems: 0)),
        isOk: false,
        statusCode: 400,
      );
    } catch (e) {
      throw Exception("Failed to get story for user - $e");
    }
  }

  Future<StoriesModel> getStoriesCommon(
      int pageIndex, int pageSize, int type) async {
    try {
      pageIndex = pageIndex == 0 ? 1 : pageIndex;
      var baseEndpoint = await endPoint();
      final response = await baseEndpoint.get(
          sprintf(ApiNetwork.getStoriesCommon, [type, pageIndex, pageSize]));
      if (response.statusCode == 200) {
        return storiesFromJson(response.data.toString());
      } else {
        return StoriesModel(
          errorMessages: [],
          result: Result(
              items: [],
              pagingInfo: PagingInfo(pageSize: 0, page: 0, totalItems: 0)),
          isOk: false,
          statusCode: 400,
        );
      }
    } catch (e) {
      throw Exception("Failed to get story for user - $e");
    }
  }

  Future<StoriesModel> getStoriesByType(
      int pageIndex, int pageSize, int type) async {
    try {
      pageIndex = pageIndex == 0 ? 1 : pageIndex;
      var baseEndpoint = await endPoint();
      final response = await baseEndpoint
          .get(sprintf(ApiNetwork.getStoriesType, [type, pageIndex, pageSize]));
      if (response.statusCode == 200) {
        return storiesFromJson(response.data.toString());
      } else {
        return StoriesModel(
          errorMessages: [],
          result: Result(
              items: [],
              pagingInfo: PagingInfo(pageSize: 0, page: 0, totalItems: 0)),
          isOk: false,
          statusCode: 400,
        );
      }
    } catch (e) {
      throw Exception("Failed to get story for user - $e");
    }
  }
}
