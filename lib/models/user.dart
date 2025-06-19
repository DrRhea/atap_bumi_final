class User {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? dateOfBirth;
  final String? profilePhoto;
  final String? memberStatus;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.dateOfBirth,
    this.profilePhoto,
    this.memberStatus,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      dateOfBirth: json['date_of_birth'],
      profilePhoto: json['profile_photo'],
      memberStatus: json['member_status'] ?? 'regular',
      role: json['role'] ?? 'user',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth,
      'profile_photo': profilePhoto,
      'member_status': memberStatus,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper methods
  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user';
}

