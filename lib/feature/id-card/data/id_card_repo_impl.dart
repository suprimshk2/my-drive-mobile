import '../../../data/model/fetch_list_response.dart';
import '../../feature.dart';

class IdCardRepoImpl implements IdCardRepo {
  final IdCardRemote _idCardRemote;
  final AuthLocal _authLocal;

  IdCardRepoImpl({
    required IdCardRemote idCardRemote,
    required AuthLocal authLocal,
  })  : _idCardRemote = idCardRemote,
        _authLocal = authLocal;

  @override
  Future<FetchListResponse<IdCardResponseModel>> fetchIdCardList() async {
    final memberId = await _authLocal.getMemberId();
    final response = await _idCardRemote.fetchIdCardList(memberId);
    return response;
  }
}
