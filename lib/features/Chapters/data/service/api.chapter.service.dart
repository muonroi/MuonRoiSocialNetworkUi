import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:muonroi/core/Authorization/setting.api.dart';
import 'package:muonroi/core/services/api_route.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.group.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.list.paging.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.list.paging.range.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.single.chapter.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.list.chapter.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.preview.chapter.dart';
import 'package:muonroi/features/chapters/settings/settings.dart';
import 'package:muonroi/shared/settings/setting.main.dart';
import 'package:sprintf/sprintf.dart';

class ChapterService {
  Future<ChapterPreviewModel> getChaptersDataList(int storyId, int pageIndex,
      {bool isLatest = false}) async {
    try {
      pageIndex = pageIndex == 0 ? 1 : pageIndex;
      var baseEndpoint = await endPoint();
      final response = await baseEndpoint.get(sprintf(
          ApiNetwork.getChapterPaging,
          ["$storyId", "$pageIndex", "100", "$isLatest"]));
      if (response.statusCode == 200) {
        return chapterPreviewModelFromJson(response.data.toString(), pageIndex);
      } else {
        throw Exception("Failed to load chapter");
      }
    } catch (e) {
      throw Exception("Failed to load chapter");
    }
  }

  Future<ListPagingChapters> getGroupChaptersDataDetail(int storyId) async {
    try {
      var groupDataChapter =
          chapterBox.get("getGroupChaptersDataDetail-$storyId");
      if (groupDataChapter == null) {
        var baseEndpoint = await endPoint();

        final response = await baseEndpoint
            .get(sprintf(ApiNetwork.getListChapterPaging, ["$storyId"]));
        if (response.statusCode == 200) {
          chapterBox.put(
              "getGroupChaptersDataDetail-$storyId", response.data.toString());
          return listPagingChaptersFromJson(response.data.toString());
        } else {
          throw Exception("Failed to load chapter");
        }
      } else {
        return listPagingChaptersFromJson(groupDataChapter);
      }
    } catch (e) {
      throw Exception("Failed to load chapter");
    }
  }

  Future<DetailChapterInfo> getChapterDataDetail(int fromChapterId) async {
    try {
      var baseEndpoint = await endPoint();
      final response = await baseEndpoint
          .get(sprintf(ApiNetwork.getChapterDetail, ["$fromChapterId"]));
      if (response.statusCode == 200) {
        var result = detailChapterInfoFromJson(response.data.toString());
        var items = result.result;
        items.body = decryptStringAES(items.body);
        items.bodyChunk = decryptChunkBody(items.bodyChunk, items.chunkSize);
        result.result = items;
        return result;
      } else {
        throw Exception("Failed to load detail chapter");
      }
    } catch (e) {
      throw Exception("Failed to load detail chapter");
    }
  }

  Future<DetailChapterInfo> fetchActionChapterOfStory(
      int chapterId, int storyId, bool action) async {
    try {
      var baseEndpoint = await endPoint();
      var stringEndpointName = action ? "Next" : "Previous";
      final response = await baseEndpoint.get(sprintf(
          ApiNetwork.getActionChapterDetail,
          [stringEndpointName, "$storyId", "$chapterId"]));
      if (response.statusCode == 200) {
        var result = detailChapterInfoFromJson(response.data.toString());
        var items = result.result;
        items.body = decryptStringAES(items.body);
        items.bodyChunk = decryptChunkBody(items.bodyChunk, items.chunkSize);
        result.result = items;
        return result;
      } else {
        throw Exception("Failed to load detail chapter");
      }
    } catch (e) {
      throw Exception("Failed to load detail chapter");
    }
  }

  Future<ChapterInfo> fetchLatestChapterAnyStory(
      {int pageIndex = 1, int pageSize = 5}) async {
    try {
      pageIndex = pageIndex == 0 ? 1 : pageIndex;
      var baseEndpoint = await endPoint();
      final response = await baseEndpoint.get(
          sprintf(ApiNetwork.getLatestChapterNumber, [pageIndex, pageSize]));
      if (response.statusCode == 200) {
        return chapterInfoFromJson(response.data.toString());
      } else {
        throw Exception("Failed to load list chapter");
      }
    } catch (e) {
      throw Exception("Failed to load list chapter");
    }
  }

  Future<ListPagingRangeChapters> getFromToChaptersDataDetail(
      int storyId, int pageIndex, int from, int to) async {
    try {
      pageIndex = pageIndex == 0 ? 1 : pageIndex;
      var fromToChapter = chapterBox
          .get("getFromToChaptersDataDetail-$storyId-$pageIndex-$from-$to");
      if (fromToChapter == null) {
        var baseEndpoint = await endPoint();
        final response = await baseEndpoint.get(sprintf(
            ApiNetwork.getFromToChapterPaging,
            ["$storyId", "$pageIndex", "$from", "$to"]));
        if (response.statusCode == 200) {
          chapterBox.put(
              "getFromToChaptersDataDetail-$storyId-$pageIndex-$from-$to",
              response.data.toString());
          return listPagingRangeChaptersFromJson(response.data.toString());
        } else {
          throw Exception("Failed to load chapter");
        }
      } else {
        return listPagingRangeChaptersFromJson(fromToChapter);
      }
    } catch (e) {
      throw Exception("Failed to load chapter");
    }
  }

  Future<GroupChapters> getGroupChapters(int storyId, int pageIndex,
      {int pageSize = 100,
      bool isDownload = false,
      bool isAudio = false}) async {
    try {
      pageIndex = pageIndex == 0 ? 1 : pageIndex;
      var internetAvailable = await InternetConnection().hasInternetAccess;

      if (!internetAvailable) {
        var chaptersOfficeByIndex =
            chapterBox.get("story-$storyId-current-group-chapter-$pageIndex");
        if (chaptersOfficeByIndex != null) {
          return groupChaptersFromJson(chaptersOfficeByIndex);
        }
      }
      var chapterCurrentGroup =
          chapterBox.get("story-$storyId-current-group-chapter");

      if (chapterCurrentGroup != null && !isAudio) {
        return groupChaptersFromJson(chapterCurrentGroup);
      }
      var baseEndpoint = await endPoint();
      final response = await baseEndpoint.get(sprintf(
          ApiNetwork.getGroupChapters,
          ["$storyId", "$pageIndex", "$pageSize"]));
      if (response.statusCode == 200) {
        var result = groupChaptersFromJson(response.data.toString());
        var items = result.result.items;
        result.result.items = decryptBodyChapterAndChunk(items);
        chapterBox.put("story-$storyId-current-group-chapter",
            groupChaptersToJson(result));
        if (isDownload) {
          chapterBox.put("story-$storyId-current-group-chapter-$pageIndex",
              groupChaptersToJson(result));
        }

        return result;
      } else {
        throw Exception("Failed to load chapter");
      }
    } catch (e) {
      throw Exception("Failed to load chapter");
    }
  }
}
