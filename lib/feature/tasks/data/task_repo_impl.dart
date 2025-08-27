import 'package:mydrivenepal/feature/tasks/data/model/fetch_task_model.dart';
import 'package:mydrivenepal/feature/tasks/data/model/signature_request_model.dart';
import 'package:mydrivenepal/feature/tasks/data/model/signature_response_model.dart';

import '../../../data/model/fetch_list_response.dart';
import '../../../shared/helper/jwt_helper.dart';
import 'package:mydrivenepal/data/model/model.dart';

import 'package:mydrivenepal/feature/tasks/data/model/update_question_payload.dart';

import 'package:mydrivenepal/feature/tasks/data/model/update_task_status_payload.dart';
import 'package:mydrivenepal/feature/tasks/data/model/update_task_status_response.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';

import '../../auth/auth.dart';
import 'remote/remote.dart';
import 'task_repo.dart';

class TaskRepoImpl implements TaskRepo {
  final TaskRemote _taskRemote;
  final AuthLocal _authLocal;

  TaskRepoImpl({
    required TaskRemote taskRemote,
    required AuthLocal authLocal,
  })  : _taskRemote = taskRemote,
        _authLocal = authLocal;

  @override
  Future<FetchListResponse<Task>> fetchAllTask(String? status) async {
    final userId = await _authLocal.getUserId();
    final response = await _taskRemote.fetchAllTask(userId.toString(), status);
    return response;
  }

  @override
  Future<String> getUserName() async {
    final token = await _authLocal.getAccessToken();
    final name = JwtHelper.decodeJwt(token);
    return '${name?['firstName']} ${name?['lastName']}'; // todo: refactor this
  }

  @override
  Future<UpdateTaskStatusResponse> updateQuestionTask({
    required QuestionTaskPayload payload,
  }) async {
    final response = await _taskRemote.updateQuestionTask(payload: payload);
    return response;
  }

  @override
  Future<UpdateTaskStatusResponse> updateTask(
      {required UpdateTaskStatusPayload payload}) async {
    final response = await _taskRemote.updateTask(payload: payload);
    return response;
  }

  @override
  Future<Task> fetchTaskById(FetchTaskModel fetchTaskModel) async {
    final response = await _taskRemote.fetchTaskById(fetchTaskModel);
    return response;
  }

  @override
  Future<String> getUserId() async {
    return await _authLocal.getUserId();
  }

  @override
  Future<SignatureResponseModel> requestSign(
      SignatureRequestModel requestModel) {
    return _taskRemote.requestSign(requestModel);
  }
}
