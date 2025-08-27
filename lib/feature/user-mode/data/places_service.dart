import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final structuredFormatting = json['structured_formatting'] ?? {};
    return PlacePrediction(
      placeId: json['place_id'] ?? '',
      description: json['description'] ?? '',
      mainText: structuredFormatting['main_text'] ?? '',
      secondaryText: structuredFormatting['secondary_text'] ?? '',
    );
  }
}

class PlaceDetails {
  final String placeId;
  final String formattedAddress;
  final LatLng location;
  final String name;

  PlaceDetails({
    required this.placeId,
    required this.formattedAddress,
    required this.location,
    required this.name,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final result = json['result'] ?? {};
    final geometry = result['geometry'] ?? {};
    final location = geometry['location'] ?? {};

    return PlaceDetails(
      placeId: result['place_id'] ?? '',
      formattedAddress: result['formatted_address'] ?? '',
      location: LatLng(
        (location['lat'] ?? 0.0).toDouble(),
        (location['lng'] ?? 0.0).toDouble(),
      ),
      name: result['name'] ?? '',
    );
  }
}

class PlacesService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api';
  static const int _cacheExpiryMinutes = 30;

  // Cache for place predictions
  static final Map<String, List<PlacePrediction>> _predictionsCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};

  // Cache for place details
  static final Map<String, PlaceDetails> _detailsCache = {};
  static final Map<String, DateTime> _detailsCacheTimestamps = {};

  static String get _apiKey {
    return dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  }

  /// Get place predictions (autocomplete) with caching
  static Future<List<PlacePrediction>> getPlacePredictions(
    String input, {
    LatLng? location,
    double? radius,
  }) async {
    if (input.trim().isEmpty) return [];

    // Check cache first
    final cacheKey = _generateCacheKey(input, location, radius);
    if (_predictionsCache.containsKey(cacheKey)) {
      final timestamp = _cacheTimestamps[cacheKey];
      if (timestamp != null &&
          DateTime.now().difference(timestamp).inMinutes <
              _cacheExpiryMinutes) {
        return _predictionsCache[cacheKey]!;
      }
    }

    try {
      final queryParams = <String, String>{
        'input': input,
        'key': _apiKey,
        'types': 'establishment|geocode',
        'components': 'country:np', // Restrict to Nepal
      };

      if (location != null) {
        queryParams['location'] = '${location.latitude},${location.longitude}';
        if (radius != null) {
          queryParams['radius'] = radius.toString();
        }
      }

      final uri = Uri.parse('$_baseUrl/place/autocomplete/json')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final predictions = (data['predictions'] as List)
            .map((prediction) => PlacePrediction.fromJson(prediction))
            .toList();

        // Cache the results
        _predictionsCache[cacheKey] = predictions;
        _cacheTimestamps[cacheKey] = DateTime.now();

        return predictions;
      } else {
        print('Places API error: ${data['status']} - ${data['error_message']}');
        return [];
      }
    } catch (e) {
      print('Error fetching place predictions: $e');
      return [];
    }
  }

  /// Get place details with caching
  static Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    if (placeId.isEmpty) return null;

    // Check cache first
    if (_detailsCache.containsKey(placeId)) {
      final timestamp = _detailsCacheTimestamps[placeId];
      if (timestamp != null &&
          DateTime.now().difference(timestamp).inMinutes <
              _cacheExpiryMinutes) {
        return _detailsCache[placeId];
      }
    }

    try {
      final uri = Uri.parse('$_baseUrl/place/details/json').replace(
        queryParameters: {
          'place_id': placeId,
          'fields': 'place_id,formatted_address,geometry,name',
          'key': _apiKey,
        },
      );

      final response = await http.get(uri);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final placeDetails = PlaceDetails.fromJson(data);

        // Cache the result
        _detailsCache[placeId] = placeDetails;
        _detailsCacheTimestamps[placeId] = DateTime.now();

        return placeDetails;
      } else {
        print(
            'Place details API error: ${data['status']} - ${data['error_message']}');
        return null;
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return null;
    }
  }

  /// Clear expired cache entries
  static void _clearExpiredCache() {
    final now = DateTime.now();

    // Clear expired predictions cache
    _cacheTimestamps.removeWhere((key, timestamp) {
      if (now.difference(timestamp).inMinutes >= _cacheExpiryMinutes) {
        _predictionsCache.remove(key);
        return true;
      }
      return false;
    });

    // Clear expired details cache
    _detailsCacheTimestamps.removeWhere((key, timestamp) {
      if (now.difference(timestamp).inMinutes >= _cacheExpiryMinutes) {
        _detailsCache.remove(key);
        return true;
      }
      return false;
    });
  }

  /// Generate cache key for predictions
  static String _generateCacheKey(
      String input, LatLng? location, double? radius) {
    final locationStr =
        location != null ? '${location.latitude},${location.longitude}' : '';
    final radiusStr = radius?.toString() ?? '';
    return '${input.toLowerCase()}_$locationStr\_$radiusStr';
  }

  /// Clear all cache
  static void clearCache() {
    _predictionsCache.clear();
    _cacheTimestamps.clear();
    _detailsCache.clear();
    _detailsCacheTimestamps.clear();
  }
}
