import 'package:mydrivenepal/data/local/local_storage_client.dart';
import 'package:mydrivenepal/data/local/local_storage_keys.dart';
import 'package:mydrivenepal/feature/banner/data/local/banner_local.dart';

class BannerLocalImpl implements BannerLocal {
  final LocalStorageClient _sharedPrefManager;

  BannerLocalImpl({
    required LocalStorageClient sharedPrefManager,
  }) : _sharedPrefManager = sharedPrefManager;

  @override
  Future<bool> hasClosedBanner() async {
    return await _sharedPrefManager.getBool(LocalStorageKeys.BANNER_CLOSED) ??
        false;
  }

  @override
  Future<void> setHasClosedBanner(bool value) async {
    await _sharedPrefManager.setBool(LocalStorageKeys.BANNER_CLOSED, value);
  }
}
