import 'dart:io';
import 'package:dartz/dartz.dart';
import '../repositories/profile_repository.dart';

/// Use case for uploading profile image
///
/// This encapsulates the business logic for uploading
/// a user's profile image
class UploadProfileImage {
  final ProfileRepository repository;

  UploadProfileImage(this.repository);

  /// Execute the use case
  ///
  /// Parameters:
  /// - [imageFile]: The image file to upload
  ///
  /// Returns [Right(String)] with image URL on success
  /// Returns [Left(String)] with error message on failure
  Future<Either<String, String>> call(File imageFile) async {
    try {
      // Validate image file
      final validation = _validateImageFile(imageFile);
      if (validation != null) {
        return Left(validation);
      }

      return await repository.uploadProfileImage(imageFile);
    } catch (e) {
      return Left('Failed to upload profile image: ${e.toString()}');
    }
  }

  /// Validate image file
  String? _validateImageFile(File imageFile) {
    // Check if file exists
    if (!imageFile.existsSync()) {
      return 'Image file does not exist';
    }

    // Check file size (max 5MB)
    final fileSizeInBytes = imageFile.lengthSync();
    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    if (fileSizeInMB > 5) {
      return 'Image file size must be less than 5MB';
    }

    // Check file extension
    final extension = imageFile.path.split('.').last.toLowerCase();
    final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    if (!allowedExtensions.contains(extension)) {
      return 'Invalid image format. Allowed formats: ${allowedExtensions.join(', ')}';
    }

    return null;
  }
}
