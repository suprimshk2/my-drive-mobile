import 'package:mydrivenepal/feature/info/constant/enums.dart';

import '../../../data/model/model.dart';
import 'model/model.dart';
import 'remote/remote.dart';
import 'info_repo.dart';

class InfoRepoImpl implements InfoRepo {
  final InfoRemote _infoRemote;

  InfoRepoImpl({required InfoRemote infoRemote}) : _infoRemote = infoRemote;

  @override
  Future<FetchListResponse<InfoResponseModel>> fetchInfoList(
      PaginationRequestModel pagination,
      InformationType informationType) async {
    final response =
        await _infoRemote.fetchInfoList(pagination, informationType);
    return response;
  }
}
