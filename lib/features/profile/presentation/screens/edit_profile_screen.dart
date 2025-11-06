import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_image_picker.dart';

/// Edit profile screen for updating user information
///
/// Allows users to update:
/// - Profile image
/// - Full name
/// - Phone number
/// - Address
class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.profile.fullName);
    _phoneController = TextEditingController(text: widget.profile.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.profile.address ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Edit Profile',
        showBackButton: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Return to previous screen with success result
            Navigator.pop(context, true);
          }

          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileUpdating || state is ImageUploading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile image picker
                  ProfileImagePicker(
                    imageUrl: widget.profile.profileImageUrl,
                    onImageSelected: (imageFile) {
                      context.read<ProfileBloc>().add(
                            UploadProfileImage(imageFile),
                          );
                    },
                    onImageDeleted: () {
                      context.read<ProfileBloc>().add(
                            const DeleteProfileImage(),
                          );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Email (read-only)
                  CustomTextField(
                    label: 'Email',
                    initialValue: widget.profile.email,
                    enabled: false,
                    prefixIcon: Icons.email,
                    helperText: 'Email cannot be changed',
                  ),
                  const SizedBox(height: 16),

                  // Full name
                  CustomTextField(
                    label: 'Full Name',
                    controller: _fullNameController,
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone number
                  CustomTextField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
                        if (!phoneRegex.hasMatch(value)) {
                          return 'Invalid phone number format';
                        }
                        if (value.replaceAll(RegExp(r'\D'), '').length < 10) {
                          return 'Phone number must be at least 10 digits';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Address
                  CustomTextField(
                    label: 'Address',
                    controller: _addressController,
                    prefixIcon: Icons.location_on,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Role (read-only)
                  CustomTextField(
                    label: 'Role',
                    initialValue: widget.profile.role.displayName,
                    enabled: false,
                    prefixIcon: Icons.badge,
                  ),
                  const SizedBox(height: 32),

                  // Save button
                  CustomButton(
                    text: 'Save Changes',
                    onPressed: isLoading ? null : _saveProfile,
                    isLoading: isLoading,
                    isFullWidth: true,
                    size: ButtonSize.large,
                  ),
                  const SizedBox(height: 16),

                  // Cancel button
                  CustomButton(
                    text: 'Cancel',
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    variant: ButtonVariant.secondary,
                    isFullWidth: true,
                    size: ButtonSize.large,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Save profile changes
  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = widget.profile.copyWith(
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        updatedAt: DateTime.now(),
      );

      context.read<ProfileBloc>().add(UpdateProfileEvent(updatedProfile));
    }
  }
}
