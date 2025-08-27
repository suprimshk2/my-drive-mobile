# User Mode Implementation - MVVM Architecture

This document describes the implementation of a driver/passenger mode toggle system for the MyDriveNepal app using MVVM (Model-View-ViewModel) architecture.

## Overview

The user mode system allows users who are registered as both drivers and passengers to switch between these modes within the app. The implementation follows clean architecture principles with proper separation of concerns.

## Architecture Components

### 1. Model Layer

#### UserModeModel (`lib/feature/auth/data/model/user_mode_model.dart`)
- **UserMode Enum**: Defines the available modes (passenger, driver)
- **UserModeModel Class**: Represents the current state of user modes
- **Features**:
  - Current active mode
  - Available modes based on user roles
  - Mode switching enabled/disabled state
  - JSON serialization support
  - Immutable data structure with copyWith functionality

```dart
enum UserMode {
  passenger('passenger', 'Passenger Mode'),
  driver('driver', 'Driver Mode');
}

class UserModeModel extends JsonSerializable {
  final UserMode currentMode;
  final List<UserMode> availableModes;
  final bool isModeSwitchEnabled;
  // ... methods
}
```

### 2. Data Layer

#### AuthLocal Interface (`lib/feature/auth/data/local/auth_local.dart`)
- **User Mode Management Methods**:
  - `setUserMode(UserModeModel userMode)`
  - `getUserMode()`
  - `setCurrentMode(UserMode mode)`
  - `getCurrentMode()`
  - `setAvailableModes(List<UserMode> modes)`
  - `getAvailableModes()`

#### AuthLocalImpl (`lib/feature/auth/data/local/auth_local_impl.dart`)
- **Implementation**:
  - Uses SharedPreferences for persistent storage
  - JSON serialization for complex objects
  - Error handling and fallback values
  - Thread-safe operations

### 3. ViewModel Layer

#### UserModeViewModel (`lib/feature/auth/user_mode_viewmodel.dart`)
- **Responsibilities**:
  - State management for user modes
  - Business logic for mode switching
  - Integration with user roles
  - Error handling and loading states
  - Notifies UI of state changes

**Key Methods**:
```dart
// Initialize user mode based on user roles
Future<void> initializeUserMode(List<RoleModel>? userRoles)

// Switch between modes
Future<bool> switchMode(UserMode newMode)

// Load user mode from storage
Future<void> loadUserMode()

// Update available modes
Future<void> updateAvailableModes(List<UserMode> newAvailableModes)
```

**State Properties**:
- `currentMode`: Currently active mode
- `availableModes`: List of modes user can switch to
- `isLoading`: Loading state indicator
- `errorMessage`: Error state for UI feedback
- `isModeSwitchEnabled`: Whether mode switching is allowed

### 4. View Layer

#### SideNavigationBar (`lib/widget/scaffold/side_bar.dart`)
- **Features**:
  - Dynamic mode display based on current state
  - Interactive mode switch buttons
  - Loading indicators
  - Error message display
  - Responsive UI with proper theming

**Components**:
- `_ModeSwitchButton`: Custom button component for mode switching
- Mode status display with icons
- Error handling with user-friendly messages

## Integration Points

### 1. Service Locator Registration
```dart
// lib/di/service_locator.dart
locator.registerFactory<UserModeViewModel>(
  () => UserModeViewModel(
    authLocal: locator<AuthLocal>(),
  ),
);
```

### 2. Login Flow Integration
```dart
// lib/feature/auth/screen/login/login_viewmodel.dart
Future<void> _initializeUserMode(List<RoleModel>? userRoles) async {
  try {
    final userModeViewModel = locator<UserModeViewModel>();
    await userModeViewModel.initializeUserMode(userRoles);
  } catch (e) {
    print('Failed to initialize user mode: $e');
  }
}
```

### 3. Storage Keys
```dart
// lib/data/local/local_storage_keys.dart
static const String USER_MODE = "user_mode";
```

## Usage Examples

### 1. Basic Mode Switching
```dart
final userModeViewModel = locator<UserModeViewModel>();

// Switch to driver mode
await userModeViewModel.switchToDriverMode();

// Switch to passenger mode
await userModeViewModel.switchToPassengerMode();
```

### 2. Checking Current Mode
```dart
if (userModeViewModel.isDriverMode) {
  // Show driver-specific UI
} else if (userModeViewModel.isPassengerMode) {
  // Show passenger-specific UI
}
```

### 3. Role-Based Initialization
```dart
// After successful login
await userModeViewModel.initializeUserMode(user.roles);
```

## Features

### 1. Role-Based Access Control
- Automatically detects user roles from login response
- Only shows mode switching if user has multiple roles
- Validates mode availability before allowing switches

### 2. Persistent State Management
- User mode preferences are saved locally
- Survives app restarts and logout/login cycles
- Graceful fallback to default mode

### 3. Error Handling
- Comprehensive error handling at all layers
- User-friendly error messages
- Graceful degradation on failures

### 4. Loading States
- Loading indicators during mode switches
- Prevents multiple simultaneous operations
- Responsive UI feedback

### 5. Type Safety
- Strong typing throughout the implementation
- Enum-based mode definitions
- Compile-time error checking

## Best Practices Implemented

### 1. MVVM Architecture
- Clear separation of concerns
- ViewModels handle business logic
- Models represent data structures
- Views handle UI presentation

### 2. Dependency Injection
- Service locator pattern for dependency management
- Loose coupling between components
- Easy testing and mocking

### 3. Immutable Data
- UserModeModel is immutable
- copyWith pattern for updates
- Thread-safe operations

### 4. Error Handling
- Try-catch blocks at appropriate levels
- User-friendly error messages
- Graceful fallbacks

### 5. State Management
- ChangeNotifier for reactive updates
- Proper state synchronization
- Loading and error states

## Testing Considerations

### 1. Unit Tests
- Test UserModeViewModel business logic
- Test UserModeModel data operations
- Test AuthLocalImpl storage operations

### 2. Widget Tests
- Test SideNavigationBar UI components
- Test mode switching interactions
- Test error state displays

### 3. Integration Tests
- Test complete mode switching flow
- Test persistence across app restarts
- Test role-based initialization

## Future Enhancements

### 1. Server-Side Integration
- Sync user mode preferences with server
- Real-time mode updates across devices
- Server-side role validation

### 2. Advanced Features
- Mode-specific settings and preferences
- Mode switching analytics
- Custom mode configurations

### 3. Performance Optimizations
- Lazy loading of mode-specific data
- Caching strategies
- Background mode synchronization

## Conclusion

This implementation provides a robust, scalable, and maintainable solution for user mode management in the MyDriveNepal app. The MVVM architecture ensures clean separation of concerns, while the comprehensive error handling and state management provide a smooth user experience.

The system is designed to be easily extensible for future requirements while maintaining backward compatibility and following established coding standards. 