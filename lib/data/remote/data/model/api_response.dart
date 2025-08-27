class ApiResponse {
  ApiResponse({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  dynamic data;
  String? message;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json["success"],
        data: json["data"] ?? {},
        message: json["message"],
      );
}
