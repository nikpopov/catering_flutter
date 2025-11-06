import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';

/// Local data source for profile caching using SharedPreferences
///
/// Handles caching of user profile data for offline access
abstract class ProfileLocalDataSource {
  /// Get cached profile
  Future<UserProfileModel?> getCachedProfile();

  /// Cache profile data
  Future<void> cacheProfile(UserProfileModel profile);

  /// Clear cached profile
  Future<void> clearCache();
}

/// Implementation of ProfileLocalDataSource
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _cachedProfileKey = 'CACHED_USER_PROFILE';

  ProfileLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<UserProfileModel?> getCachedProfile() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedProfileKey);
      if (jsonString == null) {
        return null;
      }

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return UserProfileModel.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to get cached profile: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheProfile(UserProfileModel profile) async {
    try {
      final jsonString = json.encode(profile.toJson());
      await sharedPreferences.setString(_cachedProfileKey, jsonString);
    } catch (e) {
      throw Exception('Failed to cache profile: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_cachedProfileKey);
    } catch (e) {
      throw Exception('Failed to clear cache: ${e.toString()}');
    }
  }
}
