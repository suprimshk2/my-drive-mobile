import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/tasks/constants/enums.dart';
import 'package:mydrivenepal/feature/tasks/constants/task_strings.dart';
import 'package:mydrivenepal/feature/tasks/data/model/status_model_for_callback.dart';
import 'package:mydrivenepal/feature/tasks/data/model/update_task_status_payload.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/shimmer/task_shimmer.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/shared/events/task_completion_event_bus.dart';

import '../../../../navigation/navigation.dart';
import '../../data/model/fetch_task_model.dart';
import '../../task_viewmodel.dart';

class MessageScreen extends StatefulWidget {
  final String? taskId;
  final String? milestoneId;
  final String? episodeId;
  final bool isFromNotification;
  const MessageScreen({
    super.key,
    required this.taskId,
    required this.milestoneId,
    required this.episodeId,
    required this.isFromNotification,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
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
      taskId: widget.taskId ?? "",
      milestoneId: widget.milestoneId ?? "",
      episodeId: widget.episodeId ?? "",
      type: TaskTypeEnum.message.name,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      showBackButton: true,
      padding: Dimens.spacing_8,
      appbarTitle: TaskStrings.todo,
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
              onLoading: () => TodoShimmerWidget(showShimmerForTodo: true),
              onData: (Task task) {
                var title = task.messages ?? '';
                String buttonLabel = TaskStrings.continueButton;

                bool isLoading = taskViewmodel.updateTaskUsecase.isLoading;

                return Column(
                  children: [
                    SizedBox(height: Dimens.spacing_large),
                    TextWidget(
                      text: title,
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    Spacer(),
                    RoundedFilledButtonWidget(
                      context: context,
                      isLoading: isLoading,
                      label: buttonLabel,
                      onPressed: () => _onTappedButton(taskViewmodel),
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

  _onTappedButton(TaskViewModel taskViewModel) {
    _handleUpdateTask(taskViewModel);
  }

  _handleUpdateTask(TaskViewModel taskViewModel) async {
    final currentContext = context;
    final task = taskViewModel.taskResponse.data;
    final updateTaskPayload = UpdateTaskStatusPayload(
      id: task?.id ?? 0,
      type: TaskTypeEnum.message.name,
      episodeId: int.parse(widget.episodeId ?? '0'),
      milestoneId: widget.milestoneId ?? '0',
      /*
        todo: Need to discuss messageTitle with core team.
      */
      messageTitle: task?.messages ?? '',
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
