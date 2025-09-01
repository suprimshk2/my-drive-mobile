import 'package:mydrivenepal/data/data.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:app_links/app_links.dart';

class NavigationService {
  final LocalStorageClient _sharedPrefManager;
  late final AppLinks _appLinks;
  Uri? deepLinkUri;
  NavigationService({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;

  late String initialRoute;

  Future<void> getInitialRoute() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      initialRoute = RouteNames.noInternet;
      return;
    }

    final token = await _getToken();
    final isFirstTime = await _getIsFirstTime();

    // TODO:  set the initial route for the app.
    if (isFirstTime) {
      initialRoute = RouteNames.onBoarding;
    } else if (isNotEmpty(token)) {
      initialRoute = RouteNames.riderRegistration;
    } else {
      initialRoute = RouteNames.login;
    }

    print("Debug: initialRoute: $initialRoute");
  }

  Future<String?> _getToken() async {
    return await _sharedPrefManager.getString(LocalStorageKeys.ACCESS_TOKEN) ??
        "";
  }

  Future<bool> _getIsFirstTime() async {
    return await _sharedPrefManager.getBool(LocalStorageKeys.IS_FIRST_TIME) ??
        true;
  }

// code will be in use
  // Future<bool> _getIsBiometricSetup() async {
  //   return await _sharedPrefManager.getBool(LocalStorageKeys.IS_BIOMETRIC) ??
  //       false;
//   // }
//   Future<void> _handleDeepLink() async {
//     _appLinks = AppLinks();

//     try {
//       final initialLink = await _appLinks.getInitialLink();
//       if (initialLink != null) {
//         // terminated app
//         _processInitialDeepLink(initialLink);
//       }
//     } catch (e) {
//       debugPrint("Debug: error handling initial deep link: $e");
//     }
// // in background/forground
//     _appLinks.uriLinkStream.listen(
//       (uri) {
//         _processDeepLink(uri);
//       },
//       onError: (e) {
//         debugPrint("Debug: error handling deep link: $e");
//       },
//     );
//   }
}
