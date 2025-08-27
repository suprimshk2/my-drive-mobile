import 'package:flutter/material.dart';

import '../../shared/util/response.dart';
import 'dashboard_repository.dart';

class DisclaimerViewModel extends ChangeNotifier {
  final DashboardRepository _dashboardRepository;

  DisclaimerViewModel({required DashboardRepository dashboardRepository})
      : _dashboardRepository = dashboardRepository;
  bool isChecked = false;
  bool isLoading = false;

  void toggleCheckbox() {
    isChecked = !isChecked;
    notifyListeners();
  }

  Future<bool> loadInitialState() async {
    bool disclaimerAck = await _dashboardRepository.getDisclaimerAck();
    notifyListeners();
    return disclaimerAck;
  }

  Response<void> _disclaimerResponse = Response<void>();

  Response<void> get disclaimerResponse => _disclaimerResponse;

  set disclaimerResponse(Response<void> response) {
    _disclaimerResponse = response;
    notifyListeners();
  }

  Future<void> submitDisclaimer(VoidCallback onSuccess) async {
    disclaimerResponse = Response.loading();

    try {
      await _dashboardRepository.setDisclaimer(
        disclaimerAck: isChecked,
      );
      disclaimerResponse = Response.complete(null);
      await _dashboardRepository.setDisclaimerAck();
      onSuccess();
    } catch (exception) {
      disclaimerResponse = Response.error(exception);
    }
  }
}
