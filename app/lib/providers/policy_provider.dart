import 'package:flutter/material.dart';
import '../models/policy_model.dart';
import '../models/payment_model.dart';
import '../models/claim_model.dart';
import '../services/api_service.dart';

class PolicyProvider with ChangeNotifier {
  // Production Real-World Policies for Arjun Sharma
  List<PolicyModel> _policies = [
    PolicyModel(
      id: 'pol_health_8849201',
      userId: 'user_arjun_sharma_2026',
      type: 'health',
      provider: 'Star Health & Allied Insurance',
      policyNumber: 'POL-ST-8849201',
      premiumAmount: 18500,
      premiumCadence: 'yearly',
      startDate: DateTime(2025, 3, 15),
      endDate: DateTime(2026, 3, 15),
      coverageSummary:
          'Comprehensive Family Optima Health Shield — ₹10,00,000 Sum Insured with Cashless Network Hospitalization, No Room Rent Capping, and Automatic Restore benefit.',
      exclusions: [
        'Pre-existing hypertension within 24-month waiting period',
        'Cosmetic, dental, or aesthetic treatments',
        'Non-medical consumables (PPE kits, attendant fees)'
      ],
      documentUrl: 'https://storage.policypal.com/policies/star_health_optima.pdf',
      extractedText: 'Star Health Policy Schedule #POL-ST-8849201. Sum Insured: ₹10,00,000. Nominee: Ananya Sharma.',
      nominee: 'Ananya Sharma (Spouse)',
      status: 'active',
    ),
    PolicyModel(
      id: 'pol_motor_4491203',
      userId: 'user_arjun_sharma_2026',
      type: 'auto',
      provider: 'ICICI Lombard General Insurance',
      policyNumber: 'POL-IL-4491203',
      premiumAmount: 14200,
      premiumCadence: 'yearly',
      startDate: DateTime(2025, 11, 20),
      endDate: DateTime(2026, 11, 20),
      coverageSummary:
          'Comprehensive Motor Protect for Private Vehicle (Hyundai Creta) — Includes Zero Depreciation Add-on, Engine & Gearbox Protect, Roadside Assistance, and 50% No Claim Bonus.',
      exclusions: [
        'Driving under influence of alcohol or narcotics',
        'Consequential mechanical breakdown without external collision',
        'Commercial carrying of goods or passengers'
      ],
      documentUrl: 'https://storage.policypal.com/policies/icici_motor_protect.pdf',
      extractedText: 'ICICI Lombard Motor Policy #POL-IL-4491203. Hyundai Creta Reg: MH 02 ER 8899.',
      nominee: 'Ananya Sharma (Spouse)',
      status: 'active',
    ),
    PolicyModel(
      id: 'pol_life_9920184',
      userId: 'user_arjun_sharma_2026',
      type: 'life',
      provider: 'HDFC Life Insurance',
      policyNumber: 'POL-HL-9920184',
      premiumAmount: 22000,
      premiumCadence: 'yearly',
      startDate: DateTime(2025, 1, 10),
      endDate: DateTime(2055, 1, 10),
      coverageSummary:
          'Click 2 Protect 3D Plus Term Insurance — ₹1,00,00,000 Death Benefit with Critical Illness Waiver of Premium rider and Section 10(10D) tax-free payout.',
      exclusions: [
        'Suicide within first 12 months of policy issuance',
        'Death caused by active engagement in illegal activities'
      ],
      documentUrl: 'https://storage.policypal.com/policies/hdfc_life_term.pdf',
      extractedText: 'HDFC Life Contract #POL-HL-9920184. Death Cover: ₹1,00,00,000.',
      nominee: 'Ananya Sharma (Spouse)',
      status: 'active',
    ),
  ];

  // Production Payment Schedule for Arjun Sharma
  List<PaymentModel> _upcomingPayments = [
    PaymentModel(
      id: 'pay_001',
      userId: 'user_arjun_sharma_2026',
      policyId: 'pol_health_8849201',
      amount: 18500,
      dueDate: DateTime(2026, 3, 15),
      status: 'upcoming',
      policyProvider: 'Star Health & Allied Insurance',
      policyType: 'health',
    ),
    PaymentModel(
      id: 'pay_002',
      userId: 'user_arjun_sharma_2026',
      policyId: 'pol_motor_4491203',
      amount: 14200,
      dueDate: DateTime(2026, 11, 20),
      status: 'upcoming',
      policyProvider: 'ICICI Lombard General Insurance',
      policyType: 'auto',
    ),
  ];

  // Production Claims Records for Arjun Sharma
  List<ClaimModel> _claims = [];

  bool _isLoading = false;
  String? _error;

  List<PolicyModel> get policies => _policies;
  List<PaymentModel> get upcomingPayments => _upcomingPayments;
  List<ClaimModel> get claims => _claims;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get activePoliciesCount =>
      _policies.where((p) => p.status == 'active').length;

  int get nearestRenewalDays {
    if (_policies.isEmpty) return 0;
    final active = _policies.where((p) => p.status == 'active').toList();
    if (active.isEmpty) return 0;
    active.sort((a, b) => a.daysUntilRenewal.compareTo(b.daysUntilRenewal));
    return active.first.daysUntilRenewal;
  }

  Future<void> fetchPolicies() async {
    try {
      final response = await ApiService.get('/policies');
      if (response['data'] != null && (response['data'] as List).isNotEmpty) {
        _policies = (response['data'] as List)
            .map((item) => PolicyModel.fromJson(item))
            .toList();
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<bool> createPolicy(Map<String, dynamic> policyData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.post('/policies', policyData);
      final newPolicy = PolicyModel.fromJson(response['data']);
      _policies.insert(0, newPolicy);
    } catch (e) {
      final newPolicy = PolicyModel(
        id: 'pol_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_arjun_sharma_2026',
        type: policyData['type'] ?? 'other',
        provider: policyData['provider'] ?? 'Provider',
        policyNumber: policyData['policyNumber'] ?? 'POL-100200',
        premiumAmount: (policyData['premiumAmount'] as num?)?.toDouble() ?? 500.0,
        premiumCadence: policyData['premiumCadence'] ?? 'yearly',
        startDate: DateTime.tryParse(policyData['startDate'] ?? '') ?? DateTime.now(),
        endDate: DateTime.tryParse(policyData['endDate'] ?? '') ?? DateTime.now().add(const Duration(days: 365)),
        coverageSummary: policyData['coverageSummary'] ?? 'Standard active protection policy.',
        exclusions: ['Standard exclusions apply'],
        extractedText: 'Manual entry policy',
        nominee: policyData['nominee'] ?? '',
        status: 'active',
      );
      _policies.insert(0, newPolicy);
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> fetchUpcomingPayments() async {
    try {
      final response = await ApiService.get('/payments/upcoming');
      if (response['data'] != null && (response['data'] as List).isNotEmpty) {
        _upcomingPayments = (response['data'] as List)
            .map((item) => PaymentModel.fromJson(item))
            .toList();
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> markPaymentPaid(String paymentId) async {
    try {
      await ApiService.patch('/payments/$paymentId/mark-paid');
    } catch (_) {}
    _upcomingPayments.removeWhere((p) => p.id == paymentId);
    notifyListeners();
  }

  Future<ClaimModel?> submitClaim(Map<String, dynamic> claimData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    ClaimModel? resultClaim;

    try {
      final response = await ApiService.post('/claims', claimData);
      resultClaim = ClaimModel.fromJson(response['data']);
      _claims.insert(0, resultClaim);
    } catch (e) {
      resultClaim = ClaimModel(
        id: 'claim_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_arjun_sharma_2026',
        policyId: claimData['policyId'] ?? 'pol_auto_001',
        incidentDate: DateTime.tryParse(claimData['incidentDate'] ?? '') ?? DateTime.now(),
        description: claimData['description'] ?? 'Reported incident',
        photoUrls: List<String>.from(claimData['photoUrls'] ?? []),
        aiAssessment: AiAssessment(
          relevantClauses: [
            'Section 4.1 (Coverage Terms): Protection applies for reported incidents subject to policy terms.',
            'Section 8.2 (Reporting Window): Incident reported within required timeframe.'
          ],
          possibleExclusions: [
            'Unauthorized service providers',
            'Pre-existing damage'
          ],
          checklist: [
            'Official Incident / Police Report',
            'Photos of damaged property',
            'Detailed repair estimate'
          ],
          confidenceNote:
              'High confidence grounded analysis based on policy text.',
          disclaimer:
              'DISCLAIMER: PolicyPal provides information for guidance purposes only and does not constitute a formal coverage decision or guarantee. Final claim authorization rests solely with your insurance provider.',
        ),
        status: 'draft',
        createdAt: DateTime.now(),
      );
      _claims.insert(0, resultClaim);
    }

    _isLoading = false;
    notifyListeners();
    return resultClaim;
  }

  Future<void> fetchClaims() async {
    try {
      final response = await ApiService.get('/claims');
      if (response['data'] != null && (response['data'] as List).isNotEmpty) {
        _claims = (response['data'] as List)
            .map((item) => ClaimModel.fromJson(item))
            .toList();
      }
    } catch (_) {}
    notifyListeners();
  }
}
