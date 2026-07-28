class PaymentModel {
  final String id;
  final String userId;
  final String policyId;
  final double amount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String status;
  final String? policyProvider;
  final String? policyType;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.policyId,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    required this.status,
    this.policyProvider,
    this.policyType,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    String? provider;
    String? type;
    String pId = '';

    if (json['policyId'] is Map) {
      pId = json['policyId']['_id'] ?? '';
      provider = json['policyId']['provider'];
      type = json['policyId']['type'];
    } else if (json['policyId'] is String) {
      pId = json['policyId'];
    }

    return PaymentModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      policyId: pId,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
      paidDate: json['paidDate'] != null ? DateTime.tryParse(json['paidDate']) : null,
      status: json['status'] ?? 'upcoming',
      policyProvider: provider,
      policyType: type,
    );
  }
}
