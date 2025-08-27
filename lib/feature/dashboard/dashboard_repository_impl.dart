import 'package:mydrivenepal/feature/feature.dart';

import 'dashboard_repository.dart';
import 'remote/dashboard_remote.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final AuthLocal _authLocal;
  final DashboardRemote _dashboardRemote;

  DashboardRepositoryImpl(
      {required AuthLocal authLocal, required DashboardRemote dashboardRemote})
      : _authLocal = authLocal,
        _dashboardRemote = dashboardRemote;

  @override
  Future<void> setDisclaimer({required bool disclaimerAck}) async {
    final userId = await _authLocal.getUserId();
    await _dashboardRemote.setDisclaimer(
      disclaimerAck: disclaimerAck,
      userId: userId.toString(),
    );
  }

  @override
  Future<bool> getDisclaimerAck() async {
    return await _authLocal.getDisclaimerAck();
  }

  @override
  Future<void> setDisclaimerAck() async {
    await _authLocal.setDisclaimerAck();
  }
}
