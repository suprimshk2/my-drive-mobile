import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/episode/constant/episode_constant.dart';
import 'package:mydrivenepal/feature/episode/data/model/milestone_detail_screen_params.dart';
import 'package:intl/intl.dart';

import 'package:mydrivenepal/feature/tasks/widgets/task_tile_widget.dart';
import 'package:mydrivenepal/feature/topic/constants/constant.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';
import 'package:mydrivenepal/feature/topic/topic_viewmodel.dart';
import 'package:mydrivenepal/feature/topic/utils/topic_utils.dart';
import 'package:mydrivenepal/shared/constant/date_constant.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/colors.dart';

import 'package:mydrivenepal/shared/util/custom_functions.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/expandable-tile/expandable_tile_widget.dart';
import 'package:mydrivenepal/widget/response_builder.dart';

import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widget/shimmer/topic_shimmer.dart';

class TopicScreen extends StatefulWidget {
  final MilestoneDetailScreenParams milestoneDetailScreenParams;

  const TopicScreen({
    super.key,
    required this.milestoneDetailScreenParams,
  });

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  final TopicViewModel _topicViewModel = locator<TopicViewModel>();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(checkScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  checkScroll() {
    if (_scrollController.offset > 0) {
      _topicViewModel.isScrolledScreen = true;
    } else {
      _topicViewModel.isScrolledScreen = false;
    }
  }

  Future<void> getData() async {
    _topicViewModel.fetchTopicList(
      milestoneId: widget.milestoneDetailScreenParams.milestoneId.toString(),
      episodeId: widget.milestoneDetailScreenParams.episodeId.toString(),
    );
  }

  Future<void> _onRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ChangeNotifierProvider<TopicViewModel>(
      create: (context) => _topicViewModel,
      child:
          Consumer<TopicViewModel>(builder: (context, topicViewModel, child) {
        return ScaffoldWidget(
          onPressedIcon: () {
            context.pop();
            topicViewModel.isScrolledScreen = false;
          },
          padding: 0,
          top: 0,
          bottom: 0,
          showAppbar: true,
          isCenterAligned: false,
          appbarTitle: topicViewModel.isScrolled
              ? widget.milestoneDetailScreenParams.name
              : "",
          child: SmartRefresher(
            scrollController: _scrollController,
            controller: _refreshController,
            onRefresh: _onRefresh,
            enablePullDown: true,
            enablePullUp: false,
            child: ResponseBuilder<List<Topic>>(
              onLoading: () => const TopicShimmerScreen(),
              response: topicViewModel.topicListUseCase,
              onRetry: () => getData(),
              onData: (List<Topic> topics) {
                if (topics.isEmpty) {
                  return Center(
                    child: TextWidget(
                      text: EpisodeConstant.noMilestoneFound,
                      textAlign: TextAlign.left,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacing_small,
                    vertical: Dimens.spacing_large,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderContent(),
                        TextWidget(
                          text: TopicStrings.topicTitle,
                          style: Theme.of(context).textTheme.subtitle.copyWith(
                                color: appColors.textInverse,
                              ),
                        ),
                        SizedBox(height: Dimens.spacing_6),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: topics.length,
                          itemBuilder: (context, index) {
                            final topic = topics[index];

                            return _buildTopic(topic, index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Column _buildHeaderContent() {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          textAlign: TextAlign.left,
          text: widget.milestoneDetailScreenParams.name,
          style: Theme.of(context).textTheme.subtitle.copyWith(
                color: appColors.textInverse,
              ),
        ),
        SizedBox(height: Dimens.spacing_large),
        TextWidget(
          textAlign: TextAlign.left,
          text: widget.milestoneDetailScreenParams.description,
          style: Theme.of(context).textTheme.caption.copyWith(
                color: appColors.textSubtle,
              ),
        ),
        SizedBox(height: Dimens.spacing_32),
      ],
    );
  }

  Column _buildTopic(Topic topic, int index) {
    // final isMilestoneStarted = getMilestoneDisplayDate(
    //         widget.milestoneDetailScreenParams.relativeStartDate ?? "",
    //         widget.milestoneDetailScreenParams.procedureDate ?? "",
    //         widget.milestoneDetailScreenParams.startDate ?? "") !=
    //     null;
    final appColors = context.appColors;

    bool filterTopic = filterStartedTopic(widget.milestoneDetailScreenParams);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpandableTile(
          backgroundColor: AppColors.transparent,
          expandedBackgroundColor: AppColors.transparent,
          animationDuration:
              filterTopic ? Duration(milliseconds: 200) : Duration.zero,
          initiallyExpanded: index == 0 ? true : false,
          header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  topic.topic ?? '',
                  maxLines: 4,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText.copyWith(
                        color: appColors.textInverse,
                      ),
                ),
              ),
              if (isNotEmpty(topic.status))
                getTopicStatus(context, topic.status!)
            ],
          ),
          content: filterTopic
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: topic.tasks?.length ?? 0,
                  itemBuilder: (context, index) {
                    final task = topic.tasks![index];

                    return TaskTileWidget(task: task);
                  },
                )
              : Center(
                  child: TextWidget(
                    text: "Milestone is not yet started",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText
                        .copyWith(color: appColors.textInverse),
                  ),
                ),
        ),
      ],
    );
  }
}

String? getMilestoneDisplayDate(
    String relativeStartDate, String procedureDate, String startDate) {
  if (isNotEmpty(relativeStartDate) && relativeStartDate != "N/A") {
    return relativeStartDate;
  } else if (isNotEmpty(procedureDate) && procedureDate != "N/A") {
    return procedureDate;
  } else if (isNotEmpty(startDate) && startDate != "N/A") {
    return startDate;
  } else {
    return null;
  }
}

bool filterStartedTopic(MilestoneDetailScreenParams milestone) {
  String? milestoneStartDate = getMilestoneDisplayDate(
      milestone.relativeStartDate ?? "",
      milestone.procedureDate ?? "",
      milestone.startDate ?? "");

  final todaysDate = DateTime.now();

  if (milestoneStartDate == null) {
    return false;
  } else {
    try {
      final formatter = DateFormat(DateFormatConstant.MM_DD_YY);
      DateTime inputDate = formatter.parse(milestoneStartDate);

      return inputDate.isBefore(todaysDate);
    } catch (e) {
      print('Error parsing date $milestoneStartDate: $e');
      return false;
    }
  }
}
