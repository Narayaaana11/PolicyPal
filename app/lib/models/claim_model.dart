class AiAssessment {
  final List<String> relevantClauses;
  final List<String> possibleExclusions;
  final List<String> checklist;
  final String confidenceNote;
  final String disclaimer;

  AiAssessment({
    required this.relevantClauses,
    required this.possibleExclusions,
    required this.checklist,
    required this.confidenceNote,
    required this.disclaimer,
  });

  factory AiAssessment.fromJson(Map<String, dynamic> json) {
    return AiAssessment(
      relevantClauses: List<String>.from(json['relevantClauses'] ?? []),
      possibleExclusions: List<String>.from(json['possibleExclusions'] ?? []),
      checklist: List<String>.from(json['checklist'] ?? []),
      confidenceNote: json['confidenceNote'] ?? '',
      disclaimer: json['disclaimer'] ??
          'DISCLAIMER: PolicyPal provides information for guidance purposes only and does not constitute a formal coverage decision or guarantee.',
    );
  }
}

class ClaimModel {
  final String id;
  final String userId;
  final String policyId;
  final DateTime incidentDate;
  final String description;
  final List<String> photoUrls;
  final AiAssessment aiAssessment;
  final String status;
  final DateTime createdAt;

  ClaimModel({
    required this.id,
    required this.userId,
    required this.policyId,
    required this.incidentDate,
    required this.description,
    required this.photoUrls,
    required this.aiAssessment,
    required this.status,
    required this.createdAt,
  });

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    String pId = '';
    if (json['policyId'] is Map) {
      pId = json['policyId']['_id'] ?? '';
    } else if (json['policyId'] is String) {
      pId = json['policyId'];
    }

    return ClaimModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      policyId: pId,
      incidentDate: DateTime.tryParse(json['incidentDate'] ?? '') ?? DateTime.now(),
      description: json['description'] ?? '',
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      aiAssessment: AiAssessment.fromJson(json['aiAssessment'] ?? {}),
      status: json['status'] ?? 'draft',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
