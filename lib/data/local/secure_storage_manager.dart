// Secure Storage is not working in the release mode for high end devices.
// So we are using the shared preferences instead.

// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:mydrivenepal/shared/shared.dart';
// import 'package:mydrivenepal/data/data.dart';

// class SecureStorageManager implements LocalStorageClient {
//   final FlutterSecureStorage _secureStorage;

//   SecureStorageManager() : _secureStorage = const FlutterSecureStorage();

//   @override
//   Future<bool> containsKey(String key) async {
//     final data = await _secureStorage.read(key: key);
//     return data != null;
//   }

//   @override
//   Future<void> setString(String key, String value) async {
//     await _secureStorage.write(key: key, value: value);
//   }

//   @override
//   Future<String?> getString(String key) async {
//     return await _secureStorage.read(key: key);
//   }

//   @override
//   Future<void> setInt(String key, int value) async {
//     await _secureStorage.write(key: key, value: value.toString());
//   }

//   @override
//   Future<int?> getInt(String key) async {
//     String? value = await _secureStorage.read(key: key);
//     return value != null ? int.tryParse(value) : null;
//   }

//   @override
//   Future<void> setBool(String key, bool value) async {
//     await _secureStorage.write(key: key, value: value.toString());
//   }

//   @override
//   Future<bool?> getBool(String key) async {
//     String? value = await _secureStorage.read(key: key);
//     return value != null ? value.toLowerCase() == 'true' : null;
//   }

//   @override
//   Future<void> setDouble(String key, double value) async {
//     await _secureStorage.write(key: key, value: value.toString());
//   }

//   @override
//   Future<double?> getDouble(String key) async {
//     String? value = await _secureStorage.read(key: key);
//     return value != null ? double.tryParse(value) : null;
//   }

//   @override
//   Future<void> setStringList(String key, List<String> value) async {
//     await _secureStorage.write(key: key, value: value.join(','));
//   }

//   @override
//   Future<List<String>?> getStringList(String key) async {
//     String? value = await _secureStorage.read(key: key);
//     return value?.split(',');
//   }

//   @override
//   Future<void> setObject<Obj extends JsonSerializable>(
//       String key, Obj value) async {
//     final jsonString = jsonEncode(value.toJson());
//     await _secureStorage.write(key: key, value: jsonString);
//   }

//   @override
//   Future<Obj?> getObject<Obj>(
//       String key, Obj Function(Map<String, dynamic> json) fromJsonFn) async {
//     final jsonString = await _secureStorage.read(key: key);
//     if (jsonString != null) {
//       final json = jsonDecode(jsonString);
//       return fromJsonFn(json);
//     }
//     return null;
//   }

//   @override
//   Future<bool> remove(String key) async {
//     await _secureStorage.delete(key: key);
//     return true;
//   }
// }
