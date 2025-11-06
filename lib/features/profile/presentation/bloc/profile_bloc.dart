import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/get_current_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/upload_profile_image.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC for managing profile state and business logic
///
/// Handles all profile-related operations including:
/// - Loading and refreshing profile
/// - Updating profile information
/// - Uploading and deleting profile images
/// - Changing password
/// - Updating email
/// - Deleting account
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentProfile getCurrentProfile;
  final UpdateProfile updateProfile;
  final UploadProfileImage uploadProfileImage;
  final ChangePassword changePassword;

  UserProfile? _currentProfile;

  ProfileBloc({
    required this.getCurrentProfile,
    required this.updateProfile,
    required this.uploadProfileImage,
    required this.changePassword,
  }) : super(const ProfileInitial()) {
    on<LoadCurrentProfile>(_onLoadCurrentProfile);
    on<RefreshProfile>(_onRefreshProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UploadProfileImage>(_onUploadProfileImage);
    on<DeleteProfileImage>(_onDeleteProfileImage);
    on<ChangePasswordEvent>(_onChangePassword);
    on<UpdateEmail>(_onUpdateEmail);
    on<DeleteAccount>(_onDeleteAccount);
    on<ResetProfileState>(_onResetProfileState);
  }

  /// Handle loading current profile
  Future<void> _onLoadCurrentProfile(
    LoadCurrentProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await getCurrentProfile();

    result.fold(
      (error) => emit(ProfileError(error)),
      (profile) {
        _currentProfile = profile;
        emit(ProfileLoaded(profile));
      },
    );
  }

  /// Handle refreshing profile
  Future<void> _onRefreshProfile(
    RefreshProfile event,
    Emitter<ProfileState> emit,
  ) async {
    // Don't show loading state for refresh to avoid UI flicker
    final result = await getCurrentProfile();

    result.fold(
      (error) {
        // Keep current profile on refresh error
        if (_currentProfile != null) {
          emit(ProfileLoaded(_currentProfile!));
        } else {
          emit(ProfileError(error));
        }
      },
      (profile) {
        _currentProfile = profile;
        emit(ProfileLoaded(profile));
      },
    );
  }

  /// Handle updating profile
  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (_currentProfile != null) {
      emit(ProfileUpdating(_currentProfile!));
    } else {
      emit(const ProfileLoading());
    }

    final result = await updateProfile(event.profile);

    result.fold(
      (error) => emit(ProfileError(error, currentProfile: _currentProfile)),
      (profile) {
        _currentProfile = profile;
        emit(ProfileUpdated(profile));
        // Transition back to loaded state after a brief moment
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!emit.isDone) {
            emit(ProfileLoaded(profile));
          }
        });
      },
    );
  }

  /// Handle uploading profile image
  Future<void> _onUploadProfileImage(
    UploadProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    if (_currentProfile != null) {
      emit(ImageUploading(_currentProfile!));
    } else {
      emit(const ProfileLoading());
    }

    final result = await uploadProfileImage(event.imageFile);

    result.fold(
      (error) => emit(ProfileError(error, currentProfile: _currentProfile)),
      (imageUrl) {
        if (_currentProfile != null) {
          final updatedProfile = _currentProfile!.copyWith(
            profileImageUrl: imageUrl,
            updatedAt: DateTime.now(),
          );
          _currentProfile = updatedProfile;
          emit(ImageUploaded(updatedProfile, imageUrl));
          // Transition to loaded state
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!emit.isDone) {
              emit(ProfileLoaded(updatedProfile));
            }
          });
        }
      },
    );
  }

  /// Handle deleting profile image
  Future<void> _onDeleteProfileImage(
    DeleteProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    if (_currentProfile != null) {
      emit(ProfileUpdating(_currentProfile!));
    }

    if (_currentProfile != null) {
      final updatedProfile = _currentProfile!.copyWith(
        profileImageUrl: null,
        updatedAt: DateTime.now(),
      );

      final result = await updateProfile(updatedProfile);

      result.fold(
        (error) => emit(ProfileError(error, currentProfile: _currentProfile)),
        (profile) {
          _currentProfile = profile;
          emit(ProfileUpdated(profile, message: 'Profile image deleted'));
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!emit.isDone) {
              emit(ProfileLoaded(profile));
            }
          });
        },
      );
    }
  }

  /// Handle changing password
  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const PasswordChanging());

    final result = await changePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    result.fold(
      (error) => emit(ProfileError(error, currentProfile: _currentProfile)),
      (success) {
        emit(const PasswordChanged());
        // Return to loaded state if we have a profile
        if (_currentProfile != null) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (!emit.isDone) {
              emit(ProfileLoaded(_currentProfile!));
            }
          });
        }
      },
    );
  }

  /// Handle updating email
  Future<void> _onUpdateEmail(
    UpdateEmail event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const EmailUpdating());

    // This would call the repository method
    // For now, emit error as it needs implementation
    emit(ProfileError(
      'Email update not yet implemented',
      currentProfile: _currentProfile,
    ));
  }

  /// Handle deleting account
  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const AccountDeleting());

    // This would call the repository method
    // For now, emit error as it needs implementation
    emit(ProfileError(
      'Account deletion not yet implemented',
      currentProfile: _currentProfile,
    ));
  }

  /// Handle resetting profile state
  Future<void> _onResetProfileState(
    ResetProfileState event,
    Emitter<ProfileState> emit,
  ) async {
    if (_currentProfile != null) {
      emit(ProfileLoaded(_currentProfile!));
    } else {
      emit(const ProfileInitial());
    }
  }
}
