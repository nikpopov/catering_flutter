import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/error_widget.dart' as custom;
import '../../../../shared/widgets/loading_indicator.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_menu_item.dart';
import 'edit_profile_screen.dart';

/// Profile screen showing user profile information and settings
///
/// Displays user profile with options to:
/// - View and edit profile information
/// - Change password
/// - Manage account settings
/// - View balance (for customers)
/// - Logout
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile on screen init
    context.read<ProfileBloc>().add(const LoadCurrentProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profile',
        showBackButton: false,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // Show success messages
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }

          // Show error messages
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
          if (state is ProfileLoading) {
            return const Center(child: CustomLoadingIndicator());
          }

          if (state is ProfileError && state.currentProfile == null) {
            return Center(
              child: custom.CustomErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<ProfileBloc>().add(const LoadCurrentProfile());
                },
              ),
            );
          }

          // Get profile from state
          final profile = _getProfileFromState(state);

          if (profile == null) {
            return const Center(
              child: Text('No profile data available'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileBloc>().add(const RefreshProfile());
              // Wait for refresh to complete
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile header with image and name
                  ProfileHeader(profile: profile),
                  const SizedBox(height: 24),

                  // Profile information card
                  ProfileInfoCard(profile: profile),
                  const SizedBox(height: 24),

                  // Account settings section
                  _buildSectionTitle('Account Settings'),
                  const SizedBox(height: 12),
                  _buildSettingsMenu(context, profile),
                  const SizedBox(height: 24),

                  // Logout button
                  _buildLogoutButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Get profile from any state that contains it
  dynamic _getProfileFromState(ProfileState state) {
    if (state is ProfileLoaded) return state.profile;
    if (state is ProfileUpdated) return state.profile;
    if (state is ProfileUpdating) return state.currentProfile;
    if (state is ImageUploading) return state.currentProfile;
    if (state is ImageUploaded) return state.profile;
    if (state is ProfileError) return state.currentProfile;
    return null;
  }

  /// Build section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// Build settings menu
  Widget _buildSettingsMenu(BuildContext context, dynamic profile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.edit,
            title: 'Edit Profile',
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(profile: profile),
                ),
              );

              // Refresh profile if edited
              if (result == true && mounted) {
                context.read<ProfileBloc>().add(const RefreshProfile());
              }
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              _showChangePasswordDialog(context);
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              // TODO: Navigate to notifications settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications settings')),
              );
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              // TODO: Navigate to help
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support')),
              );
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () {
              // TODO: Show privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy Policy')),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build logout button
  Widget _buildLogoutButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        _showLogoutConfirmDialog(context);
      },
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text(
        'Logout',
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.red, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Show change password dialog
  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final current = currentPasswordController.text;
              final newPass = newPasswordController.text;
              final confirm = confirmPasswordController.text;

              if (newPass != confirm) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passwords do not match'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              context.read<ProfileBloc>().add(
                    ChangePasswordEvent(
                      currentPassword: current,
                      newPassword: newPass,
                    ),
                  );

              Navigator.pop(dialogContext);
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // TODO: Implement logout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logging out...')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
