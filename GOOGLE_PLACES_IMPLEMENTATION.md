# Google Places API Integration Guide

This implementation provides a complete Google Places API integration for your Flutter app without requiring any third-party packages.

## 🚀 Features

- **Direct API Integration**: Uses HTTP requests to Google Places API endpoints
- **Autocomplete Search**: Real-time place suggestions as you type
- **Location-Aware Search**: Prioritizes places near the user's current location
- **Caching**: Reduces API calls with intelligent caching (30-minute expiry)
- **Debouncing**: Prevents excessive API calls with 600ms debounce
- **Error Handling**: Comprehensive error handling and user feedback
- **Country Restriction**: Limited to Nepal for better relevance
- **Modern UI**: Beautiful, responsive search interface

## 📁 File Structure

```
lib/feature/user-mode/
├── data/
│   └── places_service.dart          # Core Places API service
├── widget/
│   └── place_search_widget.dart     # Reusable search widget
├── screen/
│   ├── passenger_mode_screen.dart   # Updated with place search
│   └── place_search_demo_screen.dart # Demo screen for testing
└── passenger_mode_viewmodel.dart    # Updated viewmodel
```

## 🔧 Setup Requirements

### 1. Google Maps API Key

Ensure your Google Maps API key has these APIs enabled:
- **Places API**
- **Geocoding API**
- **Directions API**

### 2. Environment Configuration

Add your API key to your `.env` file:
```
GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here
```

### 3. Dependencies

The implementation uses only existing dependencies:
- `http: ^1.4.0` - For API requests
- `flutter_dotenv: ^5.1.0` - For environment variables
- `google_maps_flutter: ^2.6.1` - For location data

## 🎯 Usage

### Basic Implementation

```dart
PlaceSearchWidget(
  hintText: 'Search for a place...',
  prefixIcon: Icons.search,
  prefixIconColor: Colors.blue,
  currentLocation: currentUserLocation,
  onPlaceSelected: (placeDetails) {
    // Handle selected place
    print('Selected: ${placeDetails.name}');
    print('Address: ${placeDetails.formattedAddress}');
    print('Location: ${placeDetails.location}');
  },
)
```

### In Passenger Mode Screen

The passenger mode screen now includes:
- **Pickup Location Search**: Search for pickup points
- **Destination Search**: Search for destinations
- **Map Selection**: Fallback to map-based selection
- **Automatic Directions**: Routes calculated when both locations are set

## 🔍 API Endpoints Used

### 1. Place Autocomplete
```
GET https://maps.googleapis.com/maps/api/place/autocomplete/json
```

**Parameters:**
- `input`: Search query
- `key`: API key
- `types`: establishment|geocode
- `components`: country:np (Nepal only)
- `location`: Current user location (optional)
- `radius`: Search radius in meters (optional)

### 2. Place Details
```
GET https://maps.googleapis.com/maps/api/place/details/json
```

**Parameters:**
- `place_id`: Place ID from autocomplete
- `fields`: place_id,formatted_address,geometry,name
- `key`: API key

## ⚡ Optimization Features

### 1. Caching
- **Predictions Cache**: Stores autocomplete results for 30 minutes
- **Details Cache**: Stores place details for 30 minutes
- **Automatic Cleanup**: Expired cache entries are automatically removed

### 2. Debouncing
- **600ms Delay**: Prevents excessive API calls while typing
- **Minimum Length**: Only searches after 2+ characters
- **Smart Cancellation**: Cancels previous requests when new ones are made

### 3. Location-Aware Search
- **Current Location**: Uses user's current location to prioritize nearby places
- **50km Radius**: Searches within 50km of current location
- **Better Relevance**: More relevant results for users

## 🎨 UI Features

### Search Widget
- **Modern Design**: Rounded corners, shadows, and smooth animations
- **Loading States**: Shows loading indicator during API calls
- **Error Handling**: Displays error messages with red borders
- **Clear Button**: Easy way to clear search input
- **No Results**: Shows helpful message when no places are found

### Prediction List
- **Beautiful Cards**: Each prediction is displayed in a styled card
- **Location Icons**: Visual indicators for different place types
- **Truncated Text**: Handles long addresses gracefully
- **Smooth Scrolling**: Optimized for touch interaction

## 🧪 Testing

### Demo Screen
Use the `PlaceSearchDemoScreen` to test the implementation:

```dart
// Navigate to demo screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PlaceSearchDemoScreen(),
  ),
);
```

### API Test Button
The demo includes a test button that:
- Tests place predictions for "Kathmandu"
- Tests place details retrieval
- Shows success/error messages
- Displays API response information

## 🔒 Error Handling

### Network Errors
- Connection timeouts
- Invalid API responses
- Rate limiting

### User Feedback
- Loading indicators
- Error messages
- Success confirmations
- Clear error states

## 💡 Best Practices

### 1. API Key Security
- Never commit API keys to version control
- Use environment variables
- Restrict API key usage in Google Cloud Console

### 2. Rate Limiting
- Implement proper debouncing
- Use caching to reduce API calls
- Monitor API usage in Google Cloud Console

### 3. User Experience
- Show loading states
- Provide clear error messages
- Include fallback options (map selection)

## 🚀 Performance Tips

1. **Cache Management**: Regularly clear expired cache entries
2. **Debounce Timing**: Adjust debounce delay based on user behavior
3. **Search Radius**: Optimize radius based on your use case
4. **API Fields**: Only request necessary fields to reduce response size

## 🔧 Customization

### Modify Search Radius
```dart
// In places_service.dart
radius: 50000, // Change to your preferred radius
```

### Change Cache Duration
```dart
// In places_service.dart
static const int _cacheExpiryMinutes = 30; // Adjust as needed
```

### Customize UI
```dart
// In place_search_widget.dart
// Modify colors, spacing, and styling
```

## 📊 Monitoring

### API Usage
Monitor your Google Places API usage in the Google Cloud Console:
- Requests per day
- Error rates
- Response times

### App Performance
- Cache hit rates
- Search response times
- User interaction patterns

## 🎯 Next Steps

1. **Test the Implementation**: Use the demo screen to verify functionality
2. **Configure API Key**: Ensure all required APIs are enabled
3. **Customize UI**: Adjust styling to match your app's design
4. **Monitor Usage**: Track API usage and optimize as needed
5. **Add Features**: Consider adding favorites, recent searches, etc.

## 🆘 Troubleshooting

### Common Issues

1. **No Results**: Check API key configuration and enabled APIs
2. **Network Errors**: Verify internet connectivity and API endpoints
3. **Caching Issues**: Clear cache if results seem stale
4. **Performance**: Adjust debounce timing and cache duration

### Debug Mode
Enable debug logging by checking console output for:
- API request URLs
- Response status codes
- Error messages
- Cache operations

---

This implementation provides a robust, optimized, and user-friendly Google Places API integration that enhances your ride-booking app's location selection experience.
