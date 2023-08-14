import 'package:flutter/material.dart';
import 'package:muonroi/Items/Static/Buttons/widget.static.button.dart';
import 'package:muonroi/Items/Static/RenderData/Shared/DetailStory/widget.static..detail.chapter.story.dart';
import 'package:muonroi/Items/Static/RenderData/Shared/widget.static.model.chapter.dart';
import 'package:muonroi/Models/Stories/models.stories.story.dart';
import 'package:muonroi/Settings/settings.colors.dart';
import 'package:muonroi/Settings/settings.fonts.dart';
import 'package:muonroi/Settings/settings.language_code.vi..dart';
import 'package:muonroi/Settings/settings.main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DetailStory/widget.static.detail.header.story.dart';
import 'DetailStory/widget.static.detail.intro.notify.story.dart';
import 'DetailStory/widget.static.detail.more.info.story.dart';
import 'DetailStory/widget.static.detail.similar.story.dart';

class StoriesDetail extends StatefulWidget {
  final StoryItems storyInfo;
  const StoriesDetail({
    Key? key,
    required this.storyInfo,
  }) : super(key: key);
  @override
  State<StoriesDetail> createState() => _StoriesDetailState();
}

class _StoriesDetailState extends State<StoriesDetail> {
  @override
  void initState() {
    super.initState();
  }

  double latestChapter = 0;
  set string(String val) => setState(() => latestChapter = double.parse(val));
  final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();
  Future<void> getChapterId() async {
    final SharedPreferences chapterTemp = await sharedPreferences;
    chapterId = (chapterTemp.getInt("story-${widget.storyInfo.id}") ?? 0) + 1;
  }

  late int chapterId = 0;
  @override
  Widget build(BuildContext context) {
    getChapterId();
    List<Widget> componentOfDetailStory = [
      Header(widget: widget.storyInfo),
      MoreInfoStory(widget: widget.storyInfo),
      IntroAndNotificationStory(
        name: L(ViCode.introStoryTextInfo.toString()),
        value: widget.storyInfo.storySynopsis,
      ),
      // IntroAndNotificationStory(
      //   name: L(ViCode.notifyStoryTextInfo.toString()),
      //   value: "", //widget.storyInfo.notification ?? "",
      // ),
      ChapterOfStory(
        callback: (val) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              latestChapter = double.parse(val);
            });
          });
        },
        storyId: widget.storyInfo.id,
      ),
      // CommentOfStory(
      //   widget: widget.storyInfo,
      // ),
      // RechargeStory(
      //   widget: widget.storyInfo,
      // ),
      SimilarStories(
        storyInfo: widget.storyInfo,
      )
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorDefaults.lightAppColor,
        leading: const BackButton(
          color: ColorDefaults.thirdMainColor,
        ),
      ),
      backgroundColor: ColorDefaults.lightAppColor,
      body: SizedBox(
        child: ListView.builder(
          itemCount: componentOfDetailStory.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [componentOfDetailStory[index]],
                ));
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width:
                  MainSetting.getPercentageOfDevice(context, expectWidth: 200)
                      .width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.headphones_outlined))),
                  SizedBox(
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.download_outlined)),
                  ),
                  SizedBox(
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_add_outlined)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                width:
                    MainSetting.getPercentageOfDevice(context, expectWidth: 150)
                        .width,
                child: ButtonWidget.buttonNavigatorNextPreviewLanding(
                    context,
                    Chapter(
                      storyId: widget.storyInfo.id,
                      storyName: widget.storyInfo.storyTitle,
                      chapterId: chapterId,
                    ),
                    textStyle: FontsDefault.h5.copyWith(
                        color: ColorDefaults.thirdMainColor,
                        fontWeight: FontWeight.w500),
                    color: ColorDefaults.mainColor,
                    borderColor: ColorDefaults.mainColor,
                    widthBorder: 2,
                    textDisplay:
                        '${L(ViCode.chapterNumberTextInfo.toString())} ${formatValueNumber(latestChapter)}'),
              ),
            )
          ],
        )),
      ),
    );
  }
}
