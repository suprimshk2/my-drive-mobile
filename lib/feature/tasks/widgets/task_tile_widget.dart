import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/tasks/constants/enums.dart';
import 'package:mydrivenepal/feature/tasks/data/model/status_model_for_callback.dart';
import 'package:mydrivenepal/feature/tasks/task_listing_viewmodel.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/events/task_completion_event_bus.dart';

import '../../../shared/shared.dart';
import '../../../widget/widget.dart';
import '../data/utils/task_utils.dart';

class TaskTileWidget extends StatefulWidget {
  final Task task;
  final bool showStatus;
  const TaskTileWidget({
    super.key,
    required this.task,
    this.showStatus = true,
  });

  @override
  State<TaskTileWidget> createState() => _TaskTileWidgetState();
}

class _TaskTileWidgetState extends State<TaskTileWidget> {
  final taskViewModel = locator<TaskListingViewmodel>();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    String title = widget.task.name ??
        widget.task.questions?.question ??
        widget.task.messages ??
        widget.task.qnrs?.name ??
        "";
    String taskType = widget.task.type ?? "";
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onTappedTask(context, widget.task),
      child: Container(
        decoration: BoxDecoration(
          color: appColors.primary.subtle,
          borderRadius: BorderRadius.circular(Dimens.spacing_8),
        ),
        padding: EdgeInsets.all(Dimens.spacing_large),
        margin: EdgeInsets.only(bottom: Dimens.spacing_8),
        child: Row(
          children: [
            _buildIcon(taskType: taskType),
            SizedBox(width: Dimens.spacing_8),
            Expanded(
              flex: 2,
              child: TextWidget(
                text: title,
                maxLines: 2,
                textAlign: TextAlign.left,
                textOverflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: appColors.gray.strong),
              ),
            ),
            if (widget.showStatus)
              Padding(
                // padding: EdgeInsets.only(left: 0),
                padding: EdgeInsets.only(left: Dimens.spacing_8),
                child: getTaskStatus(widget.task.status ?? "", context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon({required String taskType}) {
    final appColors = context.appColors;

    String image = "";
    switch (taskType) {
      case TaskTypes.question || TaskTypes.qnr:
        image = ImageConstants.IC_CHECKLIST;
      case TaskTypes.todo:
        image = ImageConstants.IC_CLIPBOARD_CHECK;
      case TaskTypes.signature:
        image = ImageConstants.IC_SIGNATURE;
      case TaskTypes.message:
        image = ImageConstants.IC_MESSAGE;
      default:
        image = ImageConstants.IC_CHECKLIST;
    }

    return SVGPictureWidget(
      image: image,
      color: appColors.bgPrimaryMain,
      height: Dimens.spacing_over_large,
      width: Dimens.spacing_over_large,
    );
  }

  _onTappedTask(
    BuildContext context,
    Task task,
  ) {
    switch (task.type) {
      case TaskTypes.question:
        context.pushNamed(
          AppRoute.question.name,
          extra: {
            // 'task': task,
            'isFromNotification': false,
            'taskId': task.id.toString(),
            'milestoneId': task.milestoneId.toString(),
            'episodeId': task.episodeId.toString(),
          },
        );
      case TaskTypes.qnr:
        context.pushNamed(AppRoute.qnr.name, extra: {
          // 'task': task,
          'isFromNotification': false,
          'taskId': task.id.toString(),
          'milestoneId': task.milestoneId.toString(),
          'episodeId': task.episodeId.toString(),
        });
      case TaskTypes.todo:
        if (task.isAcknowledgedRequired ?? false) {
          context.pushNamed(AppRoute.acknowledgement.name, extra: {
            'isFromNotification': false,
            'taskId': task.id.toString(),
            'milestoneId': task.milestoneId.toString(),
            'episodeId': task.episodeId.toString(),
          });
        } else {
          context.pushNamed(AppRoute.todo.name, extra: {
            'isFromNotification': false,
            'taskId': task.id.toString(),
            'milestoneId': task.milestoneId.toString(),
            'episodeId': task.episodeId.toString(),
          });
        }
      case TaskTypes.signature:
        context.pushNamed(AppRoute.signature.name, extra: {
          'isFromNotification': false,
          'taskId': task.id.toString(),
          'milestoneId': task.milestoneId.toString(),
          'episodeId': task.episodeId.toString(),
        });
      case TaskTypes.message:
        context.pushNamed(AppRoute.message.name, extra: {
          'isFromNotification': false,
          'taskId': task.id.toString(),
          'milestoneId': task.milestoneId.toString(),
          'episodeId': task.episodeId.toString(),
        });

      default:
        return;
    }
  }

  _onTaskCompleted({
    required TaskListingViewmodel taskListingViewmodel,
    required StatusModelForCallback statusModelForCallback,
  }) {
    taskListingViewmodel.removeTaskFromState(
      taskId: statusModelForCallback.taskId.toInt(),
    );

    // Emit event to global event bus instead of using callback
    taskCompletionEventBus.emit(statusModelForCallback);
  }
}
