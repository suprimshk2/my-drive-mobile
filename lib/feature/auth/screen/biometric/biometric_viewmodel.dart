import 'package:flutter/foundation.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_base_model.dart';
import 'package:mydrivenepal/feature/communications/utils/comet_chat_init.dart';
import 'package:mydrivenepal/feature/feature.dart';
import 'package:mydrivenepal/shared/util/util.dart';

class BiometricViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final CometChatInit _cometChatRepo;

  BiometricViewModel({
    required AuthRepository authRepository,
    required CometChatInit cometChatRepo,
  })  : _authRepository = authRepository,
        _cometChatRepo = cometChatRepo;

  Response _biometricSetupUseCase = Response();
  bool _isBiometricSetup = false;
  Response<BiometricBaseModel> _biometricLoginUseCase =
      Response<BiometricBaseModel>();
  Response _disableBiometricLoginUseCase = Response();

  Response get biometricSetupUseCase => _biometricSetupUseCase;
  bool get isBiometricSetup => _isBiometricSetup;
  Response<BiometricBaseModel> get biometricLoginUseCase =>
      _biometricLoginUseCase;
  Response get disableBiometricLoginUseCase => _disableBiometricLoginUseCase;

  void setBiometricSetupUseCase(Response response) {
    _biometricSetupUseCase = response;
    notifyListeners();
  }

  Future<void> setupBiometric() async {
    try {
      setBiometricSetupUseCase(Response.loading());
      await _authRepository.setupBiometric();
      setBiometricSetupUseCase(Response.complete(null));
    } catch (e) {
      setBiometricSetupUseCase(Response.error(e));
    }
  }

  Future<void> initBiometricStatus() async {
    _isBiometricSetup = await _authRepository.isBiometricSetup();
    notifyListeners();
  }

  void setBiometricLoginUseCase(Response<BiometricBaseModel> response) {
    _biometricLoginUseCase = response;
    notifyListeners();
  }

  void setDisableBiometricLoginUseCase(Response response) {
    _disableBiometricLoginUseCase = response;
    notifyListeners();
  }

  Future<void> biometricLogin() async {
    setBiometricLoginUseCase(Response.loading());
    try {
      final biometricBaseResponse = await _authRepository.biometricLogin();

      if (biometricBaseResponse.isSuccess) {
        _cometChatRepo.login(
            biometricBaseResponse.successData?.user?.id.toString() ?? "");
        await _authRepository.registerDevice();
      }

      setBiometricLoginUseCase(
        Response.complete(biometricBaseResponse),
      );
    } catch (exception) {
      setBiometricLoginUseCase(Response.error(exception));
    }
  }

  Future<void> disableBiometricLogin() async {
    try {
      setDisableBiometricLoginUseCase(Response.loading());
      await _authRepository.disableBiometricLogin();
      setDisableBiometricLoginUseCase(Response.complete(null));
    } catch (exception) {
      setDisableBiometricLoginUseCase(Response.error(exception));
    }
  }
}
