import 'package:mydrivenepal/data/model/pagination_model.dart';
import 'package:mydrivenepal/shared/util/custom_functions.dart';

class EpisodeDetailRequestModel extends BasePaginationModel {
  String? keyword;
  String? status;

  EpisodeDetailRequestModel({
    this.keyword,
    this.status,
  });

  factory EpisodeDetailRequestModel.fromJson(Map<String, dynamic> json) =>
      EpisodeDetailRequestModel(
        keyword: json["keyword"] ?? "",
        status: json["status"] ?? "",
      );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    final Map<String, dynamic> fields = {
      "keyword": isNotEmpty(keyword) ? keyword : null,
      "status": isNotEmpty(status) ? status : null,
    };

    fields.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });

    return data;
  }
}
