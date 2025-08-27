class ConversationParams {
  final bool? withUserAndGroupTags;
  final int? offset;
  final int? limit;

  ConversationParams({
    this.withUserAndGroupTags = true,
    this.offset = 0,
    this.limit = 20,
  });

  factory ConversationParams.fromJson(Map<String, dynamic> json) =>
      ConversationParams(
        withUserAndGroupTags: json["withUserAndGroupTags"],
        limit: json["per_page"],
        offset: json["page"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    final Map<String, dynamic> fields = {
      "withUserAndGroupTags": withUserAndGroupTags,
      "per_page": limit,
      "page": offset,
    };

    fields.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });

    return data;
  }
}
