# Optimized Bottom Sheet

A highly customizable and reusable bottom sheet component that follows the project's design system and provides a consistent user experience across the app.

## Features

- ✅ **Consistent Design**: Follows the project's design system using `Dimens`, `AppColorExtension`, and existing widgets
- ✅ **Flexible Layout**: Supports title, custom header, content, and footer sections
- ✅ **Drag Handle**: Optional drag handle for better UX
- ✅ **Scrollable Content**: Built-in scroll support for long content
- ✅ **Customizable Styling**: Custom colors, border radius, and padding
- ✅ **Dismissible Options**: Control whether the bottom sheet can be dismissed by tapping outside
- ✅ **Specialized Components**: Pre-built components for common use cases (ride details, location options)
- ✅ **Type Safety**: Full TypeScript support with proper typing

## Basic Usage

### Simple Bottom Sheet

```dart
import 'package:mydrivenepal/widget/scaffold/optimized_bottom_sheet.dart';

// Show a basic bottom sheet
OptimizedBottomSheet.show(
  context: context,
  title: 'My Bottom Sheet',
  content: Column(
    children: [
      Text('This is the content of the bottom sheet'),
      SizedBox(height: 16),
      Text('You can add any widgets here'),
    ],
  ),
);
```

### Bottom Sheet with Custom Header

```dart
OptimizedBottomSheet.show(
  context: context,
  header: Row(
    children: [
      Icon(Icons.info, color: Colors.blue),
      SizedBox(width: 8),
      Text('Custom Header'),
    ],
  ),
  content: Text('Content with custom header'),
);
```

### Bottom Sheet with Footer

```dart
OptimizedBottomSheet.show(
  context: context,
  title: 'Action Required',
  content: Text('Please confirm your action'),
  footer: Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ),
      SizedBox(width: 16),
      Expanded(
        child: RoundedFilledButtonWidget(
          context: context,
          label: 'Confirm',
          onPressed: () {
            Navigator.pop(context);
            // Handle confirmation
          },
        ),
      ),
    ],
  ),
);
```

## Specialized Components

### Ride Details Bottom Sheet

Perfect for ride-sharing apps to display ride information and booking options.

```dart
RideDetailsBottomSheet.show(
  context: context,
  distance: '2.5 km',
  duration: '8 mins',
  estimatedFare: 150.0,
  canBookRide: true,
  isLoading: false,
  onBookRide: () {
    // Handle ride booking
    Navigator.pop(context);
  },
);
```

### Location Options Bottom Sheet

For location-based features with save, share, and remove options.

```dart
LocationOptionsBottomSheet.show(
  context: context,
  onSaveLocation: () {
    // Handle save location
  },
  onShare: () {
    // Handle share location
  },
  onRemove: () {
    // Handle remove location
  },
);
```

## Advanced Configuration

### Custom Styling

```dart
OptimizedBottomSheet.show(
  context: context,
  title: 'Custom Styled',
  backgroundColor: Colors.grey[100],
  borderRadius: BorderRadius.vertical(
    top: Radius.circular(20),
  ),
  padding: EdgeInsets.all(24),
  content: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Text('Custom styled content'),
  ),
);
```

### Non-Dismissible Bottom Sheet

```dart
OptimizedBottomSheet.show(
  context: context,
  title: 'Required Action',
  isDismissible: false,
  content: Text('This bottom sheet cannot be dismissed by tapping outside'),
  footer: RoundedFilledButtonWidget(
    context: context,
    label: 'Close',
    onPressed: () => Navigator.pop(context),
  ),
);
```

### Scrollable Content

```dart
OptimizedBottomSheet.show(
  context: context,
  title: 'Long Content',
  maxHeight: 400,
  content: Column(
    children: List.generate(
      20,
      (index) => Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Text('Item ${index + 1}'),
      ),
    ),
  ),
);
```

## API Reference

### OptimizedBottomSheet

#### Constructor Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `String?` | `null` | Title displayed in the header |
| `header` | `Widget?` | `null` | Custom header widget |
| `content` | `Widget` | **required** | Main content of the bottom sheet |
| `footer` | `Widget?` | `null` | Footer widget with action buttons |
| `showDragHandle` | `bool` | `true` | Whether to show the drag handle |
| `isDismissible` | `bool` | `true` | Whether the bottom sheet can be dismissed by tapping outside |
| `isScrollControlled` | `bool` | `true` | Whether the content is scrollable |
| `maxHeight` | `double?` | `null` | Maximum height of the bottom sheet |
| `minHeight` | `double?` | `null` | Minimum height of the bottom sheet |
| `padding` | `EdgeInsets?` | `null` | Custom padding for the content |
| `onClose` | `VoidCallback?` | `null` | Custom close action |
| `backgroundColor` | `Color?` | `null` | Custom background color |
| `borderRadius` | `BorderRadius?` | `null` | Custom border radius |

#### Static Methods

- `show<T>()` - Shows the bottom sheet and returns a Future<T?>

### RideDetailsBottomSheet

#### Constructor Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `distance` | `String` | **required** | Distance of the ride |
| `duration` | `String` | **required** | Duration of the ride |
| `estimatedFare` | `double` | **required** | Estimated fare amount |
| `canBookRide` | `bool` | **required** | Whether the ride can be booked |
| `isLoading` | `bool` | `false` | Whether the booking is in progress |
| `onBookRide` | `VoidCallback?` | `null` | Callback when book ride is pressed |
| `onClose` | `VoidCallback?` | `null` | Custom close action |

### LocationOptionsBottomSheet

#### Constructor Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onSaveLocation` | `VoidCallback?` | `null` | Callback when save location is pressed |
| `onShare` | `VoidCallback?` | `null` | Callback when share is pressed |
| `onRemove` | `VoidCallback?` | `null` | Callback when remove is pressed |
| `onClose` | `VoidCallback?` | `null` | Custom close action |

## Best Practices

### 1. Use Appropriate Heights

- For simple content: Use default height or `minHeight`
- For long content: Set `maxHeight` and let content scroll
- For forms: Use `isScrollControlled: true`

### 2. Consistent Styling

- Use project's design system constants (`Dimens`, `AppColorExtension`)
- Follow the existing color scheme and spacing patterns
- Use `RoundedFilledButtonWidget` for primary actions

### 3. User Experience

- Always provide a way to dismiss the bottom sheet
- Use appropriate loading states for async operations
- Provide clear feedback for user actions

### 4. Performance

- Avoid heavy computations in the content
- Use `const` constructors where possible
- Consider using `ListView.builder` for long lists

## Examples

See `optimized_bottom_sheet_examples.dart` for comprehensive examples of all features and use cases.

## Migration from Existing Bottom Sheets

### Before (Traditional showModalBottomSheet)

```dart
showModalBottomSheet(
  context: context,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ),
  builder: (context) => Container(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Title'),
        Text('Content'),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    ),
  ),
);
```

### After (Optimized Bottom Sheet)

```dart
OptimizedBottomSheet.show(
  context: context,
  title: 'Title',
  content: Text('Content'),
  footer: RoundedFilledButtonWidget(
    context: context,
    label: 'Close',
    onPressed: () => Navigator.pop(context),
  ),
);
```

## Contributing

When adding new features to the optimized bottom sheet:

1. Follow the existing design patterns
2. Use the project's design system constants
3. Add comprehensive examples
4. Update this documentation
5. Ensure type safety and null safety












