import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.group.dart';
import 'package:muonroi/shared/settings/setting.fonts.dart';
import 'package:muonroi/core/localization/settings.language.code.dart';
import 'package:muonroi/shared/settings/setting.main.dart';

class BodyChapter extends StatelessWidget {
  final ScrollController scrollController;
  final GroupChapterItems chapterInfo;
  final String tempFontFamily;
  final Color tempFontColor;
  final bool tempIsLeftAlign;
  final double tempFontSize;
  final Color tempBackground;
  const BodyChapter(
      {super.key,
      required this.scrollController,
      required this.chapterInfo,
      required this.tempFontFamily,
      required this.tempFontColor,
      required this.tempIsLeftAlign,
      required this.tempFontSize,
      required this.tempBackground});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        itemCount: chapterInfo.chunkSize,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MainSetting.getPercentageOfDevice(context,
                            expectWidth: 387)
                        .width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MainSetting.getPercentageOfDevice(context,
                                  expectWidth: 96.75)
                              .width,
                          child: Text(
                            "${L(context, LanguageCodes.chapterNumberTextInfo.toString())} ${chapterInfo.numberOfChapter}",
                            style: CustomFonts.h5(context).copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: tempFontFamily,
                                color: tempFontColor),
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: MainSetting.getPercentageOfDevice(context,
                                  expectWidth: 290.25)
                              .width,
                          child: Text(
                            chapterInfo.chapterTitle
                                .replaceAll(RegExp(r'Chương \d+:'), '')
                                .replaceAll("\n", "")
                                .trim(),
                            style: CustomFonts.h5(context).copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: tempFontFamily,
                                color: tempFontColor),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: Html(
                    data: chapterInfo.bodyChunk[index]
                        .replaceAll("\n", "")
                        .trim(),
                    style: {
                      '#': Style(
                        textAlign: tempIsLeftAlign
                            ? TextAlign.justify
                            : TextAlign.left,
                        fontFamily: tempFontFamily,
                        fontSize: FontSize(tempFontSize),
                        color: tempFontColor,
                        backgroundColor: tempBackground,
                      ),
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
