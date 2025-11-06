import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

/// Base class for all profile events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load current user profile
class LoadCurrentProfile extends ProfileEvent {
  const LoadCurrentProfile();
}

/// Event to refresh profile data
class RefreshProfile extends ProfileEvent {
  const RefreshProfile();
}

/// Event to update profile information
class UpdateProfileEvent extends ProfileEvent {
  final UserProfile profile;

  const UpdateProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Event to upload profile image
class UploadProfileImage extends ProfileEvent {
  final File imageFile;

  const UploadProfileImage(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

/// Event to delete profile image
class DeleteProfileImage extends ProfileEvent {
  const DeleteProfileImage();
}

/// Event to change password
class ChangePasswordEvent extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// Event to update email
class UpdateEmail extends ProfileEvent {
  final String newEmail;

  const UpdateEmail(this.newEmail);

  @override
  List<Object?> get props => [newEmail];
}

/// Event to delete account
class DeleteAccount extends ProfileEvent {
  const DeleteAccount();
}

/// Event to reset profile state
class ResetProfileState extends ProfileEvent {
  const ResetProfileState();
}
