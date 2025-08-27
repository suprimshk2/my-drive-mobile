import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydrivenepal/di/service_locator.dart';

import 'package:mydrivenepal/feature/tasks/constants/task_strings.dart';
import 'package:mydrivenepal/feature/tasks/task_listing_viewmodel.dart';
import 'package:mydrivenepal/feature/tasks/widgets/task_tile_widget.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DueTaskListing extends StatefulWidget {
  const DueTaskListing({
    super.key,
  });

  @override
  State<DueTaskListing> createState() => _DueTaskListingState();
}

class _DueTaskListingState extends State<DueTaskListing>
    with AutomaticKeepAliveClientMixin {
  final _taskViewModel = locator<TaskListingViewmodel>();
  final _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future<void> _getData() async {
    await _taskViewModel.fetchDueTasks();
  }

  Future<void> _onRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<TaskListingViewmodel>(
        builder: (context, taskViewModel, child) {
      return SmartRefresher(
        scrollController: _scrollController,
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        enablePullUp: false,
        child: ResponseBuilder<List<Task>>(
          response: taskViewModel.dueTaskListResponse,
          onRetry: () => _getData(),
          onLoading: () => const CardShimmerWidget(
              height: Dimens.spacing_50, needMargin: true),
          onData: (List<Task> tasks) {
            int itemCount = tasks.length;

            if (tasks.isEmpty) {
              String emptyText = TaskStrings.noDueTasksFound;
              return Center(
                child: TextWidget(
                  text: emptyText,
                  textAlign: TextAlign.left,
                  textOverflow: TextOverflow.ellipsis,
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacing_8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    ListView.builder(
                      itemCount: itemCount,
                      shrinkWrap: true,
                      controller: _scrollController,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        bool isLastItem = index == itemCount - 1;

                        final task = tasks[index];

                        return Padding(
                          padding:
                              EdgeInsets.only(bottom: isLastItem ? 32.h : 0),
                          child: TaskTileWidget(task: task, showStatus: false),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class CurrentTaskListing extends StatefulWidget {
  const CurrentTaskListing({
    super.key,
  });

  @override
  State<CurrentTaskListing> createState() => _CurrentTaskListingState();
}

class _CurrentTaskListingState extends State<CurrentTaskListing>
    with AutomaticKeepAliveClientMixin {
  final _taskViewModel = locator<TaskListingViewmodel>();

  final _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  Future<void> _onRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future<void> _getData() async {
    await _taskViewModel.fetchCurrentTasks();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<TaskListingViewmodel>(
        builder: (context, taskViewModel, child) {
      return SmartRefresher(
        scrollController: _scrollController,
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        enablePullUp: false,
        child: ResponseBuilder<List<Task>>(
          response: taskViewModel.currentTaskListResponse,
          onRetry: () => _getData(),
          onLoading: () => const CardShimmerWidget(
              height: Dimens.spacing_50, needMargin: true),
          onData: (List<Task> tasks) {
            int itemCount = tasks.length;

            if (tasks.isEmpty) {
              String emptyText = TaskStrings.noCurrentTasksFound;
              return Center(
                child: TextWidget(
                  text: emptyText,
                  textAlign: TextAlign.left,
                  textOverflow: TextOverflow.ellipsis,
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacing_8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: itemCount,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        bool isLastItem = index == itemCount - 1;

                        final task = tasks[index];

                        return Padding(
                          padding:
                              EdgeInsets.only(bottom: isLastItem ? 32.h : 0),
                          child: TaskTileWidget(task: task, showStatus: false),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
