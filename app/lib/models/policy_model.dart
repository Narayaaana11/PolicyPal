class PolicyModel {
  final String id;
  final String userId;
  final String type;
  final String provider;
  final String policyNumber;
  final double premiumAmount;
  final String premiumCadence;
  final DateTime startDate;
  final DateTime endDate;
  final String coverageSummary;
  final List<String> exclusions;
  final String? documentUrl;
  final String extractedText;
  final String nominee;
  final String status;

  PolicyModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.provider,
    required this.policyNumber,
    required this.premiumAmount,
    required this.premiumCadence,
    required this.startDate,
    required this.endDate,
    required this.coverageSummary,
    required this.exclusions,
    this.documentUrl,
    required this.extractedText,
    required this.nominee,
    required this.status,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      type: json['type'] ?? 'other',
      provider: json['provider'] ?? '',
      policyNumber: json['policyNumber'] ?? '',
      premiumAmount: (json['premiumAmount'] as num?)?.toDouble() ?? 0.0,
      premiumCadence: json['premiumCadence'] ?? 'yearly',
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      coverageSummary: json['coverageSummary'] ?? '',
      exclusions: List<String>.from(json['exclusions'] ?? []),
      documentUrl: json['documentUrl'],
      extractedText: json['extractedText'] ?? '',
      nominee: json['nominee'] ?? '',
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'type': type,
      'provider': provider,
      'policyNumber': policyNumber,
      'premiumAmount': premiumAmount,
      'premiumCadence': premiumCadence,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'coverageSummary': coverageSummary,
      'exclusions': exclusions,
      'documentUrl': documentUrl,
      'extractedText': extractedText,
      'nominee': nominee,
      'status': status,
    };
  }

  int get daysUntilRenewal {
    final now = DateTime.now();
    return endDate.difference(now).inDays;
  }
}
