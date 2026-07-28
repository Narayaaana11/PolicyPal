import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class ExportReportScreen extends StatefulWidget {
  const ExportReportScreen({super.key});

  @override
  State<ExportReportScreen> createState() => _ExportReportScreenState();
}

class _ExportReportScreenState extends State<ExportReportScreen> {
  bool _isExporting = false;

  void _handleExport() async {
    setState(() => _isExporting = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isExporting = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report successfully downloaded to your device!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Download a comprehensive report containing all your stored policies, payment histories, and claim records.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 32),
            const Text('Format', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppTheme.primaryColor),
              ),
              tileColor: AppTheme.primaryColor.withOpacity(0.1),
              leading: const Icon(Icons.picture_as_pdf, color: AppTheme.primaryColor),
              title: const Text('PDF Document (Recommended)', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.check_circle, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 12),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.transparent),
              ),
              tileColor: AppTheme.cardColor,
              leading: const Icon(Icons.table_chart, color: AppTheme.textSecondary),
              title: const Text('Excel Spreadsheet (.xlsx)', style: TextStyle(color: AppTheme.textSecondary)),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isExporting ? null : _handleExport,
                child: _isExporting
                    ? const CircularProgressIndicator(color: AppTheme.inkBlack)
                    : const Text('Generate & Download Report'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
