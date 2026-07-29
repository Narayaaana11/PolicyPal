import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:policypal/services/api_service.dart';
import '../utils/app_theme.dart';
import 'luxury_card.dart';

class ExplainClauseModal extends StatefulWidget {
  final String? initialClause;

  const ExplainClauseModal({super.key, this.initialClause});

  static void show(BuildContext context, {String? clause}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExplainClauseModal(initialClause: clause),
    );
  }

  @override
  State<ExplainClauseModal> createState() => _ExplainClauseModalState();
}

class _ExplainClauseModalState extends State<ExplainClauseModal> {
  late TextEditingController _clauseController;
  bool _isExplaining = false;
  Map<String, String>? _explanationResult;

  final List<String> _sampleClauses = [
    'Room Rent Capped at 1% of Sum Insured per day with Proportionate Deduction.',
    'Copayment: 20% on all claims for insured members above 60 years of age.',
    'Pre-Existing Disease (PED) Waiting Period of 36 Months.',
    'Consumables & Hygiene items excluded under Section 4.2 IRDAI Master Circular.',
    'NCB Retained 50% on Zero-Dep motor claim with NCB Protector Rider.',
  ];

  @override
  void initState() {
    super.initState();
    _clauseController = TextEditingController(text: widget.initialClause ?? _sampleClauses[0]);
    if (widget.initialClause != null) {
      _analyzeClause(widget.initialClause!);
    }
  }

  @override
  void dispose() {
    _clauseController.dispose();
    super.dispose();
  }

  void _analyzeClause(String clauseText) async {
    if (clauseText.trim().isEmpty) return;
    HapticFeedback.lightImpact();

    setState(() {
      _isExplaining = true;
      _explanationResult = null;
    });

    Map<String, String>? result;

    try {
      // Call live OpenRouter-powered backend endpoint
      final response = await ApiService.explainClause(clauseText);
      if (response != null && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        result = {
          'plainEnglish': data['plainEnglish']?.toString() ?? '',
          'financialImpact': data['financialImpact']?.toString() ?? '',
          'proTip': data['proTip']?.toString() ?? '',
        };
      }
    } catch (_) {}

    // Local fallback if API call fails
    if (result == null || result['plainEnglish']!.isEmpty) {
      final textLower = clauseText.toLowerCase();

      if (textLower.contains('room rent') || textLower.contains('proportionate')) {
        result = {
          'plainEnglish': 'If your room rent exceeds 1% of your sum insured (e.g. ₹5,000/day on ₹5 Lakh policy), the insurer will reduce your ENTIRE hospital bill (doctors fees, ICU, surgery) proportionately by that ratio!',
          'financialImpact': 'High Financial Risk! A ₹2,000/day excess room choice can result in a ₹50,000+ out-of-pocket deduction across all doctor charges.',
          'proTip': 'Choose hospital rooms strictly within your daily limit or buy a No-Room-Rent-Capping Rider.',
        };
      } else if (textLower.contains('copay') || textLower.contains('co-pay') || textLower.contains('copayment')) {
        result = {
          'plainEnglish': 'You agree to pay a fixed percentage (e.g. 20%) of every admissible claim bill yourself, while the insurer pays the remaining 80%.',
          'financialImpact': 'On a ₹2,00,000 admissible hospital claim with 20% Copay, you pay ₹40,000 and insurer pays ₹1,60,000.',
          'proTip': 'Common in senior citizen policies. Keep liquid savings ready for your copay share at discharge.',
        };
      } else if (textLower.contains('waiting period') || textLower.contains('ped') || textLower.contains('pre-existing')) {
        result = {
          'plainEnglish': 'Pre-existing medical conditions (like Diabetes, Hypertension, Asthma) declared at purchase will NOT be covered until you complete 36 continuous policy months.',
          'financialImpact': 'Any hospitalization related directly or indirectly to PED during first 3 years will be rejected.',
          'proTip': 'Never let your policy lapse! Porting to a new insurer carries over your completed waiting period months.',
        };
      } else {
        result = {
          'plainEnglish': 'This clause specifies conditions under which your claim is processed according to IRDAI guidelines and insurer policy schedules.',
          'financialImpact': 'Ensure all pre-authorization forms & diagnostic test reports are submitted within 24 hours of hospital admission.',
          'proTip': 'Verify with your hospital TPA desk before discharge to avoid last-minute delays.',
        };
      }
    }

    if (mounted) {
      setState(() {
        _isExplaining = false;
        _explanationResult = result;
      });
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: AppTheme.prussianBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        border: Border.all(color: AppTheme.duskBlue.withValues(alpha: 0.5)),
      ),
      child: SingleChildScrollView(
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
                Icon(Icons.lightbulb_outlined, color: AppTheme.primaryColor, size: 28),
                SizedBox(width: 12),
                Text(
                  'Explain This Clause',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Translates fine-print insurance jargon into plain English & financial impact.',
              style: TextStyle(fontSize: 13, color: AppTheme.dustyDenim),
            ),
            const SizedBox(height: 20),

            // Sample Selectors
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _sampleClauses.map((clause) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      label: Text(
                        clause.length > 30 ? '${clause.substring(0, 30)}...' : clause,
                        style: const TextStyle(fontSize: 11, color: AppTheme.alabasterGrey),
                      ),
                      backgroundColor: AppTheme.inkBlack,
                      side: BorderSide(color: AppTheme.duskBlue.withValues(alpha: 0.5)),
                      onPressed: () {
                        _clauseController.text = clause;
                        _analyzeClause(clause);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _clauseController,
              maxLines: 3,
              style: const TextStyle(color: AppTheme.alabasterGrey, fontSize: 13),
              decoration: InputDecoration(
                labelText: 'Paste Insurance Clause Text',
                labelStyle: const TextStyle(color: AppTheme.dustyDenim),
                filled: true,
                fillColor: AppTheme.inkBlack.withValues(alpha: 0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppTheme.duskBlue.withValues(alpha: 0.3)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: AppTheme.inkBlack,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => _analyzeClause(_clauseController.text),
                icon: const Icon(Icons.auto_awesome, color: AppTheme.inkBlack, size: 20),
                label: const Text('Explain in Plain English', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),

            if (_isExplaining) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: AppTheme.primaryColor),
                ),
              ),
            ] else if (_explanationResult != null) ...[
              LuxuryCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡 Plain-English Summary', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    Text(_explanationResult!['plainEnglish']!, style: const TextStyle(color: AppTheme.alabasterGrey, fontSize: 13, height: 1.5)),
                    const Divider(color: AppTheme.duskBlue, height: 24),
                    Text('💵 Out-of-Pocket Financial Impact', style: TextStyle(color: AppTheme.goldenOrange, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    Text(_explanationResult!['financialImpact']!, style: const TextStyle(color: AppTheme.dustyDenim, fontSize: 13, height: 1.4)),
                    const Divider(color: AppTheme.duskBlue, height: 24),
                    const Text('🛡️ Pro Tip & Action Item', style: TextStyle(color: AppTheme.successColor, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    Text(_explanationResult!['proTip']!, style: const TextStyle(color: AppTheme.alabasterGrey, fontSize: 13, height: 1.4)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
