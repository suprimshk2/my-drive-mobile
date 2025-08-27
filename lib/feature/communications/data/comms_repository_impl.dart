import 'package:mydrivenepal/feature/communications/data/comms_repository.dart';
import 'package:mydrivenepal/feature/communications/data/models/conversation_params.dart';
import 'package:mydrivenepal/feature/communications/data/models/conversation_response.dart';
import 'package:mydrivenepal/feature/communications/data/remote/comms_remote.dart';

class CommsRepositoryImpl extends CommsRepository {
  final CommsRemote _commsRemote;

  CommsRepositoryImpl({required CommsRemote commsRemote})
      : _commsRemote = commsRemote;

  @override
  Future<ConversationResponse> getConversations(
      ConversationParams params) async {
    final response = await _commsRemote.getConversations(params);
    return response;
  }
}
