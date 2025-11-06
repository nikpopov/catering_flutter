import 'package:dartz/dartz.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Use case for getting the current user's profile
///
/// This encapsulates the business logic for retrieving
/// the authenticated user's profile information
class GetCurrentProfile {
  final ProfileRepository repository;

  GetCurrentProfile(this.repository);

  /// Execute the use case
  ///
  /// Returns [Right(UserProfile)] on success
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, UserProfile>> call() async {
    try {
      return await repository.getCurrentProfile();
    } catch (e) {
      return Left('Failed to get current profile: ${e.toString()}');
    }
  }
}
