import 'package:app_settings/app_settings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mydrivenepal/shared/helper/app_setting.dart';

class BiometricHelper {
  static LocalAuthentication auth = LocalAuthentication();

  static Future<bool> isBiometricSupported() async {
    final bool canAuthenticateWithBiometric = await auth.canCheckBiometrics;
    final bool isDeviceSupported = await auth.isDeviceSupported();
    final bool canAuthenticate =
        canAuthenticateWithBiometric || isDeviceSupported;
    return canAuthenticate;
  }

  static Future<bool> authenticate(String message) async {
    try {
      final bool isBiometricAvailable =
          await BiometricHelper.getAvailableBiometrics();
      if (!isBiometricAvailable) {
        AppSettingHelper.openAppSettings(AppSettingsType.security);
        return false;
      }
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: message,
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getAvailableBiometrics() async {
    try {
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (availableBiometrics.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
