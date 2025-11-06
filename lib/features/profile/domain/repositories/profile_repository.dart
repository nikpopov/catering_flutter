import 'dart:io';
import 'package:dartz/dartz.dart';
import '../entities/user_profile.dart';

/// Profile repository interface defining profile-related operations
///
/// This is a domain layer interface that defines the contract
/// for profile data operations
abstract class ProfileRepository {
  /// Get current user profile
  ///
  /// Returns [Right(UserProfile)] on success
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, UserProfile>> getCurrentProfile();

  /// Get profile by user ID
  ///
  /// Returns [Right(UserProfile)] on success
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, UserProfile>> getProfileById(String userId);

  /// Update user profile
  ///
  /// Returns [Right(UserProfile)] with updated profile on success
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, UserProfile>> updateProfile(UserProfile profile);

  /// Upload profile image
  ///
  /// Returns [Right(String)] with image URL on success
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, String>> uploadProfileImage(File imageFile);

  /// Delete profile image
  ///
  /// Returns [Right(bool)] true on success
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, bool>> deleteProfileImage();

  /// Change password
  ///
  /// Returns [Right(bool)] true on success
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Update email address
  ///
  /// Returns [Right(bool)] true on success
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, bool>> updateEmail(String newEmail);

  /// Delete account
  ///
  /// Returns [Right(bool)] true on success
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, bool>> deleteAccount();

  /// Check if email is available
  ///
  /// Returns [Right(bool)] true if available, false if taken
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, bool>> isEmailAvailable(String email);
}
