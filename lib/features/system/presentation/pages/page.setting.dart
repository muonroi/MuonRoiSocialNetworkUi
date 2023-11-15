import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:muonroi/core/localization/settings.language.code.dart';
import 'package:muonroi/core/localization/settings.languages.dart';
import 'package:muonroi/features/system/presentation/widgets/widget.toggle.button.dart';
import 'package:muonroi/shared/settings/enums/theme/enum.code.color.theme.dart';
import 'package:muonroi/shared/settings/setting.fonts.dart';
import 'package:muonroi/shared/settings/setting.images.dart';
import 'package:muonroi/shared/settings/setting.main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _messageFromChild = '';

  void _updateMessage(String message) {
    setState(() {
      _messageFromChild = message;
    });
    debugPrint(_messageFromChild);
  }

  String selectedLanguage = Languages.vi;
  Map<String, String> languageImages = {
    Languages.vi: CustomImages.vi2x,
    Languages.en: CustomImages.en2x,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: themeMode(context, ColorCode.modeColor.name),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
            color: themeMode(context, ColorCode.textColor.name),
          ),
          backgroundColor: themeMode(context, ColorCode.mainColor.name),
          elevation: 0,
          title: Text(
            L(context, LanguageCodes.myAccountSettingTextInfo.toString()),
            style: CustomFonts.h4(context),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.dark_mode_outlined,
                              color:
                                  themeMode(context, ColorCode.mainColor.name),
                            )),
                        Text(
                          L(context,
                              LanguageCodes.themeModeTextInfo.toString()),
                          style: CustomFonts.h5(context),
                        )
                      ],
                    ),
                  ),
                  ToggleButtonDarkMode(
                    callback: _updateMessage,
                    width: MainSetting.getPercentageOfDevice(context,
                            expectWidth: 200)
                        .width,
                    height: MainSetting.getPercentageOfDevice(context,
                            expectHeight: 40)
                        .height,
                    selectedColor: themeMode(context, ColorCode.modeColor.name),
                    normalColor: themeMode(context, ColorCode.textColor.name),
                    textLeft:
                        L(context, LanguageCodes.lightModeTextInfo.toString()),
                    textRight:
                        L(context, LanguageCodes.darkModeTextInfo.toString()),
                    selectedBackgroundColor:
                        themeMode(context, ColorCode.mainColor.name),
                    noneSelectedBackgroundColor:
                        themeMode(context, ColorCode.modeColor.name),
                  ),
                ],
              ),
              SizedBox(
                height: MainSetting.getPercentageOfDevice(context,
                        expectHeight: 23.0)
                    .height,
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.language_rounded,
                              color:
                                  themeMode(context, ColorCode.mainColor.name),
                            )),
                        Text(
                          L(context, LanguageCodes.languageTextInfo.toString()),
                          style: CustomFonts.h5(context),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MainSetting.getPercentageOfDevice(context,
                              expectWidth: 100)
                          .width,
                      height: MainSetting.getPercentageOfDevice(context,
                              expectHeight: 100)
                          .height,
                      child: const Row(
                        children: [
                          Expanded(
                            child: SelectBox(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class SelectBox extends StatefulWidget {
  const SelectBox({super.key});

  @override
  State<SelectBox> createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  String selectedLanguage = Languages.vi;
  Map<String, String> languageImages = {
    Languages.vi: CustomImages.vi2x,
    Languages.en: CustomImages.en2x,
  };
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      items: languageImages.keys.toList(),
      selectedItem: selectedLanguage,
      onChanged: (String? newValue) {
        setState(() {
          selectedLanguage = newValue!;
        });
      },
      dropdownBuilder: (context, itemString) {
        return Row(
          children: [
            Image.asset(
              languageImages[itemString]!,
              height: 30,
              width: 30,
            ),
            SizedBox(width: 10),
          ],
        );
      },
    );
  }
}
