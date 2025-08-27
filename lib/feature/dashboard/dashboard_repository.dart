abstract class DashboardRepository {
  Future<void> setDisclaimer({
    required bool disclaimerAck,
  });
  Future<bool> getDisclaimerAck();
  Future<void> setDisclaimerAck();
}
