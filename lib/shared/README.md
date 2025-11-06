# Shared Module

The shared module contains reusable components, models, and utilities used throughout the catering Flutter application.

## Structure

```
lib/shared/
├── widgets/          # Reusable UI widgets
├── models/           # Shared data models
├── extensions/       # Dart extension methods
└── shared.dart      # Main barrel file
```

## Quick Start

### Import Everything

```dart
import 'package:catering_flutter/shared/shared.dart';
```

### Import Specific Categories

```dart
// Only widgets
import 'package:catering_flutter/shared/widgets/widgets.dart';

// Only extensions
import 'package:catering_flutter/shared/extensions/extensions.dart';

// Only models
import 'package:catering_flutter/shared/models/models.dart';
```

### Import Individual Files

```dart
import 'package:catering_flutter/shared/widgets/custom_button.dart';
import 'package:catering_flutter/shared/extensions/context_extensions.dart';
```

## Components

### Widgets

- **CustomButton** - Versatile button with variants (primary, secondary, text, danger)
- **CustomTextField** - Feature-rich text input with validation
- **LoadingIndicator** - Loading states with multiple styles
- **CustomErrorWidget** - Error display with retry functionality
- **CustomAppBar** - Consistent app bar implementations
- **RoleBasedWidget** - Conditional rendering based on user roles

### Models

- **UserRoleModel** - Complete user role and permission system

### Extensions

- **BuildContext Extensions** - Theme, navigation, and UI helpers
- **String Extensions** - String manipulation and validation
- **DateTime Extensions** - Date operations and formatting

## Examples

### Using Custom Button

```dart
CustomButton(
  text: 'Submit',
  onPressed: () => _handleSubmit(),
  variant: ButtonVariant.primary,
  size: ButtonSize.medium,
  icon: Icons.check,
  isFullWidth: true,
)
```

### Using Context Extensions

```dart
// Show snackbar
context.showSuccessSnackBar('Order placed successfully!');

// Navigate
context.push(OrderDetailsPage());

// Check device type
if (context.isMobile) {
  // Mobile layout
}
```

### Using String Extensions

```dart
final email = 'user@example.com';
if (email.isValidEmail) {
  print(email.maskEmail); // u***r@example.com
}

final name = 'john doe'.capitalizeWords; // John Doe
```

### Using DateTime Extensions

```dart
final date = DateTime.now();

if (date.isToday) {
  print('Today!');
}

final deliveryDate = date.addBusinessDays(5);
print(date.friendlyDate); // 'Today', 'Yesterday', etc.
```

### Role-Based Access

```dart
RoleBasedWidget.adminOnly(
  child: AdminPanel(),
  fallback: Text('Access Denied'),
)
```

## Best Practices

1. **Use barrel files** for cleaner imports
2. **Leverage extensions** to reduce boilerplate code
3. **Use custom widgets** for consistent styling
4. **Apply role-based rendering** for access control
5. **Follow the established patterns** when adding new shared components

## Adding New Components

When adding new shared components:

1. Create the file in the appropriate directory
2. Export it in the category barrel file (e.g., `widgets/widgets.dart`)
3. Follow existing patterns and naming conventions
4. Add comprehensive documentation
5. Update this README with usage examples

## Dependencies

The shared module uses only Flutter SDK - no external packages required.

```yaml
dependencies:
  flutter:
    sdk: flutter
```

## Documentation

For detailed documentation of each component, see:
- [Shared Components Implementation Summary](../../Shared%20Components%20-%20Implementation%20Summary.md)
