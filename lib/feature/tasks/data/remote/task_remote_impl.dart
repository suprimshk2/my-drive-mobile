import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/data/remote/api_client.dart';
import 'package:mydrivenepal/feature/tasks/data/model/fetch_task_model.dart';
import 'package:mydrivenepal/feature/tasks/data/model/signature_request_model.dart';
import 'package:mydrivenepal/feature/tasks/data/model/signature_response_model.dart';
import 'package:mydrivenepal/feature/tasks/data/model/update_question_payload.dart';
import 'package:mydrivenepal/feature/tasks/data/model/update_task_status_payload.dart';
import 'package:mydrivenepal/feature/tasks/data/model/update_task_status_response.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';

import '../../../../shared/constant/remote_api_constant.dart';

import 'task_remote.dart';

class TaskRemoteImpl implements TaskRemote {
  final ApiClient _apiClient;

  TaskRemoteImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<FetchListResponse<Task>> fetchAllTask(
      String userId, String? status) async {
    final response = await _apiClient.get(
      RemoteAPIConstant.ALL_TASK.replaceAll(':userId', userId),
      queryParameters: {"status": status?.toLowerCase()},
    );

    final adoptResponse =
        FetchListResponse<Task>.fromJson(response.data, Task.fromJsonList);
    return adoptResponse;
  }

  @override
  Future<UpdateTaskStatusResponse> updateQuestionTask({
    required QuestionTaskPayload payload,
  }) async {
    String url = RemoteAPIConstant.UPDATE_QUESTION;

    final response = await _apiClient.post(
      url,
      payload.toJson(),
    );

    return UpdateTaskStatusResponse.fromJson(response.data['data']);
  }

  @override
  Future<UpdateTaskStatusResponse> updateTask(
      {required UpdateTaskStatusPayload payload}) async {
    String url = RemoteAPIConstant.UPDATE_TASK;

    final response = await _apiClient.post(
      url,
      payload.toJson(),
    );

    return UpdateTaskStatusResponse.fromJson(response.data);
  }

  @override
  Future<Task> fetchTaskById(FetchTaskModel fetchTaskModel) async {
    String url = RemoteAPIConstant.GET_TASK_BY_ID
        .replaceAll(':taskId', fetchTaskModel.taskId)
        .replaceAll(':milestoneId', fetchTaskModel.milestoneId)
        .replaceAll(':type', fetchTaskModel.type);

    final response = await _apiClient.get(url);

    return Task.fromJson(response.data);
  }

  @override
  Future<SignatureResponseModel> requestSign(
      SignatureRequestModel requestModel) async {
    String url = RemoteAPIConstant.REQUEST_SIGN
        .replaceAll(':episodeId', requestModel.episodeId)
        .replaceAll(':topicId', requestModel.topicId);

    final queryParams = {"taskTodoId": requestModel.taskTodoId};

    final response = await _apiClient.get(url, queryParameters: queryParams);

    return SignatureResponseModel.fromJson(
        response.data['data']); //TODO: refactor response json
  }
}
