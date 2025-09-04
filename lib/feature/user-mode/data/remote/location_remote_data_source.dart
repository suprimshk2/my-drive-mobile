import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/location_data_model.dart';
import 'package:mydrivenepal/data/local/local_storage_client.dart';
import 'package:mydrivenepal/data/local/local_storage_keys.dart';

/// Remote data source for location API calls
abstract class LocationRemoteDataSource {
  Future<bool> sendLocation(LocationData location);
  Future<bool> sendBatchedLocations(List<LocationData> locations);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final LocalStorageClient _storage;
  String? _baseUrl;
  String? _jwtToken;

  LocationRemoteDataSourceImpl({required LocalStorageClient storage})
      : _storage = storage;

  Future<void> _initialize() async {
    if (_baseUrl == null || _jwtToken == null) {
      _baseUrl = dotenv.env["BASE_URL"];
      _jwtToken = await _storage.getString(LocalStorageKeys.ACCESS_TOKEN);

      if (_baseUrl == null || _jwtToken == null) {
        throw Exception('Configuration not loaded');
      }
    }
  }

  @override
  Future<bool> sendLocation(LocationData location) async {
    try {
      await _initialize();

      // Build URL exactly as per Postman: {{base_url}}/location?token={{jwt_token}}
      final url = Uri.parse('$_baseUrl/location').replace(
        queryParameters: {'token': _jwtToken},
      );

      print('LocationRemoteDataSource: Sending location to: $url');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(location.toJson()),
      );

      print('LocationRemoteDataSource: Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('LocationRemoteDataSource: Location sent successfully');
        return true;
      } else {
        print(
            'LocationRemoteDataSource: Failed to send location: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('LocationRemoteDataSource: Error sending location: $e');
      return false;
    }
  }

  @override
  Future<bool> sendBatchedLocations(List<LocationData> locations) async {
    try {
      await _initialize();

      final url = Uri.parse('$_baseUrl/location/batch').replace(
        queryParameters: {'token': _jwtToken},
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'locations': locations.map((l) => l.toJson()).toList(),
          'batch_size': locations.length,
        }),
      );

      if (response.statusCode == 200) {
        print('LocationRemoteDataSource: Batched locations sent successfully');
        return true;
      } else {
        print(
            'LocationRemoteDataSource: Failed to send batched locations: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('LocationRemoteDataSource: Error sending batched locations: $e');
      return false;
    }
  }
}
