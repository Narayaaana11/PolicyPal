import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class FamilyVaultScreen extends StatelessWidget {
  const FamilyVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final familyMembers = [
      {'name': 'Rahul Sharma', 'relation': 'Spouse', 'policies': 2, 'status': 'Active'},
      {'name': 'Ananya Sharma', 'relation': 'Child', 'policies': 1, 'status': 'Active'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family / Group Vault'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Manage your shared household policies and invite family members to view coverage details.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
          const Text(
            'Linked Members',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 12),
          ...familyMembers.map((member) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                    child: Text(
                      member['name'].toString().substring(0, 1),
                      style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(member['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${member['relation']} • ${member['policies']} Shared Policies'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      member['status'] as String,
                      style: const TextStyle(color: AppTheme.secondaryColor, fontSize: 12),
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            icon: const Icon(Icons.person_add_outlined),
            label: const Text('Invite Family Member'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invitation link copied to clipboard.')),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          )
        ],
      ),
    );
  }
}
