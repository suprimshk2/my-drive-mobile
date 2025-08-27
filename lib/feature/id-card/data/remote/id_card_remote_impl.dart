import 'package:mydrivenepal/data/remote/api_client.dart';

import '../../../../data/model/fetch_list_response.dart';
import '../../../../shared/constant/remote_api_constant.dart';

import '../model/id_card_response_model.dart';
import 'id_card_remote.dart';

class IdCardRemoteImpl implements IdCardRemote {
  final ApiClient _apiClient;

  IdCardRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<FetchListResponse<IdCardResponseModel>> fetchIdCardList(
      String memberId) async {
    final response = await _apiClient.get(
      RemoteAPIConstant.ID_CARD_LIST.replaceAll(':memberId', memberId),
    );
    final adoptResponse = FetchListResponse<IdCardResponseModel>.fromJson(
        response.data, IdCardResponseModel.fromJsonList);
    return adoptResponse;
  }
}
