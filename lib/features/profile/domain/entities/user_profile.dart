import 'package:equatable/equatable.dart';
import '../../../../shared/models/user_role.dart';

/// User profile entity representing the user's profile information
///
/// This is a domain entity that contains all user profile data
class UserProfile extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? address;
  final String? profileImageUrl;
  final UserRoleType role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final double balance; // Account balance for customers
  final Map<String, dynamic>? additionalInfo;

  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.address,
    this.profileImageUrl,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.balance = 0.0,
    this.additionalInfo,
  });

  /// Create an empty profile
  factory UserProfile.empty() {
    return UserProfile(
      id: '',
      email: '',
      fullName: '',
      role: UserRoleType.user,
      createdAt: DateTime.now(),
    );
  }

  /// Check if profile is complete
  bool get isComplete {
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        phoneNumber != null &&
        phoneNumber!.isNotEmpty;
  }

  /// Get user initials for avatar
  String get initials {
    final parts = fullName.split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// Get formatted balance
  String get formattedBalance {
    return '\$${balance.toStringAsFixed(2)}';
  }

  /// Check if user is a customer
  bool get isCustomer => role == UserRoleType.user;

  /// Check if user is staff
  bool get isStaff => role != UserRoleType.user;

  /// Copy with method for immutability
  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? address,
    String? profileImageUrl,
    UserRoleType? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? balance,
    Map<String, dynamic>? additionalInfo,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      balance: balance ?? this.balance,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phoneNumber,
        address,
        profileImageUrl,
        role,
        isActive,
        createdAt,
        updatedAt,
        balance,
        additionalInfo,
      ];

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, fullName: $fullName, role: $role)';
  }
}
