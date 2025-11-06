import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

/// Implementation of ProfileRepository
///
/// Coordinates between remote and local data sources
/// Implements error handling and data transformation
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, UserProfile>> getCurrentProfile() async {
    try {
      // Try to get from remote
      final profile = await remoteDataSource.getCurrentProfile();

      // Cache the profile
      await localDataSource.cacheProfile(profile);

      return Right(profile.toEntity());
    } catch (e) {
      // Try to get from cache if remote fails
      try {
        final cachedProfile = await localDataSource.getCachedProfile();
        if (cachedProfile != null) {
          return Right(cachedProfile.toEntity());
        }
      } catch (cacheError) {
        // Ignore cache errors
      }

      return Left('Failed to get current profile: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, UserProfile>> getProfileById(String userId) async {
    try {
      final profile = await remoteDataSource.getProfileById(userId);
      return Right(profile.toEntity());
    } catch (e) {
      return Left('Failed to get profile: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, UserProfile>> updateProfile(UserProfile profile) async {
    try {
      final profileModel = UserProfileModel.fromEntity(profile);
      final updatedProfile = await remoteDataSource.updateProfile(profileModel);

      // Update cache
      await localDataSource.cacheProfile(updatedProfile);

      return Right(updatedProfile.toEntity());
    } catch (e) {
      return Left('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> uploadProfileImage(File imageFile) async {
    try {
      // Get current profile to get user ID
      final profileResult = await getCurrentProfile();
      if (profileResult.isLeft()) {
        return Left('Failed to get current user ID');
      }

      final profile = profileResult.getOrElse(() => UserProfile.empty());
      final imageUrl = await remoteDataSource.uploadProfileImage(
        imageFile,
        profile.id,
      );

      // Update profile with new image URL
      final updatedProfile = profile.copyWith(
        profileImageUrl: imageUrl,
        updatedAt: DateTime.now(),
      );
      await updateProfile(updatedProfile);

      return Right(imageUrl);
    } catch (e) {
      return Left('Failed to upload profile image: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> deleteProfileImage() async {
    try {
      // Get current profile
      final profileResult = await getCurrentProfile();
      if (profileResult.isLeft()) {
        return Left('Failed to get current profile');
      }

      final profile = profileResult.getOrElse(() => UserProfile.empty());

      // Delete image from storage
      await remoteDataSource.deleteProfileImage(profile.id);

      return Right(true);
    } catch (e) {
      return Left('Failed to delete profile image: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final result = await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Future<Either<String, bool>> updateEmail(String newEmail) async {
    try {
      final result = await remoteDataSource.updateEmail(newEmail);

      // Refresh cached profile
      await getCurrentProfile();

      return Right(result);
    } catch (e) {
      return Left('Failed to update email: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> deleteAccount() async {
    try {
      final result = await remoteDataSource.deleteAccount();

      // Clear local cache
      await localDataSource.clearCache();

      return Right(result);
    } catch (e) {
      return Left('Failed to delete account: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> isEmailAvailable(String email) async {
    try {
      final result = await remoteDataSource.isEmailAvailable(email);
      return Right(result);
    } catch (e) {
      return Left('Failed to check email availability: ${e.toString()}');
    }
  }
}
