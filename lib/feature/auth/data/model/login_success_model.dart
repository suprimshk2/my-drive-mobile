class LoginSuccessModel {
  final UserModel? user;
  final String? token;
  final bool? isOtpLogin;
  final bool? isMfaEnabled;
  final String? refreshToken;

  LoginSuccessModel({
    this.user,
    this.token,
    this.isOtpLogin,
    this.isMfaEnabled,
    this.refreshToken,
  });

  factory LoginSuccessModel.fromJson(Map<String, dynamic> json) {
    return LoginSuccessModel(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      token: json['token'] as String?,
      isOtpLogin: json['isOtpLogin'] as bool?,
      isMfaEnabled: json['isMfaEnabled'] as bool?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
        'token': token,
        'isOtpLogin': isOtpLogin,
        'isMfaEnabled': isMfaEnabled,
        'refreshToken': refreshToken,
      };
}

class UserModel {
  final int? id;
  final String? uuid;
  final String? referenceType;
  final String? referenceCode;
  final String? memberUuid;
  final String? subscriberNumber;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? email;
  final String? npi;
  final String? phone;
  final String? dob;
  final String? gender;
  final String? inviteType;
  final String? note;
  final bool? isMobile;
  final bool? isSSO;
  final bool? isSSOCreated;
  final bool? isRegistered;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? otpCode;
  final String? otpExpiryTime;
  final int? updatedBy;
  final int? createdBy;
  final UserSettingModel? userSetting;
  final List<RoleModel>? roles;

  UserModel({
    this.id,
    this.uuid,
    this.referenceType,
    this.referenceCode,
    this.memberUuid,
    this.subscriberNumber,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.npi,
    this.phone,
    this.dob,
    this.gender,
    this.inviteType,
    this.note,
    this.isMobile,
    this.isSSO,
    this.isSSOCreated,
    this.isRegistered,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.otpCode,
    this.otpExpiryTime,
    this.updatedBy,
    this.createdBy,
    this.userSetting,
    this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      uuid: json['uuid'] as String?,
      referenceType: json['referenceType'] as String?,
      referenceCode: json['referenceCode'] as String?,
      memberUuid: json['memberUuid'] as String?,
      subscriberNumber: json['subscriberNumber'] as String?,
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      npi: json['npi'] as String?,
      phone: json['phone'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      inviteType: json['inviteType'] as String?,
      note: json['note'] as String?,
      isMobile: json['isMobile'] as bool?,
      isSSO: json['isSSO'] as bool?,
      isSSOCreated: json['isSSOCreated'] as bool?,
      isRegistered: json['isRegistered'] as bool?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      otpCode: json['otpCode'] as String?,
      otpExpiryTime: json['otpExpiryTime'] as String?,
      updatedBy: json['updatedBy'] as int?,
      createdBy: json['createdBy'] as int?,
      userSetting: json['userSetting'] != null
          ? UserSettingModel.fromJson(json['userSetting'])
          : null,
      roles: json['roles'] != null
          ? List<RoleModel>.from(
              json['roles'].map((x) => RoleModel.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'referenceType': referenceType,
        'referenceCode': referenceCode,
        'memberUuid': memberUuid,
        'subscriberNumber': subscriberNumber,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'email': email,
        'npi': npi,
        'phone': phone,
        'dob': dob,
        'gender': gender,
        'inviteType': inviteType,
        'note': note,
        'isMobile': isMobile,
        'isSSO': isSSO,
        'isSSOCreated': isSSOCreated,
        'isRegistered': isRegistered,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'otpCode': otpCode,
        'otpExpiryTime': otpExpiryTime,
        'updatedBy': updatedBy,
        'createdBy': createdBy,
        'userSetting': userSetting?.toJson(),
        'roles': roles?.map((x) => x.toJson()).toList(),
      };
}

class UserSettingModel {
  final int? id;
  final int? userId;
  final bool? triggerSMS;
  final bool? disclaimerAck;
  final String? disclaimerAckDate;
  final bool? enableMfaEmail;
  final bool? enableMfaSms;
  final bool? triggerReportMail;
  final String? createdAt;
  final String? updatedAt;

  UserSettingModel({
    this.id,
    this.userId,
    this.triggerSMS,
    this.disclaimerAck,
    this.disclaimerAckDate,
    this.enableMfaEmail,
    this.enableMfaSms,
    this.triggerReportMail,
    this.createdAt,
    this.updatedAt,
  });

  factory UserSettingModel.fromJson(Map<String, dynamic> json) {
    return UserSettingModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      triggerSMS: json['triggerSMS'] as bool?,
      disclaimerAck: json['disclaimerAck'] as bool?,
      disclaimerAckDate: json['disclaimerAckDate'] as String?,
      enableMfaEmail: json['enableMfaEmail'] as bool?,
      enableMfaSms: json['enableMfaSms'] as bool?,
      triggerReportMail: json['triggerReportMail'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'triggerSMS': triggerSMS,
        'disclaimerAck': disclaimerAck,
        'disclaimerAckDate': disclaimerAckDate,
        'enableMfaEmail': enableMfaEmail,
        'enableMfaSms': enableMfaSms,
        'triggerReportMail': triggerReportMail,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class RoleModel {
  final int? id;
  final int? userId;
  final String? roleCode;
  final bool? isPrimary;
  final bool? isActiveRole;
  final String? createdAt;
  final String? updatedAt;

  RoleModel({
    this.id,
    this.userId,
    this.roleCode,
    this.isPrimary,
    this.isActiveRole,
    this.createdAt,
    this.updatedAt,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      roleCode: json['roleCode'] as String?,
      isPrimary: json['isPrimary'] as bool?,
      isActiveRole: json['isActiveRole'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'roleCode': roleCode,
        'isPrimary': isPrimary,
        'isActiveRole': isActiveRole,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
