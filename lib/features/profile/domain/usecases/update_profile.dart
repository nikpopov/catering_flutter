import 'package:dartz/dartz.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Use case for updating user profile
///
/// This encapsulates the business logic for updating
/// user profile information
class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  /// Execute the use case
  ///
  /// Parameters:
  /// - [profile]: The updated user profile
  ///
  /// Returns [Right(UserProfile)] with updated profile on success
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, UserProfile>> call(UserProfile profile) async {
    try {
      // Validate profile data
      final validation = _validateProfile(profile);
      if (validation != null) {
        return Left(validation);
      }

      return await repository.updateProfile(profile);
    } catch (e) {
      return Left('Failed to update profile: ${e.toString()}');
    }
  }

  /// Validate profile data
  String? _validateProfile(UserProfile profile) {
    if (profile.fullName.isEmpty) {
      return 'Full name is required';
    }

    if (profile.fullName.length < 2) {
      return 'Full name must be at least 2 characters';
    }

    if (profile.email.isEmpty) {
      return 'Email is required';
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(profile.email)) {
      return 'Invalid email format';
    }

    // Phone validation (if provided)
    if (profile.phoneNumber != null && profile.phoneNumber!.isNotEmpty) {
      final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
      if (!phoneRegex.hasMatch(profile.phoneNumber!)) {
        return 'Invalid phone number format';
      }

      if (profile.phoneNumber!.replaceAll(RegExp(r'\D'), '').length < 10) {
        return 'Phone number must be at least 10 digits';
      }
    }

    return null;
  }
}
