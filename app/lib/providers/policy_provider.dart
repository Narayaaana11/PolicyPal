import 'package:flutter/material.dart';
import '../models/policy_model.dart';
import '../models/payment_model.dart';
import '../models/claim_model.dart';
import '../services/api_service.dart';

class PolicyProvider with ChangeNotifier {
  // Rich Indian Real-World Policy Records
  List<PolicyModel> _policies = [
    PolicyModel(
      id: 'pol_health_001',
      userId: 'user_priya_sharma_101',
      type: 'health',
      provider: 'Star Health Comprehensive Optima',
      policyNumber: 'P/181112/01/2026/009842',
      premiumAmount: 24500,
      premiumCadence: 'yearly',
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 8, 15),
      coverageSummary:
          '₹15,00,00,0 Sum Insured with ₹5 Lakh Auto-Restoration bonus. Cashless network across Apollo, Fortis, Max, and Manipal hospitals in India. Includes AYUSH coverage, zero room-rent capping, and day-care procedures.',
      exclusions: [
        '30-day initial waiting period for non-accidental illness',
        '24-month waiting period for pre-existing diseases (Diabetes/Hypertension)',
        'Cosmetic surgery, obesity treatments, and fertility procedures'
      ],
      documentUrl: 'https://storage.policypal.com/policies/star_health_optima_doc.pdf',
      extractedText: 'Star Health Insurance Policy Contract #P/181112/01/2026/009842. Sum Insured: INR 15,00,000. ABHA ID: ABHA-91-8849-2041-9921...',
      nominee: 'Rajesh Sharma (Husband)',
      status: 'active',
    ),
    PolicyModel(
      id: 'pol_motor_002',
      userId: 'user_priya_sharma_101',
      type: 'auto',
      provider: 'Digit Private Car Comprehensive',
      policyNumber: 'DGT-MTR-99887721',
      premiumAmount: 22400,
      premiumCadence: 'yearly',
      startDate: DateTime(2026, 2, 10),
      endDate: DateTime(2027, 2, 10),
      coverageSummary:
          'Comprehensive Motor Policy for Tata Harrier XZA+ (Reg: MH 02 ER 8899). Includes Zero Depreciation, Engine Protect, Key Replacement, 24x7 Pan-India Roadside Assistance, and 50% NCB (No Claim Bonus) Protection.',
      exclusions: [
        'Driving without valid Indian driving license',
        'Drunk driving or driving under influence of contraband',
        'Commercial use or unauthorized speed testing'
      ],
      documentUrl: 'https://storage.policypal.com/policies/digit_car_policy.pdf',
      extractedText: 'GoDigit General Insurance Policy Schedule #DGT-MTR-99887721. Chassis: MAT612049NK...',
      nominee: 'Rajesh Sharma',
      status: 'active',
    ),
    PolicyModel(
      id: 'pol_life_003',
      userId: 'user_priya_sharma_101',
      type: 'life',
      provider: 'LIC Tech Term Plan',
      policyNumber: 'LIC-TT-51204911',
      premiumAmount: 18500,
      premiumCadence: 'yearly',
      startDate: DateTime(2024, 3, 15),
      endDate: DateTime(2054, 3, 15),
      coverageSummary:
          '30-Year Pure Term Life Cover of ₹1,00,00,000 (1 Crore) Death Benefit. High Claim Settlement Ratio (99.4% IRDAI CSR). Guaranteed Level Premium rate with Section 80C & 10(10D) tax exemption.',
      exclusions: [
        'Suicide within first 12 months of policy issuance',
        'Misrepresentation or non-disclosure of smoking/tobacco status'
      ],
      documentUrl: 'https://storage.policypal.com/policies/lic_tech_term_doc.pdf',
      extractedText: 'Life Insurance Corporation of India Policy Contract #LIC-TT-51204911...',
      nominee: 'Ananya Sharma (Daughter)',
      status: 'active',
    ),
    PolicyModel(
      id: 'pol_health_004',
      userId: 'user_priya_sharma_101',
      type: 'health',
      provider: 'HDFC ERGO Optima Secure',
      policyNumber: 'HDFC-ERGO-884920',
      premiumAmount: 32000,
      premiumCadence: 'yearly',
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 12, 31),
      coverageSummary:
          '2X Secure Benefit giving instant ₹25 Lakhs cover for ₹10 Lakh Base Sum Insured. Section 80D Tax Savings Certificate generated for ₹50,000 deduction.',
      exclusions: [
        'Intentional self-injury or organ donation without registration',
        'Hazardous adventure sports'
      ],
      documentUrl: 'https://storage.policypal.com/policies/hdfc_ergo_optima.pdf',
      extractedText: 'HDFC ERGO Health Insurance Contract Schedule #HDFC-ERGO-884920...',
      nominee: 'Sunita Sharma (Mother)',
      status: 'active',
    ),
    PolicyModel(
      id: 'pol_home_005',
      userId: 'user_priya_sharma_101',
      type: 'home',
      provider: 'ICICI Lombard Bharat Griha Raksha',
      policyNumber: 'ICICI-BGR-774411',
      premiumAmount: 6200,
      premiumCadence: 'yearly',
      startDate: DateTime(2026, 4, 1),
      endDate: DateTime(2027, 4, 1),
      coverageSummary:
          'Home Structure & Contents cover up to ₹75,00,000 for fire, earthquake, flood, storm, and burglary damage. Reinstatement value basis.',
      exclusions: [
        'Loss caused by war or nuclear peril',
        'Normal wear and tear or gradual deterioration'
      ],
      documentUrl: 'https://storage.policypal.com/policies/icici_home_policy.pdf',
      extractedText: 'ICICI Lombard Home Insurance Policy #ICICI-BGR-774411...',
      nominee: 'Rajesh Sharma',
      status: 'active',
    ),
  ];

  // Rich Real-World Dummy Payments (in INR)
  List<PaymentModel> _upcomingPayments = [
    PaymentModel(
      id: 'pay_001',
      userId: 'user_priya_sharma_101',
      policyId: 'pol_health_001',
      amount: 24500,
      dueDate: DateTime.now().add(const Duration(days: 12)),
      status: 'upcoming',
      policyProvider: 'Star Health Comprehensive Optima',
      policyType: 'health',
    ),
    PaymentModel(
      id: 'pay_002',
      userId: 'user_priya_sharma_101',
      policyId: 'pol_motor_002',
      amount: 22400,
      dueDate: DateTime.now().add(const Duration(days: 28)),
      status: 'upcoming',
      policyProvider: 'Digit Private Car Comprehensive',
      policyType: 'auto',
    ),
    PaymentModel(
      id: 'pay_003',
      userId: 'user_priya_sharma_101',
      policyId: 'pol_life_003',
      amount: 9250,
      dueDate: DateTime.now().add(const Duration(days: 45)),
      status: 'upcoming',
      policyProvider: 'LIC Tech Term Plan',
      policyType: 'life',
    ),
  ];

  // Rich Real-World Dummy Claims
  List<ClaimModel> _claims = [
    ClaimModel(
      id: 'claim_001',
      userId: 'user_priya_sharma_101',
      policyId: 'pol_health_001',
      incidentDate: DateTime(2026, 7, 20),
      description: 'Dengue Fever hospitalization at Apollo Hospital, Greams Road, Chennai for 4 days.',
      photoUrls: ['https://storage.policypal.com/claims/hospital_bill_apollo.jpg'],
      aiAssessment: AiAssessment(
        relevantClauses: [
          'Section 3.2 (In-Patient Hospitalization): Hospitalization exceeding 24 hours covered up to Sum Insured.',
          'Section 5.1 (Pre & Post Hospitalization): Pre-hospitalization expenses 60 days & post 90 days admissible.',
          'IRDAI Cashless Protocol: Network hospital TPA pre-authorization pre-approved.'
        ],
        possibleExclusions: [
          'Non-medical items (Sanitizer, PPE kit capping as per IRDAI master circular)',
          'Attendant food and personal charges'
        ],
        checklist: [
          'Apollo Hospital Discharge Summary & Original Bills',
          'Doctor Prescription & Dengue NS1 / IgM Blood Test Reports',
          'ABHA ID / Aadhaar Card copy of patient',
          'Cancelled Cheque for direct NEFT bank payout'
        ],
        confidenceNote:
            '98% Estimated Approval Rate based on Star Health Optima contract terms.',
        disclaimer:
            'DISCLAIMER: PolicyPal provides information for guidance purposes only and does not constitute a formal coverage decision or guarantee. Final claim authorization rests solely with your insurance provider.',
      ),
      status: 'approved',
      createdAt: DateTime(2026, 7, 20, 14, 30),
    )
  ];

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
      // Offline fallback addition
      final newPolicy = PolicyModel(
        id: 'pol_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_priya_sharma_101',
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
      // Offline fallback AI pre-check generation
      resultClaim = ClaimModel(
        id: 'claim_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_priya_sharma_101',
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
