import '../../../data/model/fetch_list_response.dart';

import 'model/id_card_response_model.dart';

abstract class IdCardRepo {
  Future<FetchListResponse<IdCardResponseModel>> fetchIdCardList();
}
