import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

/// Base class for all profile states
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Loading state
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Profile loaded successfully
class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Profile update in progress
class ProfileUpdating extends ProfileState {
  final UserProfile currentProfile;

  const ProfileUpdating(this.currentProfile);

  @override
  List<Object?> get props => [currentProfile];
}

/// Profile updated successfully
class ProfileUpdated extends ProfileState {
  final UserProfile profile;
  final String message;

  const ProfileUpdated(this.profile, {this.message = 'Profile updated successfully'});

  @override
  List<Object?> get props => [profile, message];
}

/// Image upload in progress
class ImageUploading extends ProfileState {
  final UserProfile currentProfile;

  const ImageUploading(this.currentProfile);

  @override
  List<Object?> get props => [currentProfile];
}

/// Image uploaded successfully
class ImageUploaded extends ProfileState {
  final UserProfile profile;
  final String imageUrl;

  const ImageUploaded(this.profile, this.imageUrl);

  @override
  List<Object?> get props => [profile, imageUrl];
}

/// Password change in progress
class PasswordChanging extends ProfileState {
  const PasswordChanging();
}

/// Password changed successfully
class PasswordChanged extends ProfileState {
  final String message;

  const PasswordChanged({this.message = 'Password changed successfully'});

  @override
  List<Object?> get props => [message];
}

/// Email update in progress
class EmailUpdating extends ProfileState {
  const EmailUpdating();
}

/// Email updated successfully
class EmailUpdated extends ProfileState {
  final UserProfile profile;
  final String message;

  const EmailUpdated(this.profile, {this.message = 'Email updated successfully'});

  @override
  List<Object?> get props => [profile, message];
}

/// Account deletion in progress
class AccountDeleting extends ProfileState {
  const AccountDeleting();
}

/// Account deleted successfully
class AccountDeleted extends ProfileState {
  final String message;

  const AccountDeleted({this.message = 'Account deleted successfully'});

  @override
  List<Object?> get props => [message];
}

/// Error state
class ProfileError extends ProfileState {
  final String message;
  final UserProfile? currentProfile;

  const ProfileError(this.message, {this.currentProfile});

  @override
  List<Object?> get props => [message, currentProfile];
}

/// Profile operation success with message
class ProfileOperationSuccess extends ProfileState {
  final String message;
  final UserProfile? profile;

  const ProfileOperationSuccess(this.message, {this.profile});

  @override
  List<Object?> get props => [message, profile];
}
