import 'package:mydrivenepal/feature/communications/data/models/conversation_params.dart';
import 'package:mydrivenepal/feature/communications/data/models/conversation_response.dart';

abstract class CommsRemote {
  Future<ConversationResponse> getConversations(ConversationParams params);
}
