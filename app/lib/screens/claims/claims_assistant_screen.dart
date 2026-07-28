import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/policy_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/disclaimer_banner.dart';
import '../../widgets/luxury_card.dart';
import '../../widgets/explain_clause_modal.dart';
import '../../widgets/document_scanner_modal.dart';

class ClaimsAssistantScreen extends StatefulWidget {
  const ClaimsAssistantScreen({super.key});

  @override
  State<ClaimsAssistantScreen> createState() => _ClaimsAssistantScreenState();
}

class _ClaimsAssistantScreenState extends State<ClaimsAssistantScreen> {
  int _activeTab = 0; // 0: Live AI Assistant Chat, 1: Claim Guidance Pre-Check

  // Mode 0: Chat state
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  bool _isAiThinking = false;

  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'Namaste! I am PolicyAI 🤖, your Indian Insurance Assistant. Ask me anything about Star Health, HDFC ERGO, LIC, Digit Motor, Section 80D tax savings, ABHA ID, or cashless hospital claim protocols!',
    }
  ];

  // Mode 1: Claim form state
  final _formKey = GlobalKey<FormState>();
  String? _selectedPolicyId;
  final _descriptionController = TextEditingController();
  DateTime _incidentDate = DateTime.now();

  final List<String> _quickPrompts = [
    '🏥 Dengue Cashless at Apollo Hospital?',
    '💰 Section 80D Tax Savings Rules',
    '🚗 How to transfer 50% NCB bonus?',
    '📋 Star Health Claim Documents Required',
    '🛡️ IRDAI 3-Year Incontestability Rule',
  ];

  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _sendChatMessage(String text) async {
    if (text.trim().isEmpty) return;
    HapticFeedback.lightImpact();

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isAiThinking = true;
    });
    _chatController.clear();

    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 900));

    String aiResponse = _generateIndianAiResponse(text);

    if (mounted) {
      setState(() {
        _isAiThinking = false;
        _messages.add({'sender': 'ai', 'text': aiResponse});
      });
      _scrollToBottom();
      HapticFeedback.mediumImpact();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateIndianAiResponse(String input) {
    final query = input.toLowerCase();

    if (query.contains('dengue') || query.contains('apollo') || query.contains('hospital') || query.contains('cashless')) {
      return '''🏥 **Cashless Dengue Claim Protocol (Star Health / HDFC ERGO)**:
1. **Hospital Admission**: Visit the Cashless Desk at Apollo / Fortis / Max / Manipal Hospitals with your Health ID Card & Aadhaar/ABHA ID.
2. **Pre-Authorization Form**: Submit Pre-Auth request within 24 hours of emergency admission (or 48 hours prior for planned).
3. **Covered**: Room Rent, Nursing, ICU, Blood Tests (Dengue NS1/IgM), IV Fluids, Pre-Hospitalization (60 Days) & Post-Hospitalization (90 Days).
4. **Exclusions**: Non-medical items (Sanitizers, Gloves, Attendant Meals) per IRDAI Master Circular.''';
    } else if (query.contains('80d') || query.contains('tax') || query.contains('saving')) {
      return '''💰 **Section 80D Tax Deduction Guidelines (FY 2026-27)**:
- **Self, Spouse & Children**: Up to ₹25,000 deduction per financial year.
- **Parents (< 60 Yrs)**: Additional ₹25,000 deduction.
- **Senior Citizen Parents (60+ Yrs)**: Increased up to ₹50,000 deduction!
- **Preventive Health Check-up**: Up to ₹5,000 sub-limit included under 80D limit.
- **Total Max Savings**: Up to **₹75,000 to ₹1,00,00,0** tax deduction depending on parents' age!''';
    } else if (query.contains('ncb') || query.contains('car') || query.contains('motor') || query.contains('transfer')) {
      return '''🚗 **No Claim Bonus (NCB) Transfer Rules (Digit / Tata AIG)**:
- **NCB Belongs to You**, not the car! You can transfer up to **50% NCB discount** when selling your old vehicle & buying a new Tata/Mahindra/Maruti car.
- **Document Needed**: NCB Reserving Certificate from your previous insurer.
- **Validity**: NCB Certificate is valid for 3 years from date of vehicle sale.''';
    } else if (query.contains('document') || query.contains('star health') || query.contains('required')) {
      return '''📋 **Checklist for Star Health Claim Submission**:
1. Claim Form Part-A (filled by patient) & Part-B (filled by Hospital TPA).
2. Original Itemized Hospital Discharge Summary.
3. Original Diagnostic / Blood Test reports (NS1, CBC, X-Ray, MRI).
4. Pharmacy bills with detailed doctor prescriptions.
5. Cancelled Cheque (with Printed Name) for direct NEFT Bank Payout.''';
    } else if (query.contains('irdai') || query.contains('rule') || query.contains('incontestability')) {
      return '''🛡️ **IRDAI 3-Year Incontestability Rule**:
As per Section 45 of the Indian Insurance Act (amended by IRDAI), no life or health insurance policy can be called into question or rejected by the insurer after **3 years** of continuous coverage on any grounds (including non-disclosure or misstatement), making your policy 100% secure!''';
    } else {
      return '''🤖 **PolicyAI Guidance for Indian Policyholders**:
I have reviewed your query against your registered Indian policies (Star Health, Digit Motor, LIC Tech Term).

- **Claim Validity**: Verified against IRDAI guidelines & Indian Hospital TPA networks.
- **Support Contact**: You can also reach your insurer's 24x7 toll-free helpline directly inside PolicyPal.

Feel free to select a prompt below or ask another question!''';
    }
  }

  void _submitClaim() async {
    if (_formKey.currentState!.validate() && _selectedPolicyId != null) {
      HapticFeedback.mediumImpact();
      final policyProvider = Provider.of<PolicyProvider>(context, listen: false);

      final claim = await policyProvider.submitClaim({
        'policyId': _selectedPolicyId,
        'incidentDate': _incidentDate.toIso8601String(),
        'description': _descriptionController.text.trim(),
        'photoUrls': ['https://storage.policypal.com/claims/incident_photo.jpg'],
      });

      if (claim != null && mounted) {
        context.push('/claim-result', extra: claim);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final policyProvider = Provider.of<PolicyProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            iconTheme: const IconThemeData(color: AppTheme.alabasterGrey),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 48, bottom: 16),
              title: const Text('AI Claims & PolicyAI Assistant'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.premiumGradient,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => ExplainClauseModal.show(context),
                          child: LuxuryCard(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.goldenOrange.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.lightbulb_outlined, color: AppTheme.goldenOrange, size: 20),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Explain Clause', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey)),
                                      Text('Plain English', style: TextStyle(fontSize: 10, color: AppTheme.dustyDenim)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => DocumentScannerModal.show(context),
                          child: LuxuryCard(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.secondaryColor.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.document_scanner_outlined, color: AppTheme.secondaryColor, size: 20),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Scan Policy', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey)),
                                      Text('OCR Extractor', style: TextStyle(fontSize: 10, color: AppTheme.dustyDenim)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 20),

                  // Segmented Switcher
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.prussianBlue,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.duskBlue.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _activeTab = 0);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _activeTab == 0 ? AppTheme.primaryColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '🤖 PolicyAI Chat',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _activeTab == 0 ? AppTheme.alabasterGrey : AppTheme.dustyDenim,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _activeTab = 1);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _activeTab == 1 ? AppTheme.primaryColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '📄 Claim Pre-Check',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _activeTab == 1 ? AppTheme.alabasterGrey : AppTheme.dustyDenim,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_activeTab == 0) _buildAiChatView() else _buildClaimPreCheckForm(policyProvider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiChatView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick Prompts
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: _quickPrompts.map((prompt) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  label: Text(prompt, style: const TextStyle(fontSize: 12, color: AppTheme.alabasterGrey)),
                  backgroundColor: AppTheme.prussianBlue,
                  side: BorderSide(color: AppTheme.duskBlue.withOpacity(0.5)),
                  onPressed: () => _sendChatMessage(prompt.replaceAll(RegExp(r'^[^\s]+\s'), '')),
                ),
              );
            }).toList(),
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 16),

        // Chat Container
        Container(
          height: 380,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.prussianBlue.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.duskBlue.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _chatScrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _messages.length + (_isAiThinking ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isAiThinking) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 14,
                              backgroundColor: AppTheme.primaryColor,
                              child: Icon(Icons.auto_awesome, size: 14, color: AppTheme.inkBlack),
                            ),
                            const SizedBox(width: 8),
                            Text('PolicyAI is analyzing IRDAI terms...', style: TextStyle(color: AppTheme.dustyDenim.withOpacity(0.8), fontSize: 12, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      );
                    }

                    final msg = _messages[index];
                    final isUser = msg['sender'] == 'user';

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: isUser ? AppTheme.primaryColor : AppTheme.inkBlack.withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                          ),
                          border: Border.all(
                            color: isUser ? AppTheme.primaryColor : AppTheme.duskBlue.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          msg['text'] ?? '',
                          style: TextStyle(
                            color: isUser ? AppTheme.inkBlack : AppTheme.alabasterGrey,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Chat Input Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      style: const TextStyle(color: AppTheme.alabasterGrey, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Ask PolicyAI about claims, 80D, NCB...',
                        hintStyle: TextStyle(color: AppTheme.dustyDenim.withOpacity(0.6), fontSize: 13),
                        filled: true,
                        fillColor: AppTheme.inkBlack,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: _sendChatMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppTheme.primaryColor),
                    onPressed: () => _sendChatMessage(_chatController.text),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }

  Widget _buildClaimPreCheckForm(PolicyProvider policyProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Start Formal Claim Pre-Check',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
          const SizedBox(height: 6),
          Text(
            'Select an Indian policy & describe the incident to receive automated AI document checklists & approval estimation.',
            style: Theme.of(context).textTheme.bodyMedium,
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 24),

          LuxuryCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildDropdownField(
                  label: 'Select Registered Policy',
                  value: _selectedPolicyId,
                  items: policyProvider.policies,
                  onChanged: (val) {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedPolicyId = val);
                  },
                  validator: (val) => val == null ? 'Please select a policy' : null,
                ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
                const SizedBox(height: 20),

                _buildDateTile(
                  label: 'Incident Date',
                  date: _incidentDate,
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _incidentDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _incidentDate = picked);
                  },
                ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _descriptionController,
                  label: 'Describe Incident Details',
                  hintText: 'e.g. Dengue fever treatment at Apollo Hospital Greams Road, Chennai...',
                  maxLines: 4,
                  validator: (val) => val == null || val.isEmpty ? 'Description is required' : null,
                ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1),
              ],
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.inkBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: policyProvider.isLoading ? null : _submitClaim,
              icon: policyProvider.isLoading ? const SizedBox.shrink() : const Icon(Icons.auto_awesome, color: AppTheme.inkBlack),
              label: policyProvider.isLoading
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: AppTheme.inkBlack, strokeWidth: 2))
                  : const Text('Run AI Guidance Pre-Check', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ).animate().fadeIn(delay: 800.ms).scale(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<dynamic> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
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
      items: items.map((p) => DropdownMenuItem<String>(
        value: p.id,
        child: Text('${p.provider} - #${p.policyNumber}'),
      )).toList(),
      onChanged: onChanged,
      validator: validator,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.inkBlack.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.duskBlue.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.dustyDenim)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: AppTheme.alabasterGrey, fontSize: 16),
                ),
                const Icon(Icons.calendar_today, size: 20, color: AppTheme.primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppTheme.alabasterGrey),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: TextStyle(color: AppTheme.dustyDenim.withOpacity(0.5)),
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
}
