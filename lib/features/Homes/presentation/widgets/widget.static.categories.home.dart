import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:muonroi/features/categories/presentation/pages/page.categories.dart';
import 'package:muonroi/features/story/presentation/pages/page.editor.choose.dart';
import 'package:muonroi/features/story/settings/enums/enum.stories.special.dart';
import 'package:muonroi/shared/settings/enums/theme/enum.code.color.theme.dart';
import 'package:muonroi/shared/settings/setting.fonts.dart';
import 'package:muonroi/shared/settings/setting.images.dart';
import 'package:muonroi/core/localization/settings.language.code.dart';
import 'package:muonroi/shared/settings/setting.main.dart';

// #region Main categories
class MainCategories extends StatelessWidget {
  const MainCategories({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MainSetting.getPercentageOfDevice(context, expectWidth: 400).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor:
                    themeMode(context, ColorCode.disableColor.name),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CategoriesPage()),
                    );
                  },
                  icon: Image.asset(
                    CustomImages.gridFour2x,
                    color: themeMode(context, ColorCode.textColor.name),
                  ),
                ),
              ),
              Text(
                L(context, LanguageCodes.genreOfStrTextInfo.toString()),
                style: CustomFonts.h5(context),
              )
            ],
          ),
          Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor:
                    themeMode(context, ColorCode.disableColor.name),
                child: IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => RegularStories(
                                nameTypeRegularStories: L(
                                    context,
                                    LanguageCodes.trendStoriesTextInfo
                                        .toString()),
                                type: EnumStoriesSpecial.storiesAll,
                              ))),
                  icon: Image.asset(
                    CustomImages.translate2x,
                    color: themeMode(context, ColorCode.textColor.name),
                  ),
                ),
              ),
              Text(
                L(context, LanguageCodes.hotStoriesTextInfo.toString()),
                style: CustomFonts.h5(context),
              )
            ],
          ),
          Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor:
                    themeMode(context, ColorCode.disableColor.name),
                child: IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => RegularStories(
                                nameTypeRegularStories: L(
                                    context,
                                    LanguageCodes.trendStoriesTextInfo
                                        .toString()),
                                type: EnumStoriesSpecial.storiesNew,
                              ))),
                  icon: Image.asset(
                    CustomImages.bookOpenText2x,
                    color: themeMode(context, ColorCode.textColor.name),
                  ),
                ),
              ),
              Text(
                L(context, LanguageCodes.newStoriesHomeTextInfo.toString()),
                style: CustomFonts.h5(context),
              )
            ],
          ),
          Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor:
                    themeMode(context, ColorCode.disableColor.name),
                child: IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => RegularStories(
                                nameTypeRegularStories: L(
                                    context,
                                    LanguageCodes.trendStoriesTextInfo
                                        .toString()),
                                type: EnumStoriesSpecial.storiesComplete,
                              ))),
                  icon: Image.asset(
                    CustomImages.vector2x,
                    color: themeMode(context, ColorCode.textColor.name),
                  ),
                ),
              ),
              Text(
                L(context,
                    LanguageCodes.completeStoriesHomeTextInfo.toString()),
                style: CustomFonts.h5(context),
              )
            ],
          )
        ],
      ),
    );
  }
}

// #endregion

// #region Category name included view all
class GroupCategoryTextInfo extends StatelessWidget {
  final String titleText;
  final Widget nextRoute;
  const GroupCategoryTextInfo(
      {super.key, required this.titleText, required this.nextRoute});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            titleText,
            style:
                CustomFonts.h5(context).copyWith(fontWeight: FontWeight.w700),
          ),
          RichText(
              text: TextSpan(
                  text: L(
                    context,
                    LanguageCodes.viewAllTextInfo.toString(),
                  ),
                  style: CustomFonts.h5(context).copyWith(
                      color: themeMode(context, ColorCode.mainColor.name)),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => nextRoute));
                    }))
        ]),
      ),
    );
  }
}

// #endregion

// #region Category name not included view all
class OnlyTitleTextInfo extends StatelessWidget {
  final String textInfo;
  const OnlyTitleTextInfo({super.key, required this.textInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: MainSetting.getPercentageOfDevice(context, expectHeight: 30)
              .height,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              textInfo,
              style:
                  CustomFonts.h5(context).copyWith(fontWeight: FontWeight.w700),
            )
          ])),
    );
  }
}

// #endregion
