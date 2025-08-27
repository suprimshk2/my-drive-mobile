import '../../../../shared/shared.dart';
import 'episode_response_model.dart';
import 'model.dart';

class EpisodeOverview {
  final BenefitPeriod benefitPeriod;
  final Clinic? clinic;
  final String createdDate;
  final Facility? facility;
  final Provider? provider;
  final String? procedureDate;

  const EpisodeOverview({
    required this.benefitPeriod,
    this.clinic,
    required this.createdDate,
    this.facility,
    this.provider,
    this.procedureDate,
  });

  factory EpisodeOverview.fromJson(Map<String, dynamic> json) {
    return EpisodeOverview(
      benefitPeriod: BenefitPeriod.fromJson(json['benefitPeriod']),
      clinic: json['clinic'] != null ? Clinic.fromJson(json['clinic']) : null,
      createdDate: json['createdDate'],
      facility:
          json['facility'] != null ? Facility.fromJson(json['facility']) : null,
      provider:
          json['provider'] != null ? Provider.fromJson(json['provider']) : null,
      procedureDate: json['procedureDate'],
    );
  }
}

class AdaptedEpisodeOverview {
  final BenefitPeriod? benefitPeriod;
  final Clinic? clinic;
  final String createdDate;
  final String benefitDate;
  final Facility? facility;
  final Provider? provider;
  final String? procedureDate;

  const AdaptedEpisodeOverview({
    this.benefitPeriod,
    this.clinic,
    required this.createdDate,
    required this.benefitDate,
    this.facility,
    this.provider,
    this.procedureDate,
  });
}

extension EpisodeOverviewFormatter on EpisodeOverview {
  AdaptedEpisodeOverview toAdapted() {
    return AdaptedEpisodeOverview(
      procedureDate: procedureDate,
      facility: facility,
      provider: provider,
      clinic: clinic,
      benefitPeriod: benefitPeriod,
      createdDate: formatDateOnly(createdDate),
      benefitDate: _getBenefitDate(),
    );
  }

  String _getBenefitDate() {
    final startDate = benefitPeriod.benefitStartDate;
    final endDate = benefitPeriod.benefitEndDate;

    // Early return for both null
    if (!isNotEmpty(startDate) && !isNotEmpty(endDate)) {
      return 'N/A';
    }

    return '$startDate - $endDate';
  }
}
