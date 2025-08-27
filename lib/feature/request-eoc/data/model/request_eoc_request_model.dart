class EocRequestModel {
  final String bundleDisplayName;
  final String eocUuid;
  final String eocName;
  final String email;
  final String firstName;
  final String lastName;
  final String subscriberId;
  final String dob;
  final String phone;
  final String contactVia;

  EocRequestModel({
    required this.bundleDisplayName,
    required this.eocUuid,
    required this.eocName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.subscriberId,
    required this.dob,
    required this.phone,
    required this.contactVia,
  });

  factory EocRequestModel.fromJson(Map<String, dynamic> json) {
    return EocRequestModel(
      bundleDisplayName: json['bundleDisplayName'] ?? '',
      eocUuid: json['eocUuid'] ?? '',
      eocName: json['eocName'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      subscriberId: json['subscriberId'] ?? '',
      dob: json['dob'] ?? '',
      phone: json['phone'] ?? '',
      contactVia: json['contactVia'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'bundleDisplayName': bundleDisplayName,
        'eocUuid': eocUuid,
        'eocName': eocName,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'subscriberId': subscriberId,
        'dob': dob,
        'phone': phone,
        'contactVia': contactVia,
      };

  EocRequestModel copyWith({
    String? firstName,
    String? lastName,
    String? dob,
    String? subscriberId,
    String? phone,
    String? email,
    String? contactVia,
    String? bundleDisplayName,
    String? eocUuid,
    String? eocName,
  }) {
    return EocRequestModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dob: dob ?? this.dob,
      subscriberId: subscriberId ?? this.subscriberId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      contactVia: contactVia ?? this.contactVia,
      bundleDisplayName: bundleDisplayName ?? this.bundleDisplayName,
      eocUuid: eocUuid ?? this.eocUuid,
      eocName: eocName ?? this.eocName,
    );
  }
}
