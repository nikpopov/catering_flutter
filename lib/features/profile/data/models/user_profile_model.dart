import '../../../../shared/models/user_role.dart';
import '../../domain/entities/user_profile.dart';

/// User profile model for data layer
///
/// This model extends the domain entity and adds JSON serialization
/// capabilities for Firebase and API communication
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.phoneNumber,
    super.address,
    super.profileImageUrl,
    required super.role,
    super.isActive,
    required super.createdAt,
    super.updatedAt,
    super.balance,
    super.additionalInfo,
  });

  /// Create from domain entity
  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      id: profile.id,
      email: profile.email,
      fullName: profile.fullName,
      phoneNumber: profile.phoneNumber,
      address: profile.address,
      profileImageUrl: profile.profileImageUrl,
      role: profile.role,
      isActive: profile.isActive,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
      balance: profile.balance,
      additionalInfo: profile.additionalInfo,
    );
  }

  /// Convert to domain entity
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      address: address,
      profileImageUrl: profileImageUrl,
      role: role,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      balance: balance,
      additionalInfo: additionalInfo,
    );
  }

  /// Create from JSON (Firebase document)
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      role: UserRoleType.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRoleType.user,
      ),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON (Firebase document)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'role': role.name,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'balance': balance,
      'additionalInfo': additionalInfo,
    };
  }

  /// Create a copy with updated fields
  @override
  UserProfileModel copyWith({
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
    return UserProfileModel(
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
  String toString() {
    return 'UserProfileModel(id: $id, email: $email, fullName: $fullName, role: $role)';
  }
}
