import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:muonroi/core/notification/widget.notification.dart';
import 'package:muonroi/core/localization/settings.language.code.dart';
import 'package:muonroi/features/chapters/bloc/group_bloc/group_chapters_of_story_bloc.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.group.dart';
import 'package:muonroi/features/chapters/data/repositories/chapter.repository.dart';
import 'package:muonroi/features/story/settings/enums/enum.story.user.dart';
import 'package:muonroi/features/story/data/repositories/story.repository.dart';
import 'package:muonroi/shared/settings/enums/theme/enum.code.color.theme.dart';
import 'package:muonroi/shared/settings/setting.fonts.dart';
import 'package:muonroi/shared/settings/setting.main.dart';
import 'package:sprintf/sprintf.dart';

class StoriesDownloadPage extends StatefulWidget {
  final String storyName;
  final int storyId;
  final int firstChapterId;
  final int totalChapter;
  const StoriesDownloadPage(
      {super.key,
      required this.storyName,
      required this.storyId,
      required this.totalChapter,
      required this.firstChapterId});

  @override
  State<StoriesDownloadPage> createState() => _StoriesDownloadPageState();
}

class _StoriesDownloadPageState extends State<StoriesDownloadPage> {
  @override
  void initState() {
    _currentIndex = [];
    _groupChapterOfStoryBloc =
        GroupChapterOfStoryBloc(widget.storyId, 1, 15, false, 0);
    _groupChapterOfStoryBloc.add(GroupChapterOfStoryList());
    _isDownloadComplete = [];
    _currentTotal = 0;
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _groupChapterOfStoryBloc.close();
    super.dispose();
  }

  void _initData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _currentTotal = chapterBox.get(
                "story-${widget.storyId}-current-group-chapter-download-total") ??
            0;
      });
    });
  }

  late GroupChapterOfStoryBloc _groupChapterOfStoryBloc;
  late List<int> _isDownloadComplete;
  late int _currentTotal;
  late List<int> _currentIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeMode(context, ColorCode.modeColor.name),
      appBar: AppBar(
        backgroundColor: themeMode(context, ColorCode.mainColor.name),
        elevation: 0,
        leading: IconButton(
          splashRadius: 25,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
          color: themeMode(context, ColorCode.textColor.name),
        ),
        title: Text(
          widget.storyName,
          style: CustomFonts.h5(context).copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.start,
          maxLines: 1,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                child: RichText(
                  text: TextSpan(
                    text:
                        L(context, LanguageCodes.downloadedTextInfo.toString()),
                    style: CustomFonts.h5(context),
                    children: <TextSpan>[
                      TextSpan(
                        text: ': $_currentTotal/${widget.totalChapter}',
                        style: CustomFonts.h5(context),
                      ),
                    ],
                  ),
                ),
              ),
              BlocProvider(
                create: (context) => _groupChapterOfStoryBloc,
                child: BlocListener<GroupChapterOfStoryBloc,
                    GroupChapterOfStoryState>(
                  listener: (context, state) {
                    const Center(child: CircularProgressIndicator());
                  },
                  child: BlocBuilder<GroupChapterOfStoryBloc,
                      GroupChapterOfStoryState>(
                    builder: (context, state) {
                      if (state is GroupChapterOfStoryLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GroupChapterOfStoryLoadedState) {
                        return GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            scrollDirection: Axis.vertical,
                            childAspectRatio: (1 / .2),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: List.generate(state.chapter.result.length,
                                (index) {
                              var chapterIndex = state.chapter.result[index];
                              return Stack(children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: themeMode(
                                          context, ColorCode.disableColor.name),
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Stack(children: [
                                        !_currentIndex.contains(index)
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${chapterIndex.from}-${chapterIndex.to}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        CustomFonts.h5(context),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0),
                                                      child: chapterBox.get(
                                                                  "story-${widget.storyId}-download-group-chapter-$index") ??
                                                              _isDownloadComplete
                                                                  .contains(
                                                                      index)
                                                          ? Icon(
                                                              Icons
                                                                  .check_circle_outline,
                                                              color: themeMode(
                                                                  context,
                                                                  ColorCode
                                                                      .mainColor
                                                                      .name),
                                                            )
                                                          : null)
                                                ],
                                              )
                                            : Positioned.fill(
                                                child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(32.0),
                                                color: Colors.transparent,
                                                child: SpinKitPouringHourGlass(
                                                  color: themeMode(context,
                                                      ColorCode.mainColor.name),
                                                ),
                                              ))
                                      ])),
                                ),
                                Positioned.fill(
                                  child: Material(
                                    borderRadius: BorderRadius.circular(32.0),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(32.0),
                                      onTap: () async {
                                        final storyRepository =
                                            StoryRepository();
                                        setState(() {
                                          _currentIndex.add(index);
                                        });
                                        var isDelete = chapterBox.get(
                                                "story-${widget.storyId}-download-group-chapter-$index") ??
                                            false;

                                        if (context.mounted && isDelete) {
                                          chapterBox.delete(
                                              "story-${widget.storyId}-download-group-chapter-$index");
                                          // #region notification
                                          NotificationPush.showNotification(
                                              title: L(
                                                  context,
                                                  LanguageCodes
                                                      .notificationTextConfigTextInfo
                                                      .toString()),
                                              body: sprintf(
                                                  L(
                                                      context,
                                                      LanguageCodes
                                                          .chaptersDownloadDeletedTextInfo
                                                          .toString()),
                                                  [
                                                    "${chapterIndex.from}-${chapterIndex.to}"
                                                  ]),
                                              fln:
                                                  flutterLocalNotificationsPlugin);
                                          // #endregion

                                          // #region get and set new total chapter downloaded
                                          var total = chapterBox.get(
                                                  "story-${widget.storyId}-current-group-chapter-download-total") ??
                                              0;
                                          chapterBox.put(
                                              "story-${widget.storyId}-current-group-chapter-download-total",
                                              total > chapterIndex.total
                                                  ? total - chapterIndex.total
                                                  : 0);
                                          var currentTotal = chapterBox.get(
                                                  "story-${widget.storyId}-current-group-chapter-download-total") ??
                                              0;
                                          // #endregion
                                          setState(() {
                                            _isDownloadComplete.remove(index);
                                            _currentTotal = currentTotal;
                                            _currentIndex.remove(index);
                                          });
                                          // #region Add to user download list
                                          _currentTotal = chapterBox.get(
                                                  "story-${widget.storyId}-current-group-chapter-download-total") ??
                                              0;
                                          if (_currentTotal > 0) {
                                            storyRepository.createStoryForUser(
                                                widget.storyId,
                                                StoryForUserType.download.index,
                                                0,
                                                1,
                                                1,
                                                0,
                                                widget.firstChapterId);
                                          } else {
                                            storyRepository.deleteBookmarkStory(
                                                widget.storyId);
                                          }
                                          // #endregion
                                        } else {
                                          var storyRepository =
                                              StoryRepository();
                                          var chapterRepository =
                                              ChapterRepository(
                                                  chapterIndex.pageIndex,
                                                  100,
                                                  0,
                                                  storyId: widget.storyId,
                                                  isLatest: false);
                                          var chapterResult =
                                              await chapterRepository
                                                  .fetchGroupChapters(
                                                      widget.storyId,
                                                      chapterIndex.pageIndex,
                                                      isDownload: true);
                                          await chapterRepository
                                              .fetchFromToChapterOfStory(
                                                  widget.storyId,
                                                  chapterIndex.pageIndex,
                                                  chapterIndex.fromId,
                                                  chapterIndex.toId);

                                          // #region save story info
                                          var storyInfo = chapterBox.get(
                                              "storyDetail-${widget.storyId}");
                                          if (storyInfo == null) {
                                            await storyRepository
                                                .fetchDetailStory(
                                                    widget.storyId);
                                          }
                                          // #endregion

                                          // #region save chapter
                                          chapterBox.put(
                                              "story-${widget.storyId}-current-group-chapter-${chapterIndex.pageIndex}",
                                              groupChaptersToJson(
                                                  chapterResult));
                                          // #endregion

                                          // #region save saved of index
                                          chapterBox.put(
                                              "story-${widget.storyId}-download-group-chapter-$index",
                                              true);
                                          // #endregion

                                          // #region get and set new total chapter downloaded
                                          var total = chapterBox.get(
                                                  "story-${widget.storyId}-current-group-chapter-download-total") ??
                                              0;
                                          chapterBox.put(
                                              "story-${widget.storyId}-current-group-chapter-download-total",
                                              chapterIndex.total + total);
                                          var currentTotal = chapterBox.get(
                                                  "story-${widget.storyId}-current-group-chapter-download-total") ??
                                              0;
                                          // #endregion

                                          setState(() {
                                            NotificationPush.showNotification(
                                                title: L(
                                                    context,
                                                    LanguageCodes
                                                        .notificationTextConfigTextInfo
                                                        .toString()),
                                                body: sprintf(
                                                    L(
                                                        context,
                                                        LanguageCodes
                                                            .chaptersDownloadAddedTextInfo
                                                            .toString()),
                                                    [
                                                      "${chapterIndex.from}-${chapterIndex.to}"
                                                    ]),
                                                fln:
                                                    flutterLocalNotificationsPlugin);
                                            _currentTotal = currentTotal;
                                            _isDownloadComplete.add(index);
                                            _currentIndex.remove(index);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ]);
                            }));
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
