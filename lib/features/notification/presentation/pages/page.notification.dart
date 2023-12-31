import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muonroi/core/localization/settings.language.code.dart';
import 'package:muonroi/features/notification/bloc/notification/notification_bloc.dart';
import 'package:muonroi/features/notification/data/repository/notification.repository.dart';
import 'package:muonroi/features/notification/presentation/widgets/widget.notification.item.dart';
import 'package:muonroi/features/notification/provider/provider.notification.dart';
import 'package:muonroi/shared/settings/setting.main.dart';
import 'package:muonroi/shared/settings/enums/theme/enum.code.color.theme.dart';
import 'package:muonroi/shared/settings/setting.fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    _notificationBloc = NotificationBloc(pageIndex: 1, pageSize: 10);
    _isPrevious = false;
    _notificationBloc
        .add(GetNotificationEventList(true, isPrevious: _isPrevious));
    _refreshController = RefreshController(initialRefresh: false);
    countLoadMore = 0;
    _scrollController = ScrollController();
    _notificationRepository = NotificationRepository();
    super.initState();
  }

  @override
  void dispose() {
    _notificationBloc.close();
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _notificationBloc
              .add(const GetNotificationEventList(false, isPrevious: true));
        });
      });
    }
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _notificationBloc
              .add(const GetNotificationEventList(false, isPrevious: false));
        });
      });
    }
    _refreshController.loadComplete();
  }

  late ScrollController _scrollController;
  late NotificationBloc _notificationBloc;
  late bool _isPrevious;
  late RefreshController _refreshController;
  late int countLoadMore;
  late NotificationRepository _notificationRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          L(context, LanguageCodes.notificationTextInfo.toString()),
          style: CustomFonts.h4(context),
        ),
      ),
      body: Consumer<NotificationProvider>(
        builder:
            (BuildContext context, NotificationProvider value, Widget? child) {
          return Column(
            children: [
              Expanded(
                  child: BlocProvider(
                create: (context) => _notificationBloc,
                child: BlocListener<NotificationBloc, NotificationState>(
                  listener: (context, state) {
                    const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  child: BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                      if (state is NotificationLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is NotificationLoadedState) {
                        var notificationList = state
                            .notificationSingleUser.result.items.reversed
                            .toList();
                        var totalViewSent = notificationList
                            .where((element) => element.notificationSate == 1)
                            .length;
                        value.setTotalView = totalViewSent;
                        userBox.put('totalNotification', totalViewSent);

                        return SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          footer: ClassicFooter(
                            canLoadingIcon: const Icon(Icons.arrow_downward),
                            canLoadingText: L(
                                context,
                                LanguageCodes.viewNextNotificationTextInfo
                                    .toString()),
                            idleText: L(
                                context,
                                LanguageCodes.viewNextNotificationTextInfo
                                    .toString()),
                          ),
                          header: ClassicHeader(
                            idleIcon: const Icon(Icons.arrow_upward),
                            refreshingText: L(
                                context,
                                LanguageCodes.viewPreviousNotificationTextInfo
                                    .toString()),
                            releaseText: L(
                                context,
                                LanguageCodes.viewPreviousNotificationTextInfo
                                    .toString()),
                            idleText: L(
                                context,
                                LanguageCodes.viewPreviousNotificationTextInfo
                                    .toString()),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                child: Row(
                                  children: [
                                    IconButton(
                                      splashRadius: 25,
                                      tooltip: L(
                                          context,
                                          LanguageCodes
                                              .viewNotificationAllTextInfo
                                              .toString()),
                                      onPressed: () async {
                                        await _notificationRepository
                                            .viewAllNotificationUser();
                                        if (context.mounted) {
                                          value.setViewAll = true;
                                          value.setTotalView = 0;
                                        }
                                      },
                                      icon:
                                          const Icon(Icons.clear_all_outlined),
                                      color: themeMode(
                                          context, ColorCode.textColor.name),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: notificationList.isNotEmpty
                                    ? ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        controller: _scrollController,
                                        itemCount: notificationList.length,
                                        itemBuilder: (context, index) {
                                          return NotificationItem(
                                              currentNotificationSent:
                                                  notificationList
                                                      .where((element) =>
                                                          element
                                                              .notificationSate ==
                                                          1)
                                                      .length,
                                              notificationId:
                                                  notificationList[index].id,
                                              state: notificationList[index]
                                                      .notificationSate ==
                                                  1,
                                              imageUrl: notificationList[index]
                                                  .imgUrl,
                                              title:
                                                  notificationList[index].title,
                                              content: N(
                                                  context,
                                                  notificationList[index]
                                                      .notificationType,
                                                  args: notificationList[index]
                                                      .message
                                                      .split('-')));
                                        })
                                    : getEmptyData(context),
                              )
                            ],
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ))
            ],
          );
        },
      ),
    );
  }
}
