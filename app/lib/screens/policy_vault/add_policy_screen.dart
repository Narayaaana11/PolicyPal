import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/policy_provider.dart';
import '../../services/api_service.dart';
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

  // PDF Upload state
  bool _isUploadingPDF = false;
  bool _pdfParsed = false;
  String? _pdfFileName;
  int? _pdfAccuracyScore;
  String? _pdfPageInfo;
  String? _pdfError;

  @override
  void dispose() {
    _providerController.dispose();
    _policyNumberController.dispose();
    _premiumAmountController.dispose();
    _coverageSummaryController.dispose();
    _nomineeController.dispose();
    super.dispose();
  }

  /// Pick a PDF file from the device and upload to backend for AI understanding
  void _pickAndUploadPDF() async {
    setState(() {
      _pdfError = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.path == null) {
        setState(() => _pdfError = 'Could not access the selected file.');
        return;
      }

      setState(() {
        _isUploadingPDF = true;
        _pdfParsed = false;
        _pdfFileName = file.name;
        _pdfError = null;
      });

      // Upload to backend — AI will parse the PDF
      final response = await ApiService.uploadPolicyPDF(File(file.path!));

      if (response != null && response['success'] == true) {
        final data = response['data'];
        final policy = data['policy'];
        final aiAnalysis = data['aiAnalysis'];
        final parsedFields = aiAnalysis?['parsedFields'] ?? {};
        final pdfInfo = aiAnalysis?['pdfInfo'] ?? {};

        // Auto-fill form fields with AI-parsed data
        setState(() {
          _type = policy['type'] ?? parsedFields['type'] ?? 'other';
          _providerController.text = policy['provider'] ?? parsedFields['provider'] ?? '';
          _policyNumberController.text = policy['policyNumber'] ?? parsedFields['policyNumber'] ?? '';
          _premiumAmountController.text = (policy['premiumAmount'] ?? parsedFields['premiumAmount'] ?? 0).toString();
          _premiumCadence = policy['premiumCadence'] ?? parsedFields['premiumCadence'] ?? 'yearly';
          _coverageSummaryController.text = policy['coverageSummary'] ?? parsedFields['coverageSummary'] ?? '';
          _nomineeController.text = policy['nominee'] ?? parsedFields['nominee'] ?? '';

          // Parse dates
          final startStr = policy['startDate'] ?? parsedFields['startDate'];
          final endStr = policy['endDate'] ?? parsedFields['endDate'];
          if (startStr != null) {
            _startDate = DateTime.tryParse(startStr.toString()) ?? DateTime.now();
          }
          if (endStr != null) {
            _endDate = DateTime.tryParse(endStr.toString()) ?? DateTime.now().add(const Duration(days: 365));
          }

          _pdfAccuracyScore = aiAnalysis?['accuracyScore'] ?? 85;
          _pdfPageInfo = '${pdfInfo['pageCount'] ?? '?'} pages • ${pdfInfo['fileSize'] ?? '?'}';
          _isUploadingPDF = false;
          _pdfParsed = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ AI parsed your PDF! Policy already saved to vault.'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          // Policy was already created by the backend, so go back
          context.pop();
        }
      } else {
        setState(() {
          _isUploadingPDF = false;
          _pdfError = 'Failed to parse PDF. Try again or enter details manually.';
        });
      }
    } catch (e) {
      setState(() {
        _isUploadingPDF = false;
        _pdfError = e.toString().replaceAll('Exception: ', '');
      });
    }
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
                    'Add Policy',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  Text(
                    'Upload a PDF for AI auto-fill, or enter details manually.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 20),

                  // ── PDF Upload Section ──────────────────────────────
                  LuxuryCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        if (_isUploadingPDF) ...[
                          const SizedBox(height: 8),
                          const CircularProgressIndicator(color: AppTheme.primaryColor),
                          const SizedBox(height: 16),
                          Text(
                            'AI is reading your policy PDF...',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.alabasterGrey,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _pdfFileName ?? 'Processing document',
                            style: const TextStyle(fontSize: 12, color: AppTheme.dustyDenim),
                          ),
                          const SizedBox(height: 8),
                        ] else ...[
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.picture_as_pdf, color: AppTheme.primaryColor, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      '📄 Upload Policy PDF',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'AI will read & understand your policy document automatically',
                                      style: TextStyle(fontSize: 12, color: AppTheme.dustyDenim),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: AppTheme.inkBlack,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              onPressed: _pickAndUploadPDF,
                              icon: const Icon(Icons.upload_file),
                              label: const Text(
                                'Choose Policy PDF',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                        if (_pdfError != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.dangerColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: AppTheme.dangerColor, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _pdfError!,
                                    style: const TextStyle(fontSize: 12, color: AppTheme.dangerColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (_pdfParsed) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: AppTheme.successColor, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '✅ PDF Parsed — AI Confidence: ${_pdfAccuracyScore ?? 85}%',
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.successColor),
                                      ),
                                      if (_pdfPageInfo != null)
                                        Text(
                                          _pdfPageInfo!,
                                          style: const TextStyle(fontSize: 11, color: AppTheme.dustyDenim),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1),

                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      '─── or enter details manually ───',
                      style: TextStyle(fontSize: 12, color: AppTheme.dustyDenim.withOpacity(0.6)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Policy Catalog Search ──────────────────────────
                  Autocomplete<Map<String, dynamic>>(
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<Map<String, dynamic>>.empty();
                      }
                      final results = await ApiService.fetchPolicyCatalog(textEditingValue.text);
                      return results.map((e) => e as Map<String, dynamic>);
                    },
                    displayStringForOption: (Map<String, dynamic> option) => '${option['provider']} - ${option['policyName']}',
                    onSelected: (Map<String, dynamic> selection) {
                      setState(() {
                        _providerController.text = selection['provider'] ?? '';
                        _type = selection['type'] ?? 'other';
                        _coverageSummaryController.text = selection['coverageSummary'] ?? '';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Auto-filled details for ${selection['policyName']}')),
                      );
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        style: const TextStyle(color: AppTheme.alabasterGrey),
                        decoration: InputDecoration(
                          labelText: '🔍 Search Policy Catalog (Auto-fill)',
                          labelStyle: const TextStyle(color: AppTheme.goldenOrange),
                          filled: true,
                          fillColor: AppTheme.goldenOrange.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppTheme.goldenOrange),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppTheme.goldenOrange.withOpacity(0.5)),
                          ),
                        ),
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 40,
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.prussianBlue,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.goldenOrange.withOpacity(0.5)),
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options.elementAt(index);
                                return ListTile(
                                  title: Text('${option['provider']} - ${option['policyName']}', style: const TextStyle(color: AppTheme.alabasterGrey, fontSize: 14)),
                                  subtitle: Text(option['type'].toString().toUpperCase(), style: const TextStyle(color: AppTheme.dustyDenim, fontSize: 12)),
                                  onTap: () => onSelected(option),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
                  const SizedBox(height: 24),

                  LuxuryCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildDropdownField(
                          label: 'Policy Type',
                          value: _type,
                          items: ['health', 'auto', 'life', 'home', 'travel', 'other'],
                          onChanged: (val) => setState(() => _type = val!),
                        ).animate().fadeIn(delay: 350.ms).slideX(begin: 0.1),
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

