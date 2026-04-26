class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final bool emailVerified;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.emailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id:            json['id'].toString(),
    email:         json['email'] ?? '',
    name:          json['name']  ?? '',
    role:          json['role']  ?? 'user',
    emailVerified: json['email_verified'] ?? false,
  );
}