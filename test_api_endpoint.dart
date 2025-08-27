import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  
  if (apiKey.isEmpty) {
    print("❌ Google Maps API key not found in .env file");
    print("Please create a .env file with: GOOGLE_MAPS_API_KEY=your_api_key_here");
    return;
  }
  
  print("✅ Google Maps API key found");
  
  // Test coordinates (Kathmandu to Pokhara)
  final origin = "27.7172,85.3240"; // Kathmandu
  final destination = "28.2096,83.9856"; // Pokhara
  
  final url = 'https://maps.googleapis.com/maps/api/directions/json?'
      'origin=$origin&'
      'destination=$destination&'
      'key=$apiKey';
  
  print("Testing Directions API...");
  print("URL: $url");
  
  try {
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    
    print("Response status: ${data['status']}");
    
    if (data['status'] == 'OK') {
      print("✅ Directions API is working!");
      final route = data['routes'][0];
      final leg = route['legs'][0];
      print("Distance: ${leg['distance']['text']}");
      print("Duration: ${leg['duration']['text']}");
      print("Polyline points: ${route['overview_polyline']['points'].length} characters");
    } else {
      print("❌ Directions API error: ${data['status']}");
      if (data['error_message'] != null) {
        print("Error message: ${data['error_message']}");
      }
    }
  } catch (e) {
    print("❌ Network error: $e");
  }
}
