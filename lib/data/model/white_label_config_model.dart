class WhiteLabelFeatures {
  final bool registration;

  const WhiteLabelFeatures({
    required this.registration,
  });

  factory WhiteLabelFeatures.fromMap(Map<String, dynamic> map) {
    return WhiteLabelFeatures(
      registration: map['registration'],
    );
  }
}

class WhiteLabelConfigModel {
  final String primaryColor;
  final String secondaryColor;
  final String logo;
  final String? appUrl;
  final WhiteLabelFeatures features;

  const WhiteLabelConfigModel({
    required this.primaryColor,
    required this.secondaryColor,
    required this.logo,
    this.appUrl,
    required this.features,
  });

  factory WhiteLabelConfigModel.fromMap(Map<String, dynamic> map) {
    return WhiteLabelConfigModel(
      primaryColor: map['primary_color'],
      secondaryColor: map['secondary_color'],
      logo: map['logo'],
      appUrl: map['app_url'],
      features: WhiteLabelFeatures.fromMap(map['features']),
    );
  }
}
