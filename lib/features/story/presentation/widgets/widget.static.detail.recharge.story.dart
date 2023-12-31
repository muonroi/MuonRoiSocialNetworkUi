// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:muonroi/Items/Static/Buttons/widget.static.button.dart';
// import 'package:muonroi/Items/Static/RenderData/PrimaryPages/Home/widget.static.categories.home.dart';
// import 'package:muonroi/Models/story/models.stories.story.dart';
// import 'package:muonroi/Pages/Accounts/Logins/pages.logins.sign_in.dart';
// import 'package:muonroi/settings/settings.colors.dart';
// import 'package:muonroi/settings/setting.fonts.dart';
// import 'package:muonroi/settings/settings.images.dart';
// import 'package:muonroi/settings/settings.language_code.vi..dart';
// import 'package:muonroi/settings/setting.main.dart';

// class RechargeStory extends StatelessWidget {
//   final StoryModel widget;
//   const RechargeStory({super.key, required this.widget});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: Column(children: [
//         GroupCategoryTextInfo(
//             titleText:L(context,ViCode.coinstoryTextInfo.toString()),
//             nextRoute: const SignInPage()),
//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 12.0),
//           height: MainSetting.getPercentageOfDevice(context, expectHeight: 290)
//               .height,
//           child: ListView.builder(
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: widget.userCoin?.length,
//             itemBuilder: (context, index) {
//               return Row(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.symmetric(vertical: 12.0),
//                     width: MainSetting.getPercentageOfDevice(context,
//                             expectWidth: 46)
//                         .width,
//                     height: MainSetting.getPercentageOfDevice(context,
//                             expectHeight: 46)
//                         .height,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10.0),
//                       child: CachedNetworkImage(
//                         imageUrl: widget.userCoin?[index].imageLink ??
//                             ImageDefault.imageAvatarDefault,
//                         progressIndicatorBuilder:
//                             (context, url, downloadProgress) =>
//                                 CircularProgressIndicator(
//                                     value: downloadProgress.progress),
//                         errorWidget: (context, url, error) =>
//                             const Icon(
                    //   RpgAwesome.book,
                    //   size: 56,
                    // ),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                             child: Text(
//                               widget.userCoin?[index].fullName ??
//                                   L(context,ViCode.notfoundTextInfo.toString()),
//                               style: FontsDefault.h5(context),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 8.0, vertical: 4.0),
//                             child: Text(
//                               '${widget.userCoin?[index].createdDate.toString() ?? L(context,ViCode.notfoundTextInfo.toString())} ${L(context,ViCode.passedNumberMinuteTextInfo.toString())}',
//                               style: FontsDefault.h5(context),
//                               textAlign: TextAlign.left,
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),
//                           ),
//                         ]),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 32.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           child: Image.asset(ImageDefault.coin2x,
//                               color: themeMode(context,ColorCode.mainColor.name)),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             formatValueNumber(
//                                 widget.userCoin![index].coinValue * 1.0),
//                             style: FontsDefault.h5(context).copyWith(
//                                 color: themeMode(context,ColorCode.mainColor.name),
//                                 fontWeight: FontWeight.w700),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               );
//             },
//           ),
//         ),
//         Align(
//           alignment: Alignment.center,
//           child: SizedBox(
//             child: SizedBox(
//               width:
//                   MainSetting.getPercentageOfDevice(context, expectWidth: 319)
//                       .width,
//               height:
//                   MainSetting.getPercentageOfDevice(context, expectHeight: 40)
//                       .height,
//               child: ButtonWidget.buttonNavigatorNextPreviewLanding(
//                   context, const SignInPage(),
//                   textStyle: FontsDefault.h5(context).copyWith(
//                       color: themeMode(context,ColorCode.mainColor.name),
//                       fontWeight: FontWeight.w600),
//                   color: themeMode(context,ColorCode.lightAppColor.name),
//                   borderColor: themeMode(context,ColorCode.mainColor.name),
//                   widthBorder: 2,
//                   textDisplay:L(context,ViCode.pushRechargeStoryTextInfo.toString())),
//             ),
//           ),
//         )
//       ]),
//     );
//   }
// }
