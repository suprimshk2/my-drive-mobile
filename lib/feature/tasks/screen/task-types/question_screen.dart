import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/di.dart';
import 'package:mydrivenepal/feature/tasks/constants/enums.dart';
import 'package:mydrivenepal/feature/tasks/constants/form_builder_constants.dart';
import 'package:mydrivenepal/feature/tasks/data/model/status_model_for_callback.dart';
import 'package:mydrivenepal/feature/tasks/data/model/update_question_payload.dart';
import 'package:mydrivenepal/feature/tasks/widgets/checkbox_options_widget.dart';
import 'package:mydrivenepal/feature/tasks/widgets/radio_options_widget.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';
import 'package:mydrivenepal/navigation/navigation_routes.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/shimmer/task_shimmer.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydrivenepal/feature/tasks/constants/task_strings.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/shared/events/task_completion_event_bus.dart';

import '../../data/model/fetch_task_model.dart';
import '../../task_viewmodel.dart';

class QuestionScreen extends StatefulWidget {
  // final Task task;
  final String? taskId;
  final String? milestoneId;
  final String? episodeId;
  final bool isFromNotification;
  const QuestionScreen({
    super.key,
    // required this.task,
    required this.taskId,
    required this.milestoneId,
    required this.episodeId,
    required this.isFromNotification,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final TaskViewModel _taskViewModel = locator<TaskViewModel>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ScaffoldWidget(
      showBackButton: true,
      appbarTitle: TaskStrings.question,
      padding: Dimens.spacing_8,
      child: ChangeNotifierProvider(
        create: (_) => _taskViewModel,
        child: Consumer<TaskViewModel>(
          builder: (context, taskViewModel, child) {
            return ResponseBuilder<Task>(
              onLoading: () => TodoShimmerWidget(showShimmerForQuestion: true),
              response: taskViewModel.taskResponse,
              onData: (Task task) {
                String question = task.questions?.question ?? '';
                return Column(
                  children: [
                    SizedBox(height: Dimens.spacing_large),
                    TextWidget(
                      text: question,
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: appColors.textInverse),
                    ),
                    SizedBox(height: 20.h),
                    _buildOptionsWidget(taskViewModel: taskViewModel),
                    Spacer(),
                    _getButton(taskViewModel),
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

  _getButton(TaskViewModel taskViewModel) {
    bool hasSelectedOptions = taskViewModel.selectedOption.isNotEmpty ||
        taskViewModel.answerFromTextField.isNotEmpty;

    return Consumer<TaskViewModel>(builder: (context, taskViewModel, child) {
      bool isLoading = taskViewModel.updateQuestionTaskUsecase.isLoading;

      return RoundedFilledButtonWidget(
        context: context,
        isLoading: isLoading,
        enabled: hasSelectedOptions,
        label: TaskStrings.continueButton,
        onPressed: () => _onPressedNext(
          hasSelectedOptions: hasSelectedOptions,
          taskViewModel: taskViewModel,
        ),
      );
    });
  }

  _onPressedNext({
    required bool hasSelectedOptions,
    required TaskViewModel taskViewModel,
  }) async {
    if (hasSelectedOptions) {
      Question? question = taskViewModel.taskResponse.data?.questions;
      Task? task = taskViewModel.taskResponse.data;

      taskViewModel.answers.add(
        Answer(
          episodeId: int.parse(widget.episodeId ?? ""),
          milestoneId: int.parse(widget.milestoneId ?? ""),
          topicId: task?.topicId ?? task?.taskId ?? 0,
          taskId: task?.id,
          userId: int.parse(taskViewModel.userId),
          questionId: question?.id,
          answer: taskViewModel.answerFromTextField.isNotEmpty
              ? taskViewModel.answerFromTextField
              : null,
          answerOptionId: taskViewModel.selectedOption,
          questionName: question?.question,
          taskType: TaskTypeEnum.question.name,
          questionType: question?.questionTypes?.code,
          isDependent: task?.isDependent,
          /*
            todo: Need to discuss dependentOptionId with core team.
          */
          dependentOptionId: null,
        ),
      );

      // selectedOption = [];

      QuestionTaskPayload payload = QuestionTaskPayload(
        episodeId: int.parse(widget.episodeId ?? ""),
        milestoneId: int.parse(widget.milestoneId ?? ""),
        topicId: task?.topicId ?? task?.taskId ?? 0,
        type: TaskTypeEnum.question.name,
        answers: taskViewModel.answers,
        taskId: task?.id,
        taskName: task?.questions?.question,
      );

      await taskViewModel.updateQuestionTask(payload: payload);

      _observeResponse(taskViewModel);
    }
  }

  _observeResponse(TaskViewModel taskViewModel) {
    final updateQuestionTaskUsecase = taskViewModel.updateQuestionTaskUsecase;
    if (updateQuestionTaskUsecase.hasCompleted) {
      taskViewModel.selectedOption = [];

      final statusModelForCallback = StatusModelForCallback(
        taskId: updateQuestionTaskUsecase.data?.taskId ?? 0,
        taskStatus: updateQuestionTaskUsecase.data?.taskStatus ?? '',
        topicId: updateQuestionTaskUsecase.data?.topicId ?? 0,
        topicStatus: updateQuestionTaskUsecase.data?.topicStatus ?? '',
        milestoneId: updateQuestionTaskUsecase.data?.milestoneId ?? 0,
        milestoneStatus: updateQuestionTaskUsecase.data?.milestoneStatus ?? '',
        episodeId: updateQuestionTaskUsecase.data?.episodeId ?? 0,
        episodeStatus: updateQuestionTaskUsecase.data?.episodeStatus ?? '',
        // answerOptions: answerOptions,
      );

      taskCompletionEventBus.emit(statusModelForCallback);

      if (widget.isFromNotification) {
        navigatorKey.currentContext?.goNamed(AppRoute.landing.name);
      } else {
        context.pop();
      }
      showToast(context, TaskStrings.taskCompleted, isSuccess: true);
    } else {
      String errorMessage =
          updateQuestionTaskUsecase.exception ?? ErrorMessages.defaultError;

      showToast(context, errorMessage, isSuccess: false);
    }
  }

  _buildOptionsWidget({
    required TaskViewModel taskViewModel,
  }) {
    var question = taskViewModel.taskResponse.data?.questions;
    String taskType = question?.questionTypes?.code ?? "";

    List<QuestionOption> options = question?.questionOptions ?? [];

    List<num> selectedOption = taskViewModel.selectedOption;

    if (taskType == QuestionTypeEnum.TEXTFIELD.name) {
      return TextFieldWidget(
        maxLines: 5,
        hintText: TaskStrings.hintText,
        name: TaskFormBuilderConstants.questionTextField,
        textInputAction: TextInputAction.newline,
        onChanged: (value) {
          taskViewModel.answerFromTextField = value ?? "";
        },
      );
    }
    return ListView.builder(
      itemCount: options.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        QuestionOption option = options[index];
        String optionValue = option.optionValue ?? "";
        int optionId = option.id ?? 0;
        bool isSelected = selectedOption.contains(optionId);

        if (taskType == QuestionTypeEnum.RADIO.name) {
          return RadioOptionWidget(
            isSelected: isSelected,
            option: optionValue,
            onOptionSelected: (value) {
              taskViewModel.selectedOption = [optionId];
            },
          );
        } else if (taskType == QuestionTypeEnum.CHECKBOX.name) {
          return CheckboxOptionWidget(
            isSelected: isSelected,
            option: optionValue,
            onOptionSelected: (value) {
              if (isSelected) {
                selectedOption.remove(optionId);
              } else {
                selectedOption.add(optionId);
              }
              taskViewModel.selectedOption = selectedOption;
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  void _initializeData() async {
    await _taskViewModel.fetchTaskById(FetchTaskModel(
      taskId: widget.taskId ?? "",
      milestoneId: widget.milestoneId ?? "",
      episodeId: widget.episodeId ?? "",
      type: TaskTypeEnum.question.name,
    ));
    await _taskViewModel.getUserId();
  }
}
