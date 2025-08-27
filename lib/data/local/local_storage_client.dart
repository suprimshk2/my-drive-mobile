import 'package:mydrivenepal/shared/shared.dart';

abstract class LocalStorageClient {
  Future<bool> containsKey(String key);

  Future<void> setString(String key, String value);

  Future<String?> getString(String key);

  Future<void> setInt(String key, int value);

  Future<int?> getInt(String key);

  Future<void> setBool(String key, bool value);

  Future<bool?> getBool(String key);

  Future<void> setDouble(String key, double value);

  Future<double?> getDouble(String key);

  Future<void> setStringList(String key, List<String> value);

  Future<List<String>?> getStringList(String key);

  Future<void> setObject<Obj extends JsonSerializable>(String key, Obj value);

  Future<Obj?> getObject<Obj>(
      String key, Obj Function(Map<String, dynamic> json) fromJsonFn);

  Future<bool> remove(String key);
}
