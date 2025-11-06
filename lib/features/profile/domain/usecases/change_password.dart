import 'package:dartz/dartz.dart';
import '../repositories/profile_repository.dart';

/// Use case for changing user password
///
/// This encapsulates the business logic for changing
/// the user's password
class ChangePassword {
  final ProfileRepository repository;

  ChangePassword(this.repository);

  /// Execute the use case
  ///
  /// Parameters:
  /// - [currentPassword]: The current password
  /// - [newPassword]: The new password
  ///
  /// Returns [Right(bool)] true on success
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, bool>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Validate passwords
      final validation = _validatePasswords(currentPassword, newPassword);
      if (validation != null) {
        return Left(validation);
      }

      return await repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      return Left('Failed to change password: ${e.toString()}');
    }
  }

  /// Validate password requirements
  String? _validatePasswords(String currentPassword, String newPassword) {
    if (currentPassword.isEmpty) {
      return 'Current password is required';
    }

    if (newPassword.isEmpty) {
      return 'New password is required';
    }

    if (currentPassword == newPassword) {
      return 'New password must be different from current password';
    }

    // Password strength validation
    if (newPassword.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // Check for uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(newPassword)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(newPassword)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for digit
    if (!RegExp(r'\d').hasMatch(newPassword)) {
      return 'Password must contain at least one number';
    }

    // Check for special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(newPassword)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }
}
