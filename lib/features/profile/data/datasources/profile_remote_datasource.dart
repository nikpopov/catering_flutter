import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_profile_model.dart';

/// Remote data source for profile operations using Firebase
///
/// Handles all Firebase Firestore and Storage operations for user profiles
abstract class ProfileRemoteDataSource {
  /// Get current user profile from Firebase
  Future<UserProfileModel> getCurrentProfile();

  /// Get profile by user ID from Firebase
  Future<UserProfileModel> getProfileById(String userId);

  /// Update user profile in Firebase
  Future<UserProfileModel> updateProfile(UserProfileModel profile);

  /// Upload profile image to Firebase Storage
  Future<String> uploadProfileImage(File imageFile, String userId);

  /// Delete profile image from Firebase Storage
  Future<bool> deleteProfileImage(String userId);

  /// Change user password in Firebase Auth
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Update email in Firebase Auth
  Future<bool> updateEmail(String newEmail);

  /// Delete user account from Firebase
  Future<bool> deleteAccount();

  /// Check if email is available
  Future<bool> isEmailAvailable(String email);
}

/// Implementation of ProfileRemoteDataSource
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  ProfileRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
    required this.storage,
  });

  @override
  Future<UserProfileModel> getCurrentProfile() async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      return await getProfileById(currentUser.uid);
    } catch (e) {
      throw Exception('Failed to get current profile: ${e.toString()}');
    }
  }

  @override
  Future<UserProfileModel> getProfileById(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        throw Exception('User profile not found');
      }

      final data = doc.data()!;
      return UserProfileModel.fromJson({
        'id': doc.id,
        ...data,
      });
    } catch (e) {
      throw Exception('Failed to get profile: ${e.toString()}');
    }
  }

  @override
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Update Firestore document
      final updatedData = profile.toJson();
      updatedData['updatedAt'] = DateTime.now().toIso8601String();

      await firestore.collection('users').doc(profile.id).update(updatedData);

      // Get updated profile
      return await getProfileById(profile.id);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      // Create storage reference
      final ref = storage.ref().child('profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload file
      final uploadTask = await ref.putFile(imageFile);

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: ${e.toString()}');
    }
  }

  @override
  Future<bool> deleteProfileImage(String userId) async {
    try {
      // Get current profile to find image URL
      final profile = await getProfileById(userId);

      if (profile.profileImageUrl == null) {
        return true; // No image to delete
      }

      // Delete from storage
      final ref = storage.refFromURL(profile.profileImageUrl!);
      await ref.delete();

      // Update profile to remove image URL
      await firestore.collection('users').doc(userId).update({
        'profileImageUrl': null,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      throw Exception('Failed to delete profile image: ${e.toString()}');
    }
  }

  @override
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception('No authenticated user found');
      }

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      return true;
    } catch (e) {
      if (e.toString().contains('wrong-password')) {
        throw Exception('Current password is incorrect');
      }
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }

  @override
  Future<bool> updateEmail(String newEmail) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Update email in Firebase Auth
      await user.updateEmail(newEmail);

      // Update email in Firestore
      await firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      throw Exception('Failed to update email: ${e.toString()}');
    }
  }

  @override
  Future<bool> deleteAccount() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Delete user data from Firestore
      await firestore.collection('users').doc(user.uid).delete();

      // Delete profile image if exists
      try {
        await deleteProfileImage(user.uid);
      } catch (e) {
        // Ignore image deletion errors
      }

      // Delete user account from Firebase Auth
      await user.delete();

      return true;
    } catch (e) {
      throw Exception('Failed to delete account: ${e.toString()}');
    }
  }

  @override
  Future<bool> isEmailAvailable(String email) async {
    try {
      final methods = await auth.fetchSignInMethodsForEmail(email);
      return methods.isEmpty;
    } catch (e) {
      throw Exception('Failed to check email availability: ${e.toString()}');
    }
  }
}
