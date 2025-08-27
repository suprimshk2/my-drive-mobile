import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/tasks/constants/enums.dart';
import 'package:mydrivenepal/feature/tasks/constants/form_builder_constants.dart';
import 'package:mydrivenepal/feature/tasks/constants/task_strings.dart';
import 'package:mydrivenepal/feature/tasks/data/model/status_model_for_callback.dart';
import 'package:mydrivenepal/feature/tasks/data/model/update_question_payload.dart';
import 'package:mydrivenepal/feature/tasks/widgets/checkbox_options_widget.dart';
import 'package:mydrivenepal/feature/tasks/widgets/radio_options_widget.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/button/variants/back_navigation_button.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/shimmer/task_shimmer.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/shared/events/task_completion_event_bus.dart';

import '../../../../navigation/navigation.dart';
import '../../data/model/fetch_task_model.dart';
import '../../task_viewmodel.dart';

class QuestionnaireScreen extends StatefulWidget {
  final String taskId;
  final String milestoneId;
  final String episodeId;
  final bool isFromNotification;
  const QuestionnaireScreen({
    super.key,
    required this.taskId,
    required this.milestoneId,
    required this.episodeId,
    required this.isFromNotification,
  });

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
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
      padding: Dimens.spacing_8,
      bottom: 0,
      appbarTitle: TaskStrings.questionnaire,
      resizeToAvoidBottomInset: false,
      child: ChangeNotifierProvider(
        create: (_) => _taskViewModel,
        child: Consumer<TaskViewModel>(
          builder: (
            context,
            taskViewModelValue,
            _,
          ) {
            return ResponseBuilder<Task>(
              onLoading: () => TodoShimmerWidget(showShimmerForQuestion: true),
              response: taskViewModelValue.taskResponse,
              onData: (Task task) {
                final questionMap = taskViewModelValue.questionMap;
                int currentQuestionId = taskViewModelValue.currentQuestionId;
                return Column(
                  children: [
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: Dimens.spacing_8),
                          _buildProgressWidget(context, taskViewModelValue),
                          TextWidget(
                            text: questionMap[currentQuestionId] ?? "",
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: appColors.textInverse),
                          ),
                          SizedBox(height: Dimens.spacing_large),
                          // Options
                          buildOptions(taskViewModel: taskViewModelValue),
                        ],
                      ),
                    ),
                    Spacer(),
                    // Next button
                    _getbutton(context, taskViewModelValue)
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _initializeData() async {
    await _taskViewModel.fetchTaskById(
      FetchTaskModel(
        taskId: widget.taskId,
        milestoneId: widget.milestoneId,
        episodeId: widget.episodeId,
        type: TaskTypeEnum.questionnaire.name,
      ),
    );
    await _taskViewModel.getUserId();
  }

  _getbutton(
    BuildContext context,
    TaskViewModel taskViewModel,
  ) {
    final task = taskViewModel.taskResponse.data;
    bool isLoading = taskViewModel.updateQuestionTaskUsecase.isLoading;
    int currentQuestionId = taskViewModel.currentQuestionId;
    bool hasSelectedOptions = taskViewModel.selectedOption.isNotEmpty ||
        taskViewModel.answerFromTextField.isNotEmpty;
    Map<int, String> questionMap = taskViewModel.questionMap;
    Map<int, String> questionTypeMap = taskViewModel.questionTypeMap;
    bool isFirstQuestion = currentQuestionId == questionMap.keys.first;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacing_8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 32.h),
          RoundedFilledButtonWidget(
            context: context,
            isLoading: isLoading,
            label: "",
            enabled: hasSelectedOptions,
            onPressed: () => _onPressedNext(
              hasSelectedOptions: hasSelectedOptions,
              taskViewModel: taskViewModel,
              questionMap: questionMap,
              questionTypeMap: questionTypeMap,
              task: task ?? Task(),
              episodeId: int.parse(widget.episodeId),
              milestoneId: int.parse(widget.milestoneId),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  text: TaskStrings.next,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: AppColors.white),
                ),
                SizedBox(width: 10.h),
                ImageWidget(
                  imagePath: ImageConstants.IC_ARROW_RIGHT,
                  height: 20.w,
                  width: 20.w,
                  color: AppColors.white,
                  isSvg: true,
                ),
              ],
            ),
          ),
          if (!isFirstQuestion) ...[
            SizedBox(height: Dimens.spacing_large),
            BackNavigationWidget(
              buttonLabel: TaskStrings.goBack,
              onPressed: () => onPressedGoBack(taskViewModel),
            ),
          ],
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  _onPressedNext({
    required bool hasSelectedOptions,
    required TaskViewModel taskViewModel,
    required Map<int, String> questionMap,
    required Map<int, String> questionTypeMap,
    required Task task,
    required num milestoneId,
    required num episodeId,
  }) async {
    int currentQuestionId = taskViewModel.currentQuestionId;
    if (hasSelectedOptions) {
      // _setSelectedOptions(currentQuestionId, clearValues: false);
      final questionType = questionTypeMap[currentQuestionId] ?? "";
      if (questionType == QuestionTypeEnum.TEXTFIELD.name) {
        taskViewModel.selectedTextAnswers[currentQuestionId] =
            taskViewModel.answerFromTextField;
      } else {
        taskViewModel.selectedOptionIds[currentQuestionId] =
            taskViewModel.selectedOption;
      }

      taskViewModel.answers.add(
        Answer(
          episodeId: episodeId,
          milestoneId: milestoneId,
          topicId: task.topicId ?? task.taskId ?? 0,
          taskId: task.id ?? 0,
          userId: task.userId ?? 0,
          questionId: currentQuestionId,
          answer: taskViewModel.answerFromTextField.isNotEmpty
              ? taskViewModel.answerFromTextField
              : null,
          answerOptionId: taskViewModel.selectedOption,
          questionName: questionMap[currentQuestionId] ?? "",
          taskType: TaskTypeEnum.questionnaire.name,
          questionType: questionTypeMap[currentQuestionId] ?? "",
          isDependent: task.isDependent,
          /*
            todo: Need to discuss dependentOptionId with core team.
          */
          dependentOptionId: null,
        ),
      );

      // _appendAnswerOptions(questionTypeMap, task);

      int currentQuestionIndex = taskViewModel.getIndexOfCurrentQuestion();

      int totalQuestionsByIndex = questionMap.length - 1;

      if (currentQuestionIndex == totalQuestionsByIndex) {
        QuestionTaskPayload payload = QuestionTaskPayload(
          episodeId: int.parse(widget.episodeId),
          milestoneId: int.parse(widget.milestoneId),
          topicId: task.topicId ?? task.taskId ?? 0,
          type: TaskTypeEnum.questionnaire.name,
          answers: taskViewModel.answers,
          taskId: task.id,
          // TODO: Need to verify this
          taskName: task.name ?? task.qnrs?.name ?? "",
        );

        await taskViewModel.updateQuestionTask(payload: payload);

        _observeResponse(taskViewModel);
      } else {
        taskViewModel.setCurrentQuestion(taskViewModel.getNextQuestionId());
      }
    }
  }

  _observeResponse(TaskViewModel taskViewModel) {
    final updateQuestionTaskUsecase = taskViewModel.updateQuestionTaskUsecase;

    if (taskViewModel.updateQuestionTaskUsecase.hasCompleted) {
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

      // Emit event to global event bus instead of using callback
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

  onPressedGoBack(TaskViewModel taskViewModel) {
    if (taskViewModel.getIndexOfCurrentQuestion() !=
        taskViewModel.questionMap.keys.last) {
      taskViewModel.setCurrentQuestion(taskViewModel.getPreviousQuestionId());
    }
  }

  buildOptions({
    required TaskViewModel taskViewModel,
  }) {
    int currentQuestionId = taskViewModel.currentQuestionId;
    String taskType = taskViewModel.questionTypeMap[currentQuestionId] ?? "";
    Map<int, List<Map<int, QuestionOption>>> optionsMap =
        taskViewModel.optionsMap;

    Map<num, String> selectedTextAnswers = taskViewModel.selectedTextAnswers;

    List<num> selectedOption = taskViewModel.selectedOption;

    if (taskType == QuestionTypeEnum.TEXTFIELD.name) {
      return TextFieldWidget(
        key: Key(currentQuestionId.toString()),
        maxLines: 5,
        hintText: TaskStrings.hintText,
        name: TaskFormBuilderConstants.questionTextField,
        textInputAction: TextInputAction.newline,
        initialValue: selectedTextAnswers[currentQuestionId] ?? "",
        onChanged: (value) {
          taskViewModel.answerFromTextField = value ?? "";
        },
      );
    }
    return ListView.builder(
      itemCount: optionsMap[currentQuestionId]?.length ?? 0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // Get the option map at the current index
        Map<int, QuestionOption> optionMap =
            optionsMap[currentQuestionId]?[index] ?? {};
        String optionValue = optionMap.values.first.optionValue ?? "";
        int optionId = optionMap.keys.first;
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

  _buildProgressWidget(BuildContext context, TaskViewModel taskViewModel) {
    final appColors = context.appColors;

    double progress = (taskViewModel.getIndexOfCurrentQuestion() + 1) /
        taskViewModel.questionMap.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: appColors.gray.soft.withOpacity(0.5),
          valueColor: AlwaysStoppedAnimation<Color>(appColors.bgPrimaryMain),
          minHeight: Dimens.spacing_12,
          borderRadius: BorderRadius.circular(Dimens.spacing_large),
        ),
        SizedBox(height: 32.h),
        TextWidget(
          text: taskViewModel.getQuestionNumber(),
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: appColors.textPrimary),
        ),
        SizedBox(height: Dimens.spacing_large),
      ],
    );
  }

  // _appendAnswerOptions(Map<int, String> questionTypeMap, Task task) {
  //   if (questionTypeMap[currentQuestionId] == QuestionTypeEnum.TEXTFIELD.name) {
  //     answerOptions.add(
  //       AnswerOption(
  //         questionId: currentQuestionId,
  //         episodeId: task.episodeId ?? 0,
  //         userId: task.userId ?? 0,
  //         answer: answerFromTextField.isNotEmpty ? answerFromTextField : null,
  //         answerOptionId: null,
  //       ),
  //     );
  //   } else {
  //     for (var option in selectedOption) {
  //       answerOptions.add(
  //         AnswerOption(
  //           questionId: currentQuestionId,
  //           episodeId: task.episodeId ?? 0,
  //           userId: task.userId ?? 0,
  //           answer: answerFromTextField.isNotEmpty ? answerFromTextField : null,
  //           answerOptionId: option,
  //         ),
  //       );
  //     }
  //   }
  // }
}
