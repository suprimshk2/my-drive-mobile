class FetchListResponse<T> {
  final List<T> rows;
  final int count;

  FetchListResponse({
    required this.rows,
    required this.count,
  });

  factory FetchListResponse.fromJson(
      Map<String, dynamic> json, List<T> Function(dynamic json) dataFromJson) {
    return FetchListResponse(
      rows: dataFromJson(json['rows']),
      count: json['count'],
    );
  }
}
