import '../../shared/shared.dart';

class BasePaginationModel {
  int page;
  int limit;

  BasePaginationModel({
    this.page = 0,
    this.limit = PAGINATION_LIMIT,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    final Map<String, dynamic> fields = {
      "page": page,
      "limit": limit,
    };
    fields.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    return data;
  }
}

class PaginationRequestModel extends BasePaginationModel {
  String? keyword;
  String? sortBy;
  String? sortOrder;

  PaginationRequestModel({
    super.page,
    super.limit,
    this.keyword,
    this.sortBy,
    this.sortOrder,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();

    final Map<String, dynamic> fields = {
      "keyword": keyword,
      "sortBy": sortBy,
      "sortOrder": sortOrder,
    };
    fields.forEach((key, value) {
      if (value != null && value.isNotEmpty) {
        data[key] = value;
      }
    });
    return data;
  }
}
