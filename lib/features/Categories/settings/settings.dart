import 'package:flutter/material.dart';
import 'package:muonroi/features/story/data/models/model.stories.story.dart';
import 'package:muonroi/features/story/data/repositories/story.repository.dart';
import 'package:muonroi/features/story/presentation/pages/page.stories.vertical.dart';
import 'package:muonroi/shared/settings/enums/enum.search.story.dart';

Widget showToolTipHaveAnimationStories(String message,
    {BuildContext? context, String? data}) {
  return Positioned.fill(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: context == null
            ? () {}
            : () async {
                List<StoryItems> storiesData =
                    await _handleSearchByCategory(data!, SearchType.category);
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoriesVerticalData(
                        isShowBack: true,
                        isShowLabel: false,
                        categoryId: int.parse(data),
                        stories: storiesData,
                      ),
                    ),
                  );
                }
              },
        child: Tooltip(
          onTriggered: () => TooltipTriggerMode.longPress,
          message: message,
          showDuration: const Duration(milliseconds: 1000),
        ),
      ),
    ),
  );
}

Future<List<StoryItems>> _handleSearchByCategory(
    String data, SearchType type) async {
  StoryRepository storyRepository = StoryRepository();
  var resultData = await storyRepository.searchStory([data], [type], 1, 15);
  return resultData.result.items;
}
