import '../../../data/model/model.dart';
import 'model/model.dart';

abstract class TopicRepo {
  Future<FetchListResponse<Topic>> fetchTopicList(
      {required String milestoneId, required String episodeId});
}
