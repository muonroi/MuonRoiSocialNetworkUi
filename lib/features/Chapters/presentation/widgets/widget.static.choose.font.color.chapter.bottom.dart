import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:muonroi/features/chapters/provider/provider.chapter.template.settings.dart';
import 'package:muonroi/features/chapters/settings/settings.dart';
import 'package:muonroi/shared/settings/enums/theme/enum.code.color.theme.dart';
import 'package:provider/provider.dart';
import 'package:muonroi/shared/settings/enums/emum.key.local.storage.dart';
import 'package:muonroi/shared/settings/setting.fonts.dart';
import 'package:muonroi/core/localization/settings.language.code.dart';
import 'package:muonroi/shared/settings/setting.main.dart';

class ChooseFontColor extends StatefulWidget {
  final KeyChapterColor colorType;
  const ChooseFontColor({
    Key? key,
    required this.colorType,
  }) : super(key: key);

  @override
  State<ChooseFontColor> createState() => _ChooseFontColorState();
}

class _ChooseFontColorState extends State<ChooseFontColor> {
  @override
  void initState() {
    _initData();
    _pickerColor = const Color(0xff443a49);
    _templateSetting = TemplateSetting();
    super.initState();
  }

  void _initData() {
    setState(() {
      _templateSetting = getCurrentTemplate(context);
      switch (widget.colorType) {
        case KeyChapterColor.background:
          _pickerColor =
              _templateSetting.backgroundColor ?? const Color(0xff443a49);
          break;
        case KeyChapterColor.font:
          _pickerColor = _templateSetting.fontColor ?? const Color(0xff443a49);
          break;
        case KeyChapterColor.chapterColor:
          break;
        case KeyChapterColor.disableColor:
          break;
        case KeyChapterColor.none:
          break;
      }
    });
  }

  late Color _pickerColor;
  late TemplateSetting _templateSetting;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeMode(context, ColorCode.modeColor.name),
      appBar: AppBar(
        title: Title(
            color: themeMode(context, ColorCode.textColor.name),
            child: Text(
              L(context, LanguageCodes.fontConfigDashboardTextInfo.toString()),
              style: CustomFonts.h5(context),
            )),
        backgroundColor: themeMode(context, ColorCode.modeColor.name),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: backButtonCommon(context)),
      ),
      body: Consumer<TemplateSetting>(
        builder: (context, templateValue, child) {
          return SingleChildScrollView(
            child: HueRingPicker(
              onColorChanged: (Color value) {
                var currentTemplate = getCurrentTemplate(context);
                switch (widget.colorType) {
                  case KeyChapterColor.background:
                    currentTemplate.backgroundColor = value;
                    templateValue.valueSetting = currentTemplate;
                    break;
                  case KeyChapterColor.font:
                    currentTemplate.fontColor = value;
                    templateValue.valueSetting = currentTemplate;
                    break;
                  case KeyChapterColor.chapterColor:
                    break;
                  case KeyChapterColor.disableColor:
                    break;
                  case KeyChapterColor.none:
                    break;
                }
                setState(() {
                  _pickerColor = value;
                });
                setCurrentTemplate(currentTemplate, context);
              },
              pickerColor: _pickerColor,
            ),
          );
        },
      ),
    );
  }
}
