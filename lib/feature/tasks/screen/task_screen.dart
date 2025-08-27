import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/di.dart';
import 'package:mydrivenepal/feature/tasks/constants/task_strings.dart';
import 'package:mydrivenepal/feature/tasks/screen/task_tab_listing.dart';
import 'package:mydrivenepal/feature/tasks/task_listing_viewmodel.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/chip/rounded_chip_widget.dart';
import 'package:provider/provider.dart';
import '../../../shared/shared.dart';
import '../../../widget/widget.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _taskViewModel = locator<TaskListingViewmodel>();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _tabController.index = _taskViewModel.activeIndex;

    _tabController.addListener(() {
      handleTabChange();
    });
  }

  void handleTabChange() {
    _taskViewModel.activeIndex = _tabController.index;
  }

  @override
  void dispose() {
    _taskViewModel.resetActiveIndex();

    _tabController.removeListener(handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Consumer<TaskListingViewmodel>(
        builder: (context, taskViewModel, child) {
      final dueTasks = taskViewModel.dueTaskListResponse.data ?? [];
      final currentTasks = taskViewModel.currentTaskListResponse.data ?? [];

      return ScaffoldWidget(
        padding: 0,
        bottom: 0,
        showBackButton: false,
        appbarTitle: TaskStrings.tasks,
        resizeToAvoidBottomInset: true,
        child: Column(
          children: [
            TabBar(
              tabs: [
                _buildTabs(
                  taskViewModel,
                  tabName: TaskStrings.dueTasks,
                  count: dueTasks.length,
                  tabIndex: 0,
                ),
                _buildTabs(
                  taskViewModel,
                  tabName: TaskStrings.currentTasks,
                  count: currentTasks.length,
                  tabIndex: 1,
                ),
              ],
              controller: _tabController,
              tabAlignment: TabAlignment.center,
              isScrollable: true,
              padding: EdgeInsets.zero,
              labelStyle: Theme.of(context).textTheme.bodyTextBold,
              labelColor: appColors.textPrimary,
              unselectedLabelStyle: Theme.of(context).textTheme.bodyText,
              unselectedLabelColor: appColors.textSubtle,
              indicatorColor: appColors.bgPrimaryMain,
              indicatorWeight: 2.0,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: Dimens.spacing_12),
              dividerColor: appColors.borderGraySoftAlpha50,
              dividerHeight: 0.5,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  DueTaskListing(
                    key: const Key(TaskStrings.dueTasks),
                  ),
                  CurrentTaskListing(
                    key: const Key(TaskStrings.currentTasks),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  _buildTabs(
    TaskListingViewmodel taskViewModel, {
    required String tabName,
    required int count,
    required int tabIndex,
  }) {
    final appColors = context.appColors;

    bool isActiveTab = taskViewModel.activeIndex == tabIndex;

    Color textColor = appColors.textOnSurface;
    Color chipColor =
        isActiveTab ? appColors.bgSecondaryMain : appColors.bgGraySubtle;

    return Row(
      children: [
        Tab(text: tabName),
        SizedBox(width: Dimens.spacing_8),
        (count == 0)
            ? SizedBox.shrink()
            : RoundedChipWidget(
                title: count.toString(),
                textColor: textColor,
                chipColor: chipColor,
                borderColor: chipColor,
              ),
      ],
    );
  }
}
