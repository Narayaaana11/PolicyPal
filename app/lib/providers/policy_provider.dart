import 'package:flutter/material.dart';
import '../models/policy_model.dart';
import '../models/payment_model.dart';
import '../models/claim_model.dart';
import '../services/api_service.dart';

class PolicyProvider with ChangeNotifier {
  // Start empty — always fetch from real API
  List<PolicyModel> _policies = [];
  List<PaymentModel> _upcomingPayments = [];
  List<ClaimModel> _claims = [];

  bool _isLoading = false;
  bool _policiesLoaded = false;
  String? _error;

  List<PolicyModel> get policies => _policies;
  List<PaymentModel> get upcomingPayments => _upcomingPayments;
  List<ClaimModel> get claims => _claims;
  bool get isLoading => _isLoading;
  bool get policiesLoaded => _policiesLoaded;
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

  double get totalAnnualPremium =>
      _policies.fold(0.0, (sum, p) => sum + p.premiumAmount);

  // ── POLICIES ──────────────────────────────────────────────
  Future<void> fetchPolicies() async {
    if (_isLoading) return;
    _setLoading(true);
    _error = null;
    try {
      final response = await ApiService.get('/policies');
      if (response['data'] != null) {
        _policies = (response['data'] as List)
            .map((item) => PolicyModel.fromJson(item))
            .toList();
      } else {
        _policies = [];
      }
      _policiesLoaded = true;
    } catch (e) {
      _error = 'Failed to load policies. Check your connection.';
      _policies = [];
    }
    _setLoading(false);
  }

  Future<bool> createPolicy(Map<String, dynamic> policyData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.post('/policies', policyData);
      final newPolicy = PolicyModel.fromJson(response['data']);
      _policies.insert(0, newPolicy);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePolicy(String policyId) async {
    try {
      await ApiService.delete('/policies/$policyId');
      _policies.removeWhere((p) => p.id == policyId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── PAYMENTS ──────────────────────────────────────────────
  Future<void> fetchUpcomingPayments() async {
    try {
      final response = await ApiService.get('/payments/upcoming');
      if (response['data'] != null) {
        _upcomingPayments = (response['data'] as List)
            .map((item) => PaymentModel.fromJson(item))
            .toList();
      } else {
        _upcomingPayments = [];
      }
    } catch (_) {
      _upcomingPayments = [];
    }
    notifyListeners();
  }

  Future<bool> markPaymentPaid(String paymentId) async {
    try {
      await ApiService.patch('/payments/$paymentId/mark-paid');
      _upcomingPayments.removeWhere((p) => p.id == paymentId);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── CLAIMS ──────────────────────────────────────────────
  Future<ClaimModel?> submitClaim(Map<String, dynamic> claimData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.post('/claims', claimData);
      final resultClaim = ClaimModel.fromJson(response['data']);
      _claims.insert(0, resultClaim);
      _isLoading = false;
      notifyListeners();
      return resultClaim;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> fetchClaims() async {
    try {
      final response = await ApiService.get('/claims');
      if (response['data'] != null) {
        _claims = (response['data'] as List)
            .map((item) => ClaimModel.fromJson(item))
            .toList();
      } else {
        _claims = [];
      }
    } catch (_) {
      _claims = [];
    }
    notifyListeners();
  }

  void clearAll() {
    _policies = [];
    _upcomingPayments = [];
    _claims = [];
    _policiesLoaded = false;
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
