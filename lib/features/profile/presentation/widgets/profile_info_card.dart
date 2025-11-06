import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';
import '../../../../shared/extensions/datetime_extensions.dart';

/// Profile information card showing detailed user information
///
/// Displays user details in a structured card format:
/// - Phone number
/// - Address
/// - Account balance (for customers)
/// - Member since date
class ProfileInfoCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileInfoCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            const Text(
              'Profile Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Phone number
            _buildInfoRow(
              icon: Icons.phone,
              label: 'Phone',
              value: profile.phoneNumber ?? 'Not provided',
              color: Colors.blue,
            ),
            const SizedBox(height: 12),

            // Address
            _buildInfoRow(
              icon: Icons.location_on,
              label: 'Address',
              value: profile.address ?? 'Not provided',
              color: Colors.red,
            ),
            const SizedBox(height: 12),

            // Balance (for customers)
            if (profile.isCustomer) ...[
              _buildInfoRow(
                icon: Icons.account_balance_wallet,
                label: 'Balance',
                value: profile.formattedBalance,
                color: Colors.green,
              ),
              const SizedBox(height: 12),
            ],

            // Member since
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Member Since',
              value: profile.createdAt.toFormattedDate(),
              color: Colors.purple,
            ),

            // Last updated
            if (profile.updatedAt != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.update,
                label: 'Last Updated',
                value: profile.updatedAt!.toFormattedDate(),
                color: Colors.orange,
              ),
            ],

            // Account status
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: profile.isActive ? Icons.check_circle : Icons.cancel,
              label: 'Status',
              value: profile.isActive ? 'Active' : 'Inactive',
              color: profile.isActive ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  /// Build information row
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
        const SizedBox(width: 12),

        // Label and value
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
