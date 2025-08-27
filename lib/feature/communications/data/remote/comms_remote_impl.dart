import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mydrivenepal/data/remote/api_client.dart';
import 'package:mydrivenepal/feature/communications/data/models/conversation_params.dart';
import 'package:mydrivenepal/feature/communications/data/models/conversation_response.dart';
import 'package:mydrivenepal/feature/communications/data/remote/comms_remote.dart';
import 'package:mydrivenepal/shared/constant/remote_api_constant.dart';

class CommsRemoteImpl extends CommsRemote {
  final ApiClient _apiClient;

  CommsRemoteImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<ConversationResponse> getConversations(
      ConversationParams params) async {
    String url = dotenv.env["COMET_CHAT_BASE_URL"]!;
    String path = RemoteAPIConstant.CONVERSATION;

    final response = await _apiClient.get(
      path,
      queryParameters: params.toJson(),
      url: url,
      updateBaseUrl: true,
    );

    return ConversationResponse.fromJson(response.data);
  }
}
