class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? familyGroupId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.familyGroupId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      familyGroupId: json['familyGroupId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'familyGroupId': familyGroupId,
    };
  }
}
