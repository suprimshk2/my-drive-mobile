class AdditionalHeaders {
  final String? code;

  AdditionalHeaders({
    this.code,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    final Map<String, dynamic> fields = {
      "code": code,
    };

    fields.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });

    return data;
  }
}
