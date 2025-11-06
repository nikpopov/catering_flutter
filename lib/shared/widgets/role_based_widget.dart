import 'package:flutter/material.dart';

/// Widget that shows/hides content based on user roles
/// This is a placeholder implementation - integrate with your authentication system
class RoleBasedWidget extends StatelessWidget {
  final Widget child;
  final List<UserRole> allowedRoles;
  final Widget? fallback;
  final bool hideWhenUnauthorized;

  const RoleBasedWidget({
    super.key,
    required this.child,
    required this.allowedRoles,
    this.fallback,
    this.hideWhenUnauthorized = true,
  });

  /// Shows content only for admin users
  const RoleBasedWidget.adminOnly({
    super.key,
    required this.child,
    this.fallback,
    this.hideWhenUnauthorized = true,
  }) : allowedRoles = const [UserRole.admin];

  /// Shows content only for production users
  const RoleBasedWidget.productionOnly({
    super.key,
    required this.child,
    this.fallback,
    this.hideWhenUnauthorized = true,
  }) : allowedRoles = const [UserRole.production];

  /// Shows content only for logistics users
  const RoleBasedWidget.logisticsOnly({
    super.key,
    required this.child,
    this.fallback,
    this.hideWhenUnauthorized = true,
  }) : allowedRoles = const [UserRole.logistics];

  /// Shows content only for accountancy users
  const RoleBasedWidget.accountancyOnly({
    super.key,
    required this.child,
    this.fallback,
    this.hideWhenUnauthorized = true,
  }) : allowedRoles = const [UserRole.accountancy];

  /// Shows content only for regular users/customers
  const RoleBasedWidget.userOnly({
    super.key,
    required this.child,
    this.fallback,
    this.hideWhenUnauthorized = true,
  }) : allowedRoles = const [UserRole.user];

  /// Shows content for staff (admin, production, logistics, accountancy)
  const RoleBasedWidget.staffOnly({
    super.key,
    required this.child,
    this.fallback,
    this.hideWhenUnauthorized = true,
  }) : allowedRoles = const [
          UserRole.admin,
          UserRole.production,
          UserRole.logistics,
          UserRole.accountancy,
        ];

  @override
  Widget build(BuildContext context) {
    // TODO: Get current user role from your authentication/state management
    // This is a placeholder - replace with actual implementation
    final UserRole currentRole = _getCurrentUserRole(context);

    final bool hasAccess = allowedRoles.contains(currentRole);

    if (!hasAccess) {
      if (hideWhenUnauthorized) {
        return const SizedBox.shrink();
      }
      return fallback ?? const SizedBox.shrink();
    }

    return child;
  }

  /// Get current user role from context
  /// TODO: Replace this with actual implementation from your auth system
  UserRole _getCurrentUserRole(BuildContext context) {
    // Placeholder implementation
    // In real app, get this from BLoC, Provider, or other state management
    return UserRole.user;
  }
}

/// User roles in the catering app
enum UserRole {
  admin,
  production,
  logistics,
  accountancy,
  user,
}

/// Extension for user role utilities
extension UserRoleExtension on UserRole {
  /// Get display name for the role
  String get displayName {
    return switch (this) {
      UserRole.admin => 'Administrator',
      UserRole.production => 'Production',
      UserRole.logistics => 'Logistics',
      UserRole.accountancy => 'Accountancy',
      UserRole.user => 'Customer',
    };
  }

  /// Get role description
  String get description {
    return switch (this) {
      UserRole.admin => 'Full system access and management',
      UserRole.production => 'Production planning and cooking',
      UserRole.logistics => 'Purchase orders and inventory',
      UserRole.accountancy => 'Financial reports and transactions',
      UserRole.user => 'Order dishes and make payments',
    };
  }

  /// Check if role is staff (not customer)
  bool get isStaff {
    return this != UserRole.user;
  }

  /// Check if role has admin privileges
  bool get isAdmin {
    return this == UserRole.admin;
  }

  /// Get role color for UI
  Color get color {
    return switch (this) {
      UserRole.admin => Colors.purple,
      UserRole.production => Colors.orange,
      UserRole.logistics => Colors.blue,
      UserRole.accountancy => Colors.green,
      UserRole.user => Colors.grey,
    };
  }

  /// Get role icon
  IconData get icon {
    return switch (this) {
      UserRole.admin => Icons.admin_panel_settings,
      UserRole.production => Icons.kitchen,
      UserRole.logistics => Icons.local_shipping,
      UserRole.accountancy => Icons.account_balance,
      UserRole.user => Icons.person,
    };
  }

  /// Convert to string for storage/API
  String toValue() {
    return name;
  }

  /// Create from string value
  static UserRole fromValue(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value.toLowerCase(),
      orElse: () => UserRole.user,
    );
  }
}
