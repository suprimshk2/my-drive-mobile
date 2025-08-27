import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/tasks/data/model/model.dart';
import 'package:mydrivenepal/feature/tasks/data/model/signature_request_model.dart';
import 'package:mydrivenepal/feature/tasks/data/model/signature_response_model.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';

abstract class TaskRepo {
  Future<FetchListResponse<Task>> fetchAllTask(String? status);
  Future<String> getUserName();

  Future<UpdateTaskStatusResponse> updateTask(
      {required UpdateTaskStatusPayload payload});

  Future<UpdateTaskStatusResponse> updateQuestionTask(
      {required QuestionTaskPayload payload});

  Future<Task> fetchTaskById(FetchTaskModel fetchTaskModel);

  Future<String> getUserId();

  Future<SignatureResponseModel> requestSign(
      SignatureRequestModel requestModel);
}
