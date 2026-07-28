import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/policy_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/luxury_card.dart';

class AddPolicyScreen extends StatefulWidget {
  const AddPolicyScreen({super.key});

  @override
  State<AddPolicyScreen> createState() => _AddPolicyScreenState();
}

class _AddPolicyScreenState extends State<AddPolicyScreen> {
  final _formKey = GlobalKey<FormState>();

  String _type = 'auto';
  final _providerController = TextEditingController();
  final _policyNumberController = TextEditingController();
  final _premiumAmountController = TextEditingController();
  String _premiumCadence = 'yearly';
  final _coverageSummaryController = TextEditingController();
  final _nomineeController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));

  @override
  void dispose() {
    _providerController.dispose();
    _policyNumberController.dispose();
    _premiumAmountController.dispose();
    _coverageSummaryController.dispose();
    _nomineeController.dispose();
    super.dispose();
  }

  void _submitPolicy() async {
    if (_formKey.currentState!.validate()) {
      final policyProvider = Provider.of<PolicyProvider>(context, listen: false);

      final success = await policyProvider.createPolicy({
        'type': _type,
        'provider': _providerController.text.trim(),
        'policyNumber': _policyNumberController.text.trim(),
        'premiumAmount': double.parse(_premiumAmountController.text.trim()),
        'premiumCadence': _premiumCadence,
        'startDate': _startDate.toIso8601String(),
        'endDate': _endDate.toIso8601String(),
        'coverageSummary': _coverageSummaryController.text.trim(),
        'nominee': _nomineeController.text.trim(),
      });

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Policy added to vault successfully!')),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final policyProvider = Provider.of<PolicyProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Add Insurance Policy'),
        iconTheme: const IconThemeData(color: AppTheme.alabasterGrey),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.premiumGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manual Policy Entry',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  Text(
                    'Enter policy details below to add to your vault.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 32),

                  LuxuryCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildDropdownField(
                          label: 'Policy Type',
                          value: _type,
                          items: ['health', 'auto', 'life', 'home', 'travel', 'other'],
                          onChanged: (val) => setState(() => _type = val!),
                        ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _providerController,
                          label: 'Insurance Provider (e.g., Geico)',
                          validator: (val) => val == null || val.isEmpty ? 'Provider is required' : null,
                        ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _policyNumberController,
                          label: 'Policy Number',
                          validator: (val) => val == null || val.isEmpty ? 'Policy number is required' : null,
                        ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _premiumAmountController,
                                label: 'Premium (\$)',
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    val == null || double.tryParse(val) == null ? 'Valid amount required' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdownField(
                                label: 'Cadence',
                                value: _premiumCadence,
                                items: ['monthly', 'quarterly', 'yearly'],
                                onChanged: (val) => setState(() => _premiumCadence = val!),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: _buildDateTile(
                                label: 'Start Date',
                                date: _startDate,
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _startDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2040),
                                  );
                                  if (picked != null) setState(() => _startDate = picked);
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDateTile(
                                label: 'End Date',
                                date: _endDate,
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _endDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2040),
                                  );
                                  if (picked != null) setState(() => _endDate = picked);
                                },
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _coverageSummaryController,
                          label: 'Coverage Summary (Optional)',
                          maxLines: 2,
                        ).animate().fadeIn(delay: 800.ms).slideX(begin: 0.1),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _nomineeController,
                          label: 'Nominee Name (Optional)',
                        ).animate().fadeIn(delay: 900.ms).slideX(begin: 0.1),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: AppTheme.inkBlack,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: policyProvider.isLoading ? null : _submitPolicy,
                      child: policyProvider.isLoading
                          ? const CircularProgressIndicator(color: AppTheme.inkBlack)
                          : const Text('Save Policy to Vault', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ).animate().fadeIn(delay: 1000.ms).scale(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppTheme.alabasterGrey),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.dustyDenim),
        filled: true,
        fillColor: AppTheme.inkBlack.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.duskBlue.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: AppTheme.prussianBlue,
      style: const TextStyle(color: AppTheme.alabasterGrey),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.dustyDenim),
        filled: true,
        fillColor: AppTheme.inkBlack.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.duskBlue.withOpacity(0.3)),
        ),
      ),
      items: items.map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase()))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateTile({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.inkBlack.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.duskBlue.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.dustyDenim)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: AppTheme.alabasterGrey, fontSize: 14),
                ),
                const Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
