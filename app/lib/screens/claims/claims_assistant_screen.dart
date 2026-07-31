import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/policy_provider.dart';
import '../../services/api_service.dart';
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
  int _activeTab = 0; // 0: Live AI Vision Assistant Chat, 1: Claim Guidance Pre-Check

  // Mode 0: Chat state
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  bool _isAiThinking = false;

  // Multimodal Vision state
  File? _selectedImageFile;
  String? _selectedImageBase64;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'ai',
      'text': 'Namaste! I am PolicyAI 🤖, your Vision-enabled Indian Insurance Assistant. Ask me anything or attach photos/documents of medical bills, policy receipts, or damage claims for instant visual analysis!',
      'suggestedActions': [
        '🏥 Dengue Cashless at Apollo Hospital?',
        '💰 Section 80D Tax Savings Rules',
        '🚗 How to transfer 50% NCB bonus?',
        '📋 Star Health Claim Documents Required',
      ],
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (photo != null) {
        final bytes = await photo.readAsBytes();
        setState(() {
          _selectedImageFile = File(photo.path);
          _selectedImageBase64 = base64Encode(bytes);
        });
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showAttachmentPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.prussianBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              children: [
                const Center(
                  child: Text(
                    'Attach Vision Document/Photo',
                    style: TextStyle(color: AppTheme.alabasterGrey, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: AppTheme.primaryColor),
                  title: const Text('Take Photo with Camera', style: TextStyle(color: AppTheme.alabasterGrey)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: AppTheme.secondaryColor),
                  title: const Text('Choose from Gallery', style: TextStyle(color: AppTheme.alabasterGrey)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendChatMessage(String text) async {
    final messageText = text.trim();
    if (messageText.isEmpty && _selectedImageBase64 == null) return;
    HapticFeedback.lightImpact();

    final String? attachedImagePath = _selectedImageFile?.path;
    final String? imagePayload = _selectedImageBase64;

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': messageText.isNotEmpty ? messageText : 'Uploaded image document for visual analysis.',
        'imagePath': attachedImagePath,
      });
      _isAiThinking = true;
      _selectedImageFile = null;
      _selectedImageBase64 = null;
    });
    _chatController.clear();
    _scrollToBottom();

    String aiResponse = '';
    List<String> suggestedActions = [];

    try {
      // Build conversation history format
      final history = _messages
          .where((m) => m['sender'] == 'user' || m['sender'] == 'ai')
          .take(6)
          .map((m) => {
                'role': m['sender'] == 'user' ? 'user' : 'assistant',
                'content': m['text'].toString(),
              })
          .toList();

      final result = await ApiService.sendAgentChat(
        message: messageText,
        imageBase64: imagePayload,
        conversationHistory: history,
      );

      if (result != null && result['data'] != null) {
        aiResponse = result['data']['reply'] ?? '';
        if (result['data']['suggestedActions'] != null) {
          suggestedActions = List<String>.from(result['data']['suggestedActions']);
        }
      }
    } catch (e) {
      debugPrint('AI Chat Error: $e');
    }

    if (aiResponse.trim().isEmpty) {
      aiResponse = _generateFallbackAiResponse(messageText, attachedImagePath != null);
      suggestedActions = [
        '🏥 Check Cashless Hospitalization',
        '💰 Section 80D Tax Savings Rules',
        '📋 Document Checklists',
      ];
    }

    if (mounted) {
      setState(() {
        _isAiThinking = false;
        _messages.add({
          'sender': 'ai',
          'text': aiResponse,
          'suggestedActions': suggestedActions,
        });
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

  String _generateFallbackAiResponse(String input, bool hasImage) {
    if (hasImage) {
      return '''🏥 **Vision Document Pre-Analysis (Offline Mode)**:
1. **Document Received**: Medical Bill / Insurance Document photo detected.
2. **Key Checks**: Ensure hospital name, patient name, date of admission, and itemized bill breakdown are clearly visible.
3. **Claim Readiness**: For Star Health / HDFC ERGO, upload this bill via the "Claim Pre-Check" tab to calculate your estimated payout!''';
    }

    final query = input.toLowerCase();
    if (query.contains('dengue') || query.contains('apollo') || query.contains('hospital') || query.contains('cashless')) {
      return '''🏥 **Cashless Dengue Claim Protocol (Star Health / HDFC ERGO)**:
1. **Hospital Admission**: Visit the Cashless Desk at Apollo / Fortis / Max / Manipal Hospitals with your Health ID Card & Aadhaar/ABHA ID.
2. **Pre-Authorization Form**: Submit Pre-Auth request within 24 hours of emergency admission.
3. **Covered**: Room Rent, Nursing, ICU, Blood Tests (Dengue NS1/IgM), IV Fluids, Pre-Hospitalization (60 Days) & Post-Hospitalization (90 Days).''';
    } else if (query.contains('80d') || query.contains('tax') || query.contains('saving')) {
      return '''💰 **Section 80D Tax Deduction Guidelines (FY 2026-27)**:
- **Self, Spouse & Children**: Up to ₹25,000 deduction per financial year.
- **Parents (< 60 Yrs)**: Additional ₹25,000 deduction.
- **Senior Citizen Parents (60+ Yrs)**: Increased up to ₹50,000 deduction!''';
    }
    return '''🤖 **PolicyAI Assistant**:
I am ready to help! You can check your active policies, review upcoming premium renewals, or attach photos of medical bills for visual analysis.''';
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
              title: const Text('AI Vision Claims Assistant'),
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
                      border: Border.all(color: AppTheme.duskBlue.withValues(alpha: 0.5)),
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
                                  '🤖 Vision AI Chat',
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
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
                  side: BorderSide(color: AppTheme.duskBlue.withValues(alpha: 0.5)),
                  onPressed: () => _sendChatMessage(prompt.replaceAll(RegExp(r'^[^\s]+\s'), '')),
                ),
              );
            }).toList(),
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 16),

        // Chat Container
        Container(
          height: MediaQuery.of(context).size.height * 0.50,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.prussianBlue.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.duskBlue.withValues(alpha: 0.3)),
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
                            Text('PolicyAI Vision is inspecting document...', style: TextStyle(color: AppTheme.dustyDenim.withValues(alpha: 0.8), fontSize: 12, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      );
                    }

                    final msg = _messages[index];
                    final isUser = msg['sender'] == 'user';
                    final hasImage = msg['imagePath'] != null;
                    final List<String> suggestions = msg['suggestedActions'] != null ? List<String>.from(msg['suggestedActions']) : [];

                    return Column(
                      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(14),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                            decoration: BoxDecoration(
                              color: isUser ? AppTheme.primaryColor : AppTheme.inkBlack.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                                bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                              ),
                              border: Border.all(
                                color: isUser ? AppTheme.primaryColor : AppTheme.duskBlue.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (hasImage) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(msg['imagePath']),
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                Text(
                                  msg['text'] ?? '',
                                  style: TextStyle(
                                    color: isUser ? AppTheme.inkBlack : AppTheme.alabasterGrey,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Suggested Action Chips under AI response
                        if (!isUser && suggestions.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: suggestions.map((chipText) {
                                return InkWell(
                                  onTap: () => _sendChatMessage(chipText),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.4)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.bolt, size: 12, color: AppTheme.primaryColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          chipText,
                                          style: const TextStyle(color: AppTheme.alabasterGrey, fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),

              // Selected Image Preview Bar
              if (_selectedImageFile != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.inkBlack,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryColor),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.file(_selectedImageFile!, width: 40, height: 40, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Attached Vision Image', style: TextStyle(color: AppTheme.alabasterGrey, fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('Ready for AI analysis', style: TextStyle(color: AppTheme.dustyDenim, fontSize: 10)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.redAccent, size: 18),
                        onPressed: () {
                          setState(() {
                            _selectedImageFile = null;
                            _selectedImageBase64 = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // Chat Input Row
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_a_photo_outlined, color: AppTheme.secondaryColor, size: 22),
                    onPressed: _showAttachmentPicker,
                    tooltip: 'Attach Image / Document for AI Vision',
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      style: const TextStyle(color: AppTheme.alabasterGrey, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: _selectedImageFile != null ? 'Ask about this image...' : 'Ask PolicyAI or attach doc...',
                        hintStyle: TextStyle(color: AppTheme.dustyDenim.withValues(alpha: 0.6), fontSize: 13),
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
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: AppTheme.inkBlack, size: 18),
                      onPressed: () => _sendChatMessage(_chatController.text),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClaimPreCheckForm(PolicyProvider policyProvider) {
    final activePolicies = policyProvider.policies;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DisclaimerBanner(
            customText: 'Claims Assistance Disclaimer: PolicyPal AI provides pre-check guidance based on your policy terms. Final claim approval is subject to your insurer\'s underwriting & claim assessment.',
          ),
          const SizedBox(height: 20),

          // Select Policy
          const Text('Select Policy for Claim', style: TextStyle(color: AppTheme.alabasterGrey, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedPolicyId,
            dropdownColor: AppTheme.prussianBlue,
            style: const TextStyle(color: AppTheme.alabasterGrey, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.prussianBlue,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.duskBlue)),
            ),
            hint: const Text('Choose active policy', style: TextStyle(color: AppTheme.dustyDenim)),
            items: activePolicies.map((p) {
              return DropdownMenuItem<String>(
                value: p.id,
                child: Text('${p.provider} (${p.type.toUpperCase()}) - #${p.policyNumber}'),
              );
            }).toList(),
            onChanged: (val) => setState(() => _selectedPolicyId = val),
            validator: (val) => val == null ? 'Please select a policy' : null,
          ),
          const SizedBox(height: 16),

          // Incident Description
          const Text('Incident / Medical Diagnosis Description', style: TextStyle(color: AppTheme.alabasterGrey, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            style: const TextStyle(color: AppTheme.alabasterGrey, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'e.g. Admitted to Apollo Hospital for Dengue fever treatment...',
              hintStyle: TextStyle(color: AppTheme.dustyDenim.withValues(alpha: 0.6)),
              filled: true,
              fillColor: AppTheme.prussianBlue,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.duskBlue)),
            ),
            validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter incident details' : null,
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submitClaim,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.inkBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Pre-Check & Submit Claim Guidance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
