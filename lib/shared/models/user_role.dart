/// User role model for the catering app
///
/// Represents different user types with their permissions
class UserRoleModel {
  final String id;
  final UserRoleType type;
  final String name;
  final String description;
  final List<Permission> permissions;

  const UserRoleModel({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.permissions,
  });

  /// Create admin role
  factory UserRoleModel.admin() {
    return const UserRoleModel(
      id: 'admin',
      type: UserRoleType.admin,
      name: 'Administrator',
      description: 'Full system access and management capabilities',
      permissions: [
        Permission.viewDashboard,
        Permission.manageCustomers,
        Permission.manageDishes,
        Permission.manageOrders,
        Permission.viewProduction,
        Permission.manageProduction,
        Permission.viewLogistics,
        Permission.manageLogistics,
        Permission.viewFinance,
        Permission.manageFinance,
        Permission.manageUsers,
        Permission.systemSettings,
      ],
    );
  }

  /// Create production role
  factory UserRoleModel.production() {
    return const UserRoleModel(
      id: 'production',
      type: UserRoleType.production,
      name: 'Production',
      description: 'Production planning and cooking management',
      permissions: [
        Permission.viewDashboard,
        Permission.viewProduction,
        Permission.manageProduction,
        Permission.viewOrders,
      ],
    );
  }

  /// Create logistics role
  factory UserRoleModel.logistics() {
    return const UserRoleModel(
      id: 'logistics',
      type: UserRoleType.logistics,
      name: 'Logistics',
      description: 'Purchase orders and inventory management',
      permissions: [
        Permission.viewDashboard,
        Permission.viewLogistics,
        Permission.manageLogistics,
        Permission.viewProduction,
      ],
    );
  }

  /// Create accountancy role
  factory UserRoleModel.accountancy() {
    return const UserRoleModel(
      id: 'accountancy',
      type: UserRoleType.accountancy,
      name: 'Accountancy',
      description: 'Financial reports and transaction management',
      permissions: [
        Permission.viewDashboard,
        Permission.viewFinance,
        Permission.manageFinance,
        Permission.viewOrders,
      ],
    );
  }

  /// Create user/customer role
  factory UserRoleModel.user() {
    return const UserRoleModel(
      id: 'user',
      type: UserRoleType.user,
      name: 'Customer',
      description: 'Order dishes and manage personal account',
      permissions: [
        Permission.viewDashboard,
        Permission.viewDishes,
        Permission.createOrders,
        Permission.viewOrders,
        Permission.manageProfile,
        Permission.makePayments,
      ],
    );
  }

  /// Check if role has specific permission
  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

  /// Check if role has any of the given permissions
  bool hasAnyPermission(List<Permission> requiredPermissions) {
    return requiredPermissions.any((p) => permissions.contains(p));
  }

  /// Check if role has all of the given permissions
  bool hasAllPermissions(List<Permission> requiredPermissions) {
    return requiredPermissions.every((p) => permissions.contains(p));
  }

  /// Check if role is staff (not customer)
  bool get isStaff => type != UserRoleType.user;

  /// Check if role is admin
  bool get isAdmin => type == UserRoleType.admin;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'description': description,
      'permissions': permissions.map((p) => p.name).toList(),
    };
  }

  /// Create from JSON
  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      id: json['id'] as String,
      type: UserRoleType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => UserRoleType.user,
      ),
      name: json['name'] as String,
      description: json['description'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((p) => Permission.values.firstWhere(
                (perm) => perm.name == p,
                orElse: () => Permission.viewDashboard,
              ))
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;

  @override
  String toString() => 'UserRoleModel(id: $id, type: $type, name: $name)';
}

/// User role types
enum UserRoleType {
  admin,
  production,
  logistics,
  accountancy,
  user,
}

/// Permissions available in the system
enum Permission {
  // Dashboard
  viewDashboard,

  // Customers
  viewCustomers,
  manageCustomers,

  // Dishes
  viewDishes,
  manageDishes,

  // Orders
  viewOrders,
  createOrders,
  manageOrders,

  // Production
  viewProduction,
  manageProduction,

  // Logistics
  viewLogistics,
  manageLogistics,

  // Finance
  viewFinance,
  manageFinance,

  // Payments
  makePayments,
  viewPayments,

  // Users
  manageUsers,

  // Profile
  manageProfile,

  // System
  systemSettings,
}

/// Extension for UserRoleType utilities
extension UserRoleTypeExtension on UserRoleType {
  /// Get display name
  String get displayName {
    return switch (this) {
      UserRoleType.admin => 'Administrator',
      UserRoleType.production => 'Production',
      UserRoleType.logistics => 'Logistics',
      UserRoleType.accountancy => 'Accountancy',
      UserRoleType.user => 'Customer',
    };
  }

  /// Get role color
  int get colorValue {
    return switch (this) {
      UserRoleType.admin => 0xFF9C27B0, // Purple
      UserRoleType.production => 0xFFFF9800, // Orange
      UserRoleType.logistics => 0xFF2196F3, // Blue
      UserRoleType.accountancy => 0xFF4CAF50, // Green
      UserRoleType.user => 0xFF9E9E9E, // Grey
    };
  }

  /// Create role model from type
  UserRoleModel toModel() {
    return switch (this) {
      UserRoleType.admin => UserRoleModel.admin(),
      UserRoleType.production => UserRoleModel.production(),
      UserRoleType.logistics => UserRoleModel.logistics(),
      UserRoleType.accountancy => UserRoleModel.accountancy(),
      UserRoleType.user => UserRoleModel.user(),
    };
  }
}
