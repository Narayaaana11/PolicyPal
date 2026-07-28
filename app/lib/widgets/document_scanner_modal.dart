import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/policy_provider.dart';
import '../utils/app_theme.dart';
import 'luxury_card.dart';

class DocumentScannerModal extends StatefulWidget {
  const DocumentScannerModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DocumentScannerModal(),
    );
  }

  @override
  State<DocumentScannerModal> createState() => _DocumentScannerModalState();
}

class _DocumentScannerModalState extends State<DocumentScannerModal> {
  bool _isScanning = false;
  bool _scanCompleted = false;

  final Map<String, String> _extractedData = {
    'provider': 'Digit General Insurance',
    'type': 'auto',
    'policyNumber': 'DIGIT-MOT-889911',
    'premiumAmount': '12500',
    'premiumCadence': 'yearly',
    'startDate': '2026-01-01',
    'endDate': '2027-01-01',
    'coverageSummary': 'Comprehensive Motor Policy with Zero Depreciation and 24/7 Roadside Assistance.',
    'exclusions': 'Racing, Drunk driving, Normal wear & tear',
    'nominee': 'Rahul Sharma',
  };

  void _startScan() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _isScanning = true;
      _scanCompleted = false;
    });

    await Future.delayed(const Duration(milliseconds: 1800));

    if (mounted) {
      setState(() {
        _isScanning = false;
        _scanCompleted = true;
      });
      HapticFeedback.heavyImpact();
    }
  }

  void _saveScannedPolicy() async {
    HapticFeedback.mediumImpact();
    final provider = Provider.of<PolicyProvider>(context, listen: false);

    final success = await provider.createPolicy({
      'provider': _extractedData['provider'],
      'type': _extractedData['type'],
      'policyNumber': _extractedData['policyNumber'],
      'premiumAmount': double.tryParse(_extractedData['premiumAmount']!) ?? 10000,
      'premiumCadence': _extractedData['premiumCadence'],
      'startDate': DateTime.tryParse(_extractedData['startDate']!)?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'endDate': DateTime.tryParse(_extractedData['endDate']!)?.toIso8601String() ?? DateTime.now().add(const Duration(days: 365)).toIso8601String(),
      'coverageSummary': _extractedData['coverageSummary'],
      'exclusions': _extractedData['exclusions']!.split(','),
      'nominee': _extractedData['nominee'],
    });

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Scanned policy saved directly into your Vault!' : 'Saved to Vault!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.prussianBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        border: Border.all(color: AppTheme.duskBlue.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.dustyDenim.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Icon(Icons.document_scanner_outlined, color: AppTheme.primaryColor, size: 28),
              SizedBox(width: 12),
              Text(
                'AI OCR Document Scanner',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Scan or upload an Indian policy schedule photo/PDF to automatically extract structured terms.',
            style: TextStyle(fontSize: 13, color: AppTheme.dustyDenim),
          ),
          const SizedBox(height: 24),

          if (!_isScanning && !_scanCompleted) ...[
            LuxuryCard(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cloud_upload_outlined, color: AppTheme.primaryColor, size: 48),
                    ),
                    const SizedBox(height: 16),
                    const Text('Upload Policy Document (JPG, PNG, PDF)', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey)),
                    const SizedBox(height: 6),
                    const Text('Digit, Star Health, LIC, HDFC ERGO schedule cards supported', style: TextStyle(fontSize: 12, color: AppTheme.dustyDenim)),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: AppTheme.inkBlack,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _startScan,
                      icon: const Icon(Icons.center_focus_strong),
                      label: const Text('Simulate Camera OCR Scan', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (_isScanning) ...[
            LuxuryCard(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(color: AppTheme.primaryColor),
                    SizedBox(height: 20),
                    Text('Analyzing Policy Document via AI OCR...', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey)),
                    SizedBox(height: 8),
                    Text('Extracting Insurer, Sum Insured, Clauses & Exclusions...', style: TextStyle(fontSize: 12, color: AppTheme.dustyDenim)),
                  ],
                ),
              ),
            ),
          ] else if (_scanCompleted) ...[
            LuxuryCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('✅ OCR Extraction Complete', style: TextStyle(color: AppTheme.successColor, fontWeight: FontWeight.bold)),
                      Badge(label: Text('99.4% Accuracy', style: TextStyle(fontSize: 10))),
                    ],
                  ),
                  const Divider(color: AppTheme.duskBlue, height: 24),
                  _buildDataRow('Insurer Provider:', _extractedData['provider']!),
                  _buildDataRow('Policy Number:', _extractedData['policyNumber']!),
                  _buildDataRow('Policy Type:', _extractedData['type']!.toUpperCase()),
                  _buildDataRow('Premium Amount:', '₹${_extractedData['premiumAmount']} (${_extractedData['premiumCadence']})'),
                  _buildDataRow('Effective Period:', '${_extractedData['startDate']} to ${_extractedData['endDate']}'),
                  _buildDataRow('Coverage Summary:', _extractedData['coverageSummary']!),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                  foregroundColor: AppTheme.alabasterGrey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _saveScannedPolicy,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Review & Save to Vault', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.dustyDenim, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13, color: AppTheme.alabasterGrey, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
