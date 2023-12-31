import 'package:flutter/material.dart';
import 'package:muonroi/core/localization/settings.language.code.dart';
import 'package:muonroi/features/contacts/presentation/widget/widget.privacy.dart';
import 'package:muonroi/features/homes/presentation/widgets/widget.static.user.info.items.dart';
import 'package:muonroi/shared/settings/enums/theme/enum.code.color.theme.dart';
import 'package:muonroi/shared/settings/setting.fonts.dart';
import 'package:muonroi/shared/settings/setting.images.dart';
import 'package:muonroi/shared/settings/setting.main.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

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
          L(context, LanguageCodes.contactTextInfo.toString()),
          style: CustomFonts.h5(context),
        ),
      ),
      body: Column(
        children: [
          SettingItems(
            onPressed: () {
              Utils.sendEmail(email: 'admin.contact@muonroi.online');
            },
            text: L(context, LanguageCodes.contactToEmailTextInfo.toString()),
            image: CustomImages.email2x,
            colorIcon: themeMode(context, ColorCode.textColor.name),
          ),
          // SettingItems(
          //   onPressed: () {},
          //   text: L(context, LanguageCodes.askCommonTextInfo.toString()),
          //   image: CustomImages.user2x,
          //   colorIcon: themeMode(context, ColorCode.textColor.name),
          // ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Divider(
              color: themeMode(context, ColorCode.disableColor.name),
              thickness: 3,
            ),
          ),
          SettingItems(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => PrivacyWidget(
                          title: L(context,
                              LanguageCodes.privacyTextInfo.toString()),
                        ))),
            text: L(context, LanguageCodes.privacyTextInfo.toString()),
            image: CustomImages.privacy2x,
            colorIcon: themeMode(context, ColorCode.textColor.name),
          ),
          // SettingItems(
          //   onPressed: () {},
          //   text: L(context, LanguageCodes.privacyTermsTextInfo.toString()),
          //   image: CustomImages.privacyTerms2x,
          //   colorIcon: themeMode(context, ColorCode.textColor.name),
          // ),
        ],
      ),
    );
  }
}
