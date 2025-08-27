import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/feature.dart';

class OnBoardingViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  OnBoardingViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> onBoard() async {
    await _authRepository.onBoard();
  }
}
