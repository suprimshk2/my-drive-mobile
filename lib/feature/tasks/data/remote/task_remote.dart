import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/tasks/data/model/signature_request_model.dart';
import 'package:mydrivenepal/feature/tasks/data/model/signature_response_model.dart';
import 'package:mydrivenepal/feature/tasks/data/model/update_question_payload.dart';
import 'package:mydrivenepal/feature/tasks/data/model/update_task_status_payload.dart';
import 'package:mydrivenepal/feature/tasks/data/model/update_task_status_response.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';

import '../model/fetch_task_model.dart';

abstract class TaskRemote {
  Future<FetchListResponse<Task>> fetchAllTask(String userId, String? status);

  Future<UpdateTaskStatusResponse> updateTask(
      {required UpdateTaskStatusPayload payload});

  Future<UpdateTaskStatusResponse> updateQuestionTask(
      {required QuestionTaskPayload payload});

  Future<Task> fetchTaskById(FetchTaskModel fetchTaskModel);

  Future<SignatureResponseModel> requestSign(
      SignatureRequestModel requestModel);
}
