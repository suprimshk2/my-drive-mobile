import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/tasks/constants/enums.dart';
import 'package:mydrivenepal/feature/tasks/constants/task_strings.dart';
import 'package:mydrivenepal/feature/tasks/data/model/status_model_for_callback.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/checkbox/custom_checkbox.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/shimmer/task_shimmer.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/shared/events/task_completion_event_bus.dart';

import '../../../../navigation/navigation.dart';
import '../../data/model/model.dart';
import '../../task_viewmodel.dart';

class AcknowledgementScreen extends StatefulWidget {
  final String taskId;
  final String milestoneId;
  final String episodeId;
  final bool isFromNotification;

  const AcknowledgementScreen({
    super.key,
    required this.taskId,
    required this.milestoneId,
    required this.episodeId,
    required this.isFromNotification,
  });

  @override
  State<AcknowledgementScreen> createState() => _AcknowledgementScreenState();
}

class _AcknowledgementScreenState extends State<AcknowledgementScreen> {
  final TaskViewModel _taskViewModel = locator<TaskViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
  }

  Future<void> getData() async {
    await _taskViewModel.fetchTaskById(FetchTaskModel(
      taskId: widget.taskId,
      milestoneId: widget.milestoneId,
      episodeId: widget.episodeId,
      type: TaskTypeEnum.todo.name,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ScaffoldWidget(
      showBackButton: true,
      padding: Dimens.spacing_8,
      appbarTitle: TaskStrings.acknowledgement,
      child: ChangeNotifierProvider(
        create: (_) => _taskViewModel,
        child: Consumer<TaskViewModel>(
          builder: (
            context,
            taskViewmodel,
            _,
          ) {
            return ResponseBuilder<Task>(
              response: taskViewmodel.taskResponse,
              onRetry: () {
                getData();
              },
              onLoading: () => TodoShimmerWidget(
                showShimmerForTodo: true,
                showShimmerForAcknowledgement: true,
              ),
              onData: (Task task) {
                bool isLoading = taskViewmodel.updateTaskUsecase.isLoading;
                final acknowledgementString = task.name ?? '';
                return Column(
                  children: [
                    SizedBox(height: Dimens.spacing_8),
                    TextWidget(
                      text: acknowledgementString,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: appColors.textInverse),
                    ),
                    Spacer(),
                    _buildAgreementWidget(context),
                    SizedBox(height: 32.h),
                    RoundedFilledButtonWidget(
                      context: context,
                      isLoading: isLoading,
                      label: TaskStrings.continueButton,
                      enabled: hasAcknowledged,
                      onPressed: () => _onTappedButton(
                          hasAcknowledged, taskViewmodel, taskViewmodel),
                    ),
                    SizedBox(height: 32.h),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // todo: handle from viewmodel.
  bool hasAcknowledged = false;

  Widget _buildAgreementWidget(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCheckbox(
            value: hasAcknowledged,
            onChanged: (value) {
              setState(() {
                hasAcknowledged = value ?? false;
              });
            }),
        SizedBox(width: Dimens.spacing_8),
        Flexible(
          child: TextWidget(
            textAlign: TextAlign.left,
            text: TaskStrings.acknowledgementDescription,
            style: Theme.of(context)
                .textTheme
                .bodyText
                .copyWith(color: appColors.textInverse),
          ),
        ),
      ],
    );
  }

  _onTappedButton(bool hasAcknowledged, TaskViewModel taskViewModel,
      TaskViewModel globalTaskViewModel) async {
    if (hasAcknowledged) {
      final currentContext = context;
      final task = globalTaskViewModel.taskResponse.data;
      final updateTaskPayload = UpdateTaskStatusPayload(
        id: task?.id,
        type: TaskTypeEnum.todo.name,
        episodeId: int.parse(widget.episodeId),
        milestoneId: widget.milestoneId,
        /*
          todo: Need to discuss messageTitle with core team.
        */
        messageTitle: null,
      );

      await taskViewModel.updateTask(payload: updateTaskPayload);

      final updateTaskUsecase = taskViewModel.updateTaskUsecase;

      if (!currentContext.mounted) return;

      if (updateTaskUsecase.hasCompleted && updateTaskUsecase.data != null) {
        final statusModelForCallback = StatusModelForCallback(
          taskId: updateTaskUsecase.data?.taskId ?? 0,
          taskStatus: updateTaskUsecase.data?.taskStatus ?? '',
          topicId: updateTaskUsecase.data?.topicId ?? 0,
          topicStatus: updateTaskUsecase.data?.topicStatus ?? '',
          milestoneId: updateTaskUsecase.data?.milestoneId ?? 0,
          milestoneStatus: updateTaskUsecase.data?.milestoneStatus ?? '',
          episodeId: updateTaskUsecase.data?.episodeId ?? 0,
          episodeStatus: updateTaskUsecase.data?.episodeStatus ?? '',
          // answerOptions: [],
        );

        taskCompletionEventBus.emit(statusModelForCallback);

        if (widget.isFromNotification) {
          navigatorKey.currentContext?.goNamed(AppRoute.landing.name);
        } else {
          currentContext.pop();
        }
        showToast(currentContext, TaskStrings.taskCompleted, isSuccess: true);
      } else {
        String errorMessage = taskViewModel.updateTaskUsecase.exception ??
            ErrorMessages.defaultError;

        showToast(currentContext, isSuccess: false, errorMessage);
      }
    }
  }
}
