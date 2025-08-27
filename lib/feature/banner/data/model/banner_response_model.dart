class BannerResponseModel {
  final int? id;
  final String? bannerId;
  final String? title;
  final String? content;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final DateTime? createdAt;
  final CreatedBy? created;
  final DateTime? updatedAt;
  final String? updatedBy;

  BannerResponseModel({
    this.id,
    this.bannerId,
    this.title,
    this.content,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.created,
    this.updatedAt,
    this.updatedBy,
  });

  factory BannerResponseModel.fromJson(Map<String, dynamic> json) {
    return BannerResponseModel(
      id: json['id'] as int?,
      bannerId: json['bannerId'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      status: json['status'] as String?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      created:
          json['created'] != null ? CreatedBy.fromJson(json['created']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedBy: json['updatedBy'] as String?,
    );
  }

  static List<BannerResponseModel> fromJsonList(dynamic json) =>
      List<BannerResponseModel>.from(
          json.map((x) => BannerResponseModel.fromJson(x)));
}

class CreatedBy {
  final dynamic id; //TODO: refactor later
  final String? name;

  CreatedBy({
    this.id,
    this.name,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['id'],
      name: json['name'] as String?,
    );
  }
}
