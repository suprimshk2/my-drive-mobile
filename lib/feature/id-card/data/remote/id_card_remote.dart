import '../../../../data/model/fetch_list_response.dart';

import '../model/id_card_response_model.dart';

abstract class IdCardRemote {
  Future<FetchListResponse<IdCardResponseModel>> fetchIdCardList(
      String memberId);
}
