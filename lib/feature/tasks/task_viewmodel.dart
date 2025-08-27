import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/tasks/constants/enums.dart';
import 'package:mydrivenepal/feature/tasks/data/model/signature_request_model.dart';
import 'package:mydrivenepal/feature/tasks/data/model/signature_response_model.dart';
import 'package:mydrivenepal/feature/tasks/data/task_repo.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'data/model/model.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepo _taskRepo;

  TaskViewModel({required TaskRepo taskRepo}) : _taskRepo = taskRepo;

  // data for questionnaire
  int _currentQuestionId = 0;
  int get currentQuestionId => _currentQuestionId;

  set currentQuestionId(int value) {
    _currentQuestionId = value;
    notifyListeners();
  }

  List<num> _selectedOption = [];
  List<num> get selectedOption => _selectedOption;
  set selectedOption(List<num> value) {
    _selectedOption = value;
    notifyListeners();
  }

  Map<int, String> questionMap = {};

  Map<int, List<Map<int, QuestionOption>>> optionsMap = {};

  Map<int, String> questionTypeMap = {};

  String _answerFromTextField = "";
  String get answerFromTextField => _answerFromTextField;
  set answerFromTextField(String value) {
    _answerFromTextField = value;
    notifyListeners();
  }

  List<Answer> answers = [];

  Map<num, List<num>> _selectedOptionIds = {};
  Map<num, List<num>> get selectedOptionIds => _selectedOptionIds;
  set selectedOptionIds(Map<num, List<num>> value) {
    _selectedOptionIds = value;
    notifyListeners();
  }

  Map<num, String> _selectedTextAnswers = {};
  Map<num, String> get selectedTextAnswers => _selectedTextAnswers;
  set selectedTextAnswers(Map<num, String> value) {
    _selectedTextAnswers = value;
    notifyListeners();
  }

  void _initializeDataForQnrs({
    required List<QnrsQues> listOfQnrs,
  }) {
    for (final qnrQues in listOfQnrs) {
      final question = qnrQues.question;
      if (question == null) continue;

      final questionId = question.id ?? 0;
      final questionType = question.questionTypes?.code ?? "";

      // Questions map
      questionMap[questionId] = question.question ?? "";

      // Question type map
      questionTypeMap[questionId] = questionType;

      // Options map
      optionsMap[questionId] =
          question.questionOptions?.map((opt) => {opt.id ?? 0: opt}).toList() ??
              [];

      // Mapping answers based on type
      final answerOptions = question.ansOpt ?? [];

      if (answerOptions.isNotEmpty) {
        if (questionType == QuestionTypeEnum.TEXTFIELD.name) {
          // For TEXTFIELD type, answerOptions will have only one element
          selectedTextAnswers[questionId] = answerOptions.first.answer ?? "";
        } else {
          selectedOptionIds[questionId] = answerOptions
              .map((e) => e.answerOptionId ?? 0)
              .where((id) => id != 0)
              .toList();
        }
      }
    }

    // initializing current question
    currentQuestionId = questionMap.keys.first;
    _setSelectedOptions(currentQuestionId);
  }

  String getQuestionNumber() {
    return 'Question ${getIndexOfCurrentQuestion() + 1} of ${questionMap.length}';
  }

  int getIndexOfCurrentQuestion() {
    return questionMap.keys.toList().indexOf(currentQuestionId);
  }

  int getNextQuestionId() {
    return questionMap.keys.toList().elementAt(getIndexOfCurrentQuestion() + 1);
  }

  int getPreviousQuestionId() {
    return questionMap.keys.toList().elementAt(getIndexOfCurrentQuestion() - 1);
  }

  void setCurrentQuestion(int questionId) {
    currentQuestionId = questionId;
    _setSelectedOptions(currentQuestionId);
  }

  void _setSelectedOptions(int currentQuestionId) {
    final questionType = questionTypeMap[currentQuestionId] ?? "";
    if (questionType == QuestionTypeEnum.TEXTFIELD.name) {
      answerFromTextField = selectedTextAnswers[currentQuestionId] ?? "";
    } else {
      selectedOption = selectedOptionIds[currentQuestionId]?.toList() ?? [];
    }
  }

  // data for questions

  String question = '';

  List<QuestionOption> options = [];

  String questionTypeCode = '';

  /// Common data variabled for question and qnrs
  // List<num> selectedOption = [];
  // String answerFromTextField = "";
  // List<Answer> answers = [];

  Map<num, num> selectedAnswers = {};

  _initializeDataForQuestions({required Question question}) {
    options =
        question.questionOptions?.map((options) => options).toList() ?? [];
    questionTypeCode = question.questionTypes?.code ?? '';

    final answerOptions = question.ansOpt ?? [];

    for (final answerOption in answerOptions) {
      selectedAnswers[answerOption.questionId ?? 0] =
          answerOption.answerOptionId ?? 0;
    }

    String questionType = question.questionTypes?.code ?? "";
    int questionId = question.id ?? 0;

    if (answerOptions.isNotEmpty) {
      if (questionType == QuestionTypeEnum.TEXTFIELD.name) {
        // For TEXTFIELD type, answerOptions will have only one element
        selectedTextAnswers[questionId] = answerOptions.first.answer ?? "";
      } else {
        selectedOptionIds[questionId] = answerOptions
            .map((e) => e.answerOptionId ?? 0)
            .where((id) => id != 0)
            .toList();
      }
    }

    _setSelectedOptions(questionId);
  }

  Response<Task> _taskResponse = Response<Task>();
  Response<Task> get taskResponse => _taskResponse;
  set taskResponse(Response<Task> response) {
    _taskResponse = response;
    notifyListeners();
  }

  Future<void> fetchTaskById(FetchTaskModel fetchTaskModel) async {
    try {
      taskResponse = Response.loading();
      final response = await _taskRepo.fetchTaskById(fetchTaskModel);

      String taskType = (response.type ?? "").toLowerCase();

      if (taskType == TaskTypeEnum.questionnaire.name.toLowerCase()) {
        // method to get data for qnrs
        _initializeDataForQnrs(
          listOfQnrs: response.qnrs?.qnrsQues ?? [],
        );
      } else if (taskType == TaskTypeEnum.question.name.toLowerCase()) {
        // method to get data for questions
        _initializeDataForQuestions(question: response.questions ?? Question());
      }
      taskResponse = Response.complete(response);
    } catch (exception) {
      taskResponse = Response.error(exception);
    }
  }

  String userId = "";

  Future<void> getUserId() async {
    userId = await _taskRepo.getUserId();
  }

  Response<UpdateTaskStatusResponse> _updateTaskUsecase =
      Response<UpdateTaskStatusResponse>();
  Response<UpdateTaskStatusResponse> get updateTaskUsecase =>
      _updateTaskUsecase;

  set updateTaskUsecase(Response<UpdateTaskStatusResponse> response) {
    _updateTaskUsecase = response;
    notifyListeners();
  }

  Future<void> updateTask({
    required UpdateTaskStatusPayload payload,
  }) async {
    updateTaskUsecase = Response.loading();
    try {
      final response = await _taskRepo.updateTask(payload: payload);
      updateTaskUsecase = Response.complete(response);
    } catch (exception) {
      updateTaskUsecase = Response.error(exception);
    }
  }

  Response<UpdateTaskStatusResponse> _updateQuestionTaskUsecase =
      Response<UpdateTaskStatusResponse>();
  Response<UpdateTaskStatusResponse> get updateQuestionTaskUsecase =>
      _updateQuestionTaskUsecase;

  set updateQuestionTaskUsecase(Response<UpdateTaskStatusResponse> response) {
    _updateQuestionTaskUsecase = response;
    notifyListeners();
  }

  Future<void> updateQuestionTask({
    required QuestionTaskPayload payload,
  }) async {
    updateQuestionTaskUsecase = Response.loading();
    try {
      final response = await _taskRepo.updateQuestionTask(payload: payload);
      updateQuestionTaskUsecase = Response.complete(response);
    } catch (exception) {
      updateQuestionTaskUsecase = Response.error(exception);
    }
  }

  Response<SignatureResponseModel> _requestSignUseCase =
      Response<SignatureResponseModel>();
  Response<SignatureResponseModel> get requestSignUseCase =>
      _requestSignUseCase;

  set requestSignUseCase(Response<SignatureResponseModel> response) {
    _requestSignUseCase = response;
    notifyListeners();
  }

  Future<void> requestSign(SignatureRequestModel requestModel) async {
    requestSignUseCase = Response.loading();
    try {
      final response = await _taskRepo.requestSign(requestModel);
      requestSignUseCase = Response.complete(response);
    } catch (exception) {
      requestSignUseCase = Response.error(exception);
    }
  }
}
